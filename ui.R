library(leaflet)
library(tidyverse)

# Choices for drop-downs
vars <- c(
  "Is SuperZIP?" = "superzip",
  "Centile score" = "centile",
  "College education" = "college",
  "Median income" = "income",
  "Population" = "adultpop"
)


navbarPage("Priority Conservation Areas for species representation in tropical Andean Countries", id="nav",
           
           tabPanel("Interactive map",
                    div(class="outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeScript("gomap.js")
                        ),
                        
                        # If not using custom CSS, set height of leafletOutput to a number instead of percent
                        leafletOutput("map", width = "100%", height = "100%"),
                        
                        # Shiny versions prior to 0.11 should use class = "modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = 60, right = "auto", bottom = "auto",
                                      width = 330, height = "auto",
                                      
                                      h2("Priority conservation areas in Tropical Andean Countries"),
                                      
                                      hr(),
                                      
                                      selectInput("solution", "Priority areas to represent species in:", selected = "pre85",
                                                  c("Present scenario" = "pre",
                                                    "Present and RCP 4.5" = "pre45",
                                                    "Present and RCP 8.5" = "pre85")),
                                      
                                      hr(),
                                      
                                      sliderInput("opacity", "Transparency:",
                                                  min = 0, max = 1, step = 0.1, value = 1),
                                      hr(),
                                      
                                      # selectInput("color", "Choose a color palette",
                                      #             c("blue" = "blue",
                                      #               "red" = "red",
                                      #               "green" = "green")),
                                      # 
                                      # hr(),
                                      
                                      h5("Download priority areas in raster format (Geotiff)"),
                                      
                                      downloadButton("download_solution", label = "Download")
                                      # selectInput("size", "Size", vars, selected = "adultpop"),
                                      # conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
                                      #                  # Only prompt for threshold when coloring or sizing by superzip
                                      #                  numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
                                      # )#,
                                      
                                      # plotOutput("histCentile", height = 200),
                                      # plotOutput("scatterCollegeIncome", height = 250)
                        ),
                        
                        tags$div(id="cite",
                                 "Javier Fajardo (2019) PhD Thesis, Chapter IV, UIMP")
                    )
           ),
           
           # tabPanel("Data explorer",
           #          fluidRow(
           #            column(3,
           #                   selectInput("states", "States", c("All states"="", structure(state.abb, names=state.name), "Washington, DC"="DC"), multiple=TRUE)
           #            ),
           #            column(3,
           #                   conditionalPanel("input.states",
           #                                    selectInput("cities", "Cities", c("All cities"=""), multiple=TRUE)
           #                   )
           #            ),
           #            column(3,
           #                   conditionalPanel("input.states",
           #                                    selectInput("zipcodes", "Zipcodes", c("All zipcodes"=""), multiple=TRUE)
           #                   )
           #            )
           #          ),
           #          fluidRow(
           #            column(1,
           #                   numericInput("minScore", "Min score", min=0, max=100, value=0)
           #            ),
           #            column(1,
           #                   numericInput("maxScore", "Max score", min=0, max=100, value=100)
           #            )
           #          ),
           #          hr(),
           #          DT::dataTableOutput("ziptable")
           # ),
           # tabPanel("Intro",
           #          column(12,
           #                 hr(),
           #                 includeHTML("Rmd/intro_main.html"))),
           
           tabPanel("About",
                    fluidRow(
                      column(3),
                      column(6, 
                             # h4("A description of the research and a link to the paper will appear here"),
                             includeHTML("Rmd/intro_main.html")
                             ),
                      column(3)
                      )
                    ),
                    
           
           conditionalPanel("false", icon("crosshair"))
)