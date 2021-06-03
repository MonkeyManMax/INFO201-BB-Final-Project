library(shiny)
library(tidyverse)
library(ggrepel)
library(knitr)

# For loading the API on a new computer
# install.packages("devtools")
# devtools::install_github('UrbanInstitute/education-data-package-r')

shinyServer(function(input, output) {
    
    options(scipen=999)
    statesData <- read.delim("data/states_all.csv", sep = ",")
    countyConversion <- read.delim("data/fips_to_coords.csv", sep = ",")
    disciplineRates <- read.delim("data/discipline_rates.csv", sep = ",")
    sat_act_participation <- read.delim("data/sat_act_participation.csv", sep = ",")
    
    getDisciplineData <- function(countyConversion, disciplineRates, therace, thesex) {
      disciplineRates <- disciplineRates %>%
        filter(race == therace, sex == thesex) %>%
        full_join(countyConversion, by = "fips")
      
      return(disciplineRates)
    }
    
    output$barPlot <- renderPlot({
      
      yearlyRatio <- statesData %>%
        filter(YEAR == input$yearBar, State != "DODEA", State != "NATIONAL") %>%
        mutate(RATIO = GRADES_ALL_G / TOTAL_EXPENDITURE) %>%
        select(RATIO, Code)
      
      plot <- ggplot(yearlyRatio, aes(Code, RATIO)) + geom_histogram(stat = "identity", binwidth = 1, position = position_dodge(10)) +
        labs(title = paste0(input$yearBar, " Expenditure to Student Ratio"), x = "State", y = "Student to Expenditure Ratio (Students / USD)")
      
    return(plot)
    })
    
    output$linePlot <- renderPlot({
        
      cost <- statesData %>%
        filter(State == input$stateLine, YEAR >= input$yearLine[1], YEAR <= input$yearLine[2]) %>%
        select(INSTRUCTION_EXPENDITURE, SUPPORT_SERVICES_EXPENDITURE, OTHER_EXPENDITURE, CAPITAL_OUTLAY_EXPENDITURE, YEAR) %>%
        gather(key = "variable", value = "value", -YEAR)
      
      plot <- ggplot(cost, aes(x = YEAR, y = value)) + 
        geom_line(aes(color = variable), size = 1) + 
        scale_color_manual(labels = c("Capital Outlay Expenditure", "Instruction Expenditure",
                                      "Other Expenditure", "Support Services Expenditure"),
                           values = c("blue", "red", "green", "yellow")) +
        labs(title = paste("Expenditure Breakdown for ", input$stateLine, " from ", input$yearLine[1], " to ", input$yearLine[2], sep = ""),
             y = "Expenditure (USD)", x = "Year", color = "Type of Expenditure") + 
        scale_x_continuous(minor_breaks = seq(input$yearLine[1], input$yearLine[2], 1))
      
    return(plot)
    })
    
    output$map <- renderPlot({
      
    mapData <- getDisciplineData(countyConversion, disciplineRates, input$race, input$sex)
    
    sexConv <- c("Male", "Female")
    raceConv <- c("White", "Black", "Hispanic", "Asian", "American Indian or Alaska Native",
                  "Native Hawaiian or Pacific Islander", "Two or more races")
      
    map <- ggplot(mapData, aes(long, lat, group = group)) + 
        geom_polygon(aes(group=group, fill=Suspension_Rates), color = "black") +
        coord_quickmap() +
        theme(panel.grid = element_blank(),
              axis.title = element_blank(),
              axis.text = element_blank(),
              axis.ticks = element_blank(),
              panel.background = element_blank()) + 
      labs(fill = "Suspension Rates",
           title = paste0("2015 Suspension Rates for ", raceConv[strtoi(input$race)], " ", sexConv[strtoi(input$sex)], "s"))
    
      return(map)
    })
    
    output$pieChart <- renderPlot({

      countyConversionPie <- countyConversion %>%
        group_by(region) %>%
        slice(1) %>%
        ungroup() %>%
        select(region, fips) %>%
        add_row(region = "alaska", fips = 2) %>%
        add_row(region = "hawaii", fips = 15) %>%
        mutate(region = str_to_title(region)) %>%
        filter(fips == input$statePie)
      
    state <- countyConversionPie [[1, 1]]
      
    pieData <- sat_act_participation %>%
      filter(year == input$yearPie, fips == input$statePie)%>%
      group_by(.data [[input$sexorrace]])%>%
      summarise(total_participation = sum(total_participation)) %>%
      ungroup() %>%
      mutate(percent = round(total_participation * 100 / sum(total_participation), 2))
    
    pieNames <- pieData %>% 
      mutate(csum = rev(cumsum(rev(percent))), 
             pos = percent/2 + lead(csum, 1),
             pos = if_else(is.na(pos), percent/2, pos))
    
    pieChart <- ggplot(pieData, aes(x = "" , y = percent, fill = fct_inorder(.data[[input$sexorrace]]))) +
      geom_col(width = 1, color = 1) +
      coord_polar(theta = "y") +
      scale_fill_brewer(palette = "Pastel2") +
      geom_label_repel(data = pieNames,
                       aes(y = pos, label = paste0(percent, "%")),
                       size = 4.5, nudge_x = 1, show.legend = FALSE) +
      guides(fill = guide_legend(title = str_to_title(input$sexorrace))) +
      theme_void() + 
      labs(title = paste0(state, " SAT and ACT Participation by ", str_to_title(input$sexorrace), " in ", input$yearPie))
    
    return(pieChart)
      
    })
    
    output$overview <- renderUI({
      HTML(markdown::markdownToHTML(knit('introPage.rmd', quiet = TRUE)))
    })

})
