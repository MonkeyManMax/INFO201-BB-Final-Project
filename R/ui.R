library(shiny)

shinyUI(fillPage(

    # Application title
    titlePanel(""),
    
    navbarPage("School Data",
        tabPanel("Overview",
                 uiOutput("overview")
        ),
        tabPanel("Student to Funding Ratio",
            titlePanel("Hello"),
            sidebarLayout(
                sidebarPanel(
                    sliderInput(
                        "yearBar",
                        "Year",
                        min = 1992,
                        max = 2018,
                        value = 1992,
                        ticks = TRUE,
                        sep = ""
                    )
                ),
                mainPanel(
                    plotOutput("barPlot")
                )
            )
        ),
        tabPanel("Suspension Rates",
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
        tabPanel("SAT / ACT Participation",
                 sidebarLayout(
                     sidebarPanel(
                         radioButtons(
                         "sexorrace",
                         "Sex or Race",
                         choices = list("Sex" = "sex", "Race" = "race")
                     ),
                     selectInput(
                         "statePie",
                         "State",
                         c("Alabama" = 1, "Alaska" = 2, "Arizona" = 4, "Arkansas" = 5, "California" = 6,
                           "Colorado" = 8, "Connecticut" = 9, "Delaware" = 10, "District Of Columbia" = 11,
                           "Florida" = 12, "Georgia" = 13, "Hawaii" = 15, "Idaho" = 16, "Illinois" = 17, "Indiana" = 18, 
                           "Iowa" = 19, "Kansas" = 20, "Kentucky" = 21, "Louisiana" = 22, "Maine" = 23, "Maryland" = 24,
                           "Massachusetts" = 25, "Michigan" = 26, "Minnesota" = 27, "Mississippi" = 28, "Missouri" = 29, 
                           "Montana" = 30, "Nebraska" = 31, "Nevada" = 32, "New Hampshire" = 33, "New Jersey" = 34, 
                           "New Mexico" = 35, "New York" = 36, "North Carolina" = 37, "North Dakota" = 38,
                           "Ohio" = 39, "Oklahoma" = 40, "Oregon" = 41, "Pennsylvania" = 42, "Rhode Island" = 44,
                           "South Carolina" = 45, "South Dakota" = 46, "Tennessee" = 47, "Texas" = 48, "Utah" = 49,
                           "Vermont" = 50, "Virginia" = 51, "Washington" = 53, "West Virginia" = 54, "Wisconsin" = 55,
                           "Wyoming" = 56)
                         
                     ),
                     selectInput(
                         "yearPie",
                         "Year",
                         c(2011, 2013, 2015, 2017)
                     )
                     ),
                     mainPanel(
                         plotOutput("pieChart")
                     )
                 )
        ),
        tabPanel("Expenditure",
                 sidebarLayout(
                     sidebarPanel(
                         selectInput(
                             "stateLine",
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
                             max = 2016,
                             value = c(1992, 2018),
                             ticks = TRUE,
                             sep = ""
                         )
                     ),
                     mainPanel(
                         plotOutput("linePlot")
                     )
                )
        )
    )
))
