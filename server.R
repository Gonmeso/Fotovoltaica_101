 library(shiny)

 handleEvent <- function(button, handler) {
   fun <- exprToFunction(button)
   observe({
     val <- fun()
     if (is.null(val) || identical(val, 0))
       return()
     
     isolate(handler())
   })
 }
 
 
##Llamada al server
shinyServer(function(input, output) {
  
  
  puntos <- eventReactive(input$Mapa_click,{
    
      cbind(input$Mapa_click)
    
    },
   ignoreNULL = FALSE
  
  )
  
  output$Mapa <- renderLeaflet({
  
    leaflet() %>%
    addTiles() %>%  
    # addMarkers( lat = input$Mapa_click$lat, lng = input$Mapa_click$lng) %>%
    setView(lng=-3.7038, lat=40.4168, 5) 
  
    handleEvent(input$Mapa_click, function() {
      if (!input$addMarkerOnClick)
        return()
      Mapa$addMarker(input$Mapa_click$lat, input$Mapa_click$lng, NULL)
      values$markers <- rbind(data.frame(lat=input$Mapa_click$lat,
                                         long=input$Mapa_click$lng),
                              values$markers)
    
    
  })
  })
   


  # LatPopUp <- function()
  # 
  # 
  # observe({
  #   
  #   leafletProxy("Mapa") %>% clearPopups()
  #   
  #   getLat <- input$map_shape_click
  #   
  #   if(is.null(getLat))
  #     return()
  # 
  # })

})
