library(shiny)

shinyUI(fluidPage(

    # Application title
    titlePanel(""),

    # Sidebar
    sidebarLayout(
        sidebarPanel(
            sliderInput(
                "year",
                "Year",
                min = 1992,
                max = 2018,
                value = 1,
                ticks = FALSE
            )
            
        ),

        # Main Panel 
        mainPanel(
plotOutput("distPlot")
        )
    )
))
