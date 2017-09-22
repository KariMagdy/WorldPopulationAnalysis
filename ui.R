#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(tidyr)
library(plotly)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  titlePanel("World Population Analysis"),
  
  navbarPage("Growth vs Distribution:",
                   tabPanel("How fast is population growing?",
                            h4("This plot displays the population growth in the selected region between 1960 and 2016"),
                          fluidRow(
                            column(3,
                                   radioButtons("plotType", "Plot Region:", choices = c("Africa","Americas","Asia","Europe","Oceania","World"))
                            ),
                            column(4, offset = 1,
                                   radioButtons("plotSize", "Show:", choices = c("Top 10 Countries", "Top 20 Countries","All"))
                                   )
                            ),
                          plotlyOutput("distPlot")),
  
                   tabPanel("Where are all these people?", leafletOutput("map"), h5("- The size of the circle indicates the number of people living in this country", h5("- Click on the center of the circle to display the population of desired country")))
             )
  )
)
