library(shiny)
library(tidyverse)
library(educationdata)

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
      plot <- ggplot(yearlyRatio, aes(Code, RATIO)) + geom_histogram(stat = "identity", binwidth = 1, position = position_dodge(10))
      
    return(plot)
    })
    
    output$linePlot <- renderPlot({
      cost <- statesData %>%
        filter(State == input$state, YEAR > input$yearLine[1], YEAR < input$yearLine[2]) %>%
        select(INSTRUCTION_EXPENDITURE, SUPPORT_SERVICES_EXPENDITURE, OTHER_EXPENDITURE, CAPITAL_OUTLAY_EXPENDITURE, YEAR)
      plot <- ggplot(cost, aes(x = YEAR)) + geom_line(aes(y = INSTRUCTION_EXPENDITURE)) + geom_line(aes(y = SUPPORT_SERVICES_EXPENDITURE)) + 
        geom_line(aes(y = OTHER_EXPENDITURE)) + geom_line(aes(y = CAPITAL_OUTLAY_EXPENDITURE))
      
    return(plot)
    })
    
    output$map <- renderPlot({
      
      mapData <- getDisciplineData(countyConversion, disciplineRates, input$race, input$sex)
      
      map <- ggplot(mapData, aes(long, lat, group = group)) + geom_polygon(aes(group=group, fill=Suspension_Rates)) +
        coord_quickmap() +
        theme(panel.grid = element_blank(),
              axis.title = element_blank(),
              axis.text = element_blank(),
              axis.ticks = element_blank(),
              panel.background = element_blank())
      
      return(map)
    })
    
    output$pieChart <- renderPlot({
      pieData <- sat_act_participation %>%
      filter(year == input$yearPie, fips == input$statePie)%>%
      group_by(.data [[input$sexorrace]])%>%
      summarise(total_participation = sum(total_participation))
    
    
    pieChart <- ggplot(pieData, aes(x = "", y = total_participation, fill = .data[[input$sexorrace]])) + geom_bar(stat = "identity", width = 1) +
      coord_polar("y", start = 0) + theme_void()
    return(pieChart)
  
      
      
      
    })

})
