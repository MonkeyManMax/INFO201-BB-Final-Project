library(shiny)

shinyUI(fluidPage(

    # Application title
    titlePanel(""),
    
    navbarPage("Navbar",
        tabPanel("Overview"
        ),
        tabPanel("Barchart",
            sidebarLayout(
                sidebarPanel(
                    sliderInput(
                        "yearBar",
                        "Year",
                        min = 1992,
                        max = 2018,
                        value = 1992,
                        ticks = FALSE
                    )
                ),
                mainPanel(
                    plotOutput("barPlot")
                )
            )
        ),
        tabPanel("Map",
            sidebarLayout(
                sidebarPanel(
                    selectInput(
                        "sex",
                        "Sex",
                        choices = list("Male" = 1, "Female" = 2)
                    ),
                    selectInput(
                        "race",
                        "Race",
                        choices = list("White" = 1, "Black" = 2, "Hispanic" = 3,
                        "Asian" = 4, "American Indian or Alaska Native" = 5, 
                        "Native Hawaiian or other Pacific Islander" = 6, 
                        "Two or more races" = 7)
                    )
                ),
                mainPanel(
                    plotOutput("map")
                )
            )
        ),
        tabPanel("Piechart"
        ),
        tabPanel("Line Graph",
                 sidebarLayout(
                     sidebarPanel(
                         selectInput(
                             "state",
                             "State",
                             c("Alabama", "Alaska", "Arizona", "Arkansas", "California",
                               "Colorado", "Connecticut", "Delaware", "District of columbia",
                               "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", 
                               "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
                               "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", 
                               "Montana", "Nebraska", "Nevada", "New hampshire", "New jersey", 
                               "New Mexico", "New York", "North carolina", "North dakota",
                               "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode island",
                               "South carolina", "South dakota", "Tennessee", "Texas", "Utah",
                               "Vermont", "Virginia", "Washington", "West virginia", "Wisconsin",
                               "Wyoming")
                         ),
                         sliderInput(
                             "yearLine",
                             "Year",
                             min = 1992,
                             max = 2018,
                             value = c(1992, 2018),
                             ticks = FALSE
                         )
                     ),
                     mainPanel(
                         plotOutput("linePlot")
                     )
                )
        )
    )
))
