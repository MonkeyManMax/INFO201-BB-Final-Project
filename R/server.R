library(shiny)
library(tidyverse)
library(educationdata)

# For loading the API on a new computer
# install.packages("devtools")
# devtools::install_github('UrbanInstitute/education-data-package-r')

shinyServer(function(input, output) {
 
  data <- read.delim("data/states_all.csv", sep = ",")
  
    
    
    output$distPlot <- renderPlot({
      yearlyRatio <- data %>%
        filter(YEAR == input$year, STATE != "DODEA", STATE != "NATIONAL") %>%
        mutate(RATIO = GRADES_ALL_G / TOTAL_EXPENDITURE) %>%
        select(RATIO, STATE)
      plot <- ggplot(yearlyRatio, aes(STATE, RATIO)) + geom_histogram(stat = "identity", binwidth = 1, position = position_dodge(10))
      
    return(plot)
      

    })

})
