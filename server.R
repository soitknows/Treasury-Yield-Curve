library(shiny)
library(xml2)
library(ggplot2)
library(plotly)

getData <- function (year, bond1_input, bond2_input){
  baseUrl = "https://home.treasury.gov/resource-center/data-chart-center/interest-rates/pages/xml?data=daily_treasury_yield_curve"
  url <- paste0(baseUrl,"&field_tdr_date_value=",toString(year))
  download_xml(url, file = "TYC.xml")
  doc <- read_xml("TYC.xml")
  entries <- xml_find_all(doc, ".//m:properties")
  param1 = paste("d:BC_", bond1_input, sep="")
  param2 = paste("d:BC_", bond2_input, sep="")
  
  date <- xml_text((xml_find_first(entries, "d:NEW_DATE")))
  
  return <- xml_text((xml_find_first(entries, param1)))
  df1 <- data.frame(date, return)
  df1$date <- as.Date(df1$date)
  df1$return <- as.numeric(as.character(df1$return))
  
  return <- xml_text((xml_find_first(entries, param2)))
  df2 <- data.frame(date, return)
  df2$date <- as.Date(df2$date)
  df2$return <- as.numeric(as.character(df2$return))
  
  d <- merge(df1, df2, by="date")
  colnames(d) <- c("Date", "Bond1", "Bond2")
  d
}


function (input, output) {
  df <- reactive({
    bond_data <- getData(input$year, input$bond1, input$bond2)
  })
  
  output$stats<- renderPlotly({
    plot_ly(df(), x= ~Date, y= ~Bond1, type='scatter', mode = 'lines', name=input$bond1) %>%
      add_trace(y = ~Bond2, name = input$bond2) %>% 
      layout(xaxis = list(title="DATE"), yaxis = list(title="RATE"))
  })
}