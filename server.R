library(curl)
library(shiny)
library(ggplot2)
library(plotly)

getData <- function (year, bond1_input, bond2_input){
  url = paste("https://data.treasury.gov/feed.svc/DailyTreasuryYieldCurveRateData?$filter=year(NEW_DATE)%20eq%20",toString(year), sep="")
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
  
  df <- merge(df1, df2, by="date")
  df <- reshape2::melt(df, id.var="date")
}


function (input, output) {
  df <- reactive({
    
    bond_data <- getData(input$year, input$bond1, input$bond2)
  })
  
  output$stats<- renderPlot({
    ggplot(df(), aes(x=date, y=value, col=variable)) + 
      geom_line() + 
      scale_color_discrete(name="Bonds", breaks=c("return.x", "return.y"), labels=c(input$bond1, input$bond2)) +
      scale_y_continuous(limits = c(0, 9))
  })
}