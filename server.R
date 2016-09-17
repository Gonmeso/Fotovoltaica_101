 library(shiny)


 
 df <- data.frame()
 
 # getInfo <- reactive(input$Mapa_click,{
 #   
 #   df <- cbind(input$Mapa_click, df)
 # 
 #   
 # })
 # 
 
 
##Llamada al server
shinyServer(function(input, output) {
  

    
  
  

  
  output$Mapa <- renderLeaflet({
  
    leaflet() %>%
    addTiles() %>%  
    setView(lng=-3.7038, lat=40.4168, 5) 
  
  
  })
   

  posicion <- reactive(input$Mapa_click)
  getLat <- reactive(input$Mapa_click$lat)
  getLat <- as.numeric(getLat)
  output$Click_text<-renderText(paste0(posicion()))
  output$Glat<-renderText(paste0(getLat))


})
