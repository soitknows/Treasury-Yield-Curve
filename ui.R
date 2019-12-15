library(shiny)
library(xml2)

years <- (1990:2019)
bonds = c("1MONTH","2MONTH","3MONTH","6MONTH","1YEAR","2YEAR","3YEAR","5YEAR","7YEAR","10YEAR","20YEAR","30YEAR")

ui <- fluidPage(
  selectInput(inputId = "year",
              label = "Year",
              choices = years),
  
  selectInput(inputId = "bond1",
              label = "Bond 1",
              choices = bonds),
  
  selectInput(inputId = "bond2",
              label = "Bond 2",
              choices = bonds),
  
  plotOutput(outputId = "stats")
)