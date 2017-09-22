#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
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

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  contpop <- read.csv("continentsPopulation.csv")
  fulldf <- read.csv("Locations.csv")
   
  smallIcon <- makeIcon(
    iconUrl = "https://image.flaticon.com/icons/svg/149/149060.svg",
    iconWidth = 5, iconHeight = 5
  )
  
  plottedCountries <- reactive({ 
    if (input$plotSize == "All"){
      selectedCountries()
    }
    else if (input$plotSize == "Top 10 Countries"){
      SC <- selectedCountries()
      countries <- SC[SC$year == 2016,]
      countries <- countries[order(-countries$population),]
      SC <- SC[SC$CountryCode %in% countries[1:10,1],]
    }
    else{
      SC <- selectedCountries()
      countries <- SC[SC$year == 2016,]
      countries <- countries[order(-countries$population),]
      SC <- SC[SC$CountryCode %in% countries[1:20,1],]
    }
  })
  
  selectedCountries <- reactive({ 
    if (input$plotType == "World"){
      contpop
    }
    else{
    contpop[contpop$region == input$plotType,] 
    }
    })
  
  output$distPlot <- renderPlotly({
    # generate bins based on input$bins from ui.R
    return(add_lines(plot_ly(plottedCountries(), x = ~year, y = ~population, color = ~CountryCode)))
  })
  
  output$map <- renderLeaflet({
    fulldf %>% 
      leaflet() %>% 
      addTiles() %>% 
      setView(lat = 0, lng = 0, zoom = 2) %>%
      addCircles(weight = 1, radius = (fulldf$X2016/500)) %>% 
      addMarkers(icon = smallIcon, popup = sapply(fulldf$X2016,toString))
  })
  
})
