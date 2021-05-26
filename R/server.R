library(shiny)
library(tidyverse)
library(educationdata)

# For loading the API on a new computer
# install.packages("devtools")
# devtools::install_github('UrbanInstitute/education-data-package-r')

shinyServer(function(input, output) {
  
    
    
    output$distPlot <- renderPlot({

    })

})
