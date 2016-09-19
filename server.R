 library(shiny)
 library(ggmap)
 library(solaR)


 
lat1 <- 0
lat2 <- 0
lng1 <- 0
lng2 <- 0
df <- data.frame()
 
 
##Llamada al server
shinyServer(function(input, output) {
  
  
  output$Map <- renderLeaflet({
  
    leaflet() %>%
    addTiles() %>%  
    setView(lng=-3.7038, lat=40.4168, 5) 
  
  
  })

  
  posicion <- reactive(as.numeric(input$Map_click))

  output$Click_text<-renderText(paste0(posicion()))

   
   
   observe({
     
     pos <- input$Map_click
     if (is.null(pos))
       return()
     leafletProxy("Map") %>%
       clearMarkers() %>%
       addMarkers(pos$lng, pos$lat)
     
     df <- pos$lng
     lat1 <- pos$lat

   })
  
   output$calle <- renderPrint({
     
     direccion <- as.character(input$calle)
     
     geocode(direccion, 'latlon', source = 'google')
     
   })

   
reactive(print(input$pos$lat))

 
  
})
