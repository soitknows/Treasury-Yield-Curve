library(shiny)
library(xml2)
library(plotly)


years <- (1990:substr(Sys.Date(),0,4))
bonds = c("1MONTH","2MONTH","3MONTH","6MONTH","1YEAR","2YEAR","3YEAR","5YEAR","7YEAR","10YEAR","20YEAR","30YEAR")
treas_url = "https://www.treasury.gov/resource-center/data-chart-center/interest-rates/Pages/TextView.aspx?data=yield"
treas_link <- a("U.S. Treasury Department", href=treas_url)
tags <- tagList("DATA SOURCE:  ", treas_link)


ui <- fluidPage(
  
  titlePanel("U.S. Daily Treasury Yield Curve"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "year",
                  label = "Year",
                  choices = years),
      selectInput(inputId = "bond1",
                  label = "Bond 1",
                  choices = bonds),
      
      selectInput(inputId = "bond2",
                  label = "Bond 2",
                  choices = bonds),
     width = 2
  ), 
    
    mainPanel(
      plotlyOutput(outputId = "stats"),
      width = 10
  )
  ),
  

  

  
  
  helpText(tags)

  
 
  

)
