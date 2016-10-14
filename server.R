library(shiny)
library(ggmap)
library(solaR)
library(htmltools)
source("SiarData.R")



 
lat1 <- 0
lat2 <- 0
lng1 <- 0
lng2 <- 0
df <- data.frame()
 
IconoPanel <- makeIcon(
  
  iconUrl = "www/SolarIcon.svg",
  iconWidth = 38,
  iconHeight = 38
  
)

MPopup <- paste("<b>",DatosSiar$Estacion, "</b>",
                br(),
                "Provincia: ", DatosSiar$Provincia,
                br(),
                "Latitud: ",DatosSiar$lat,
                br(),
                "Longitud: ", DatosSiar$lon)

 
##Llamada al server
shinyServer(function(input, output) {
  
  
  output$Map <- renderLeaflet({
  
    leaflet() %>%
    addTiles() %>%  
    addMarkers(
      DatosSiar$lon, DatosSiar$lat,
      icon = IconoPanel, group = "Estaciones",
      popup = MPopup
      )  %>%
    addLayersControl(
      overlayGroups = "Estaciones",
      position = "bottomright",
      options = layersControlOptions(collapsed = FALSE)
      
    ) %>%
    hideGroup("Estaciones") %>%
    setView(lng=-3.7038, lat=40.4168, 6) 
  
  
  })

  
  posicion <- reactive(as.numeric(input$Map_click))

  # output$Click_text<-renderText(paste0(posicion$lng, ' ', posicion$lat))
  observe({
    
  leafletProxy("Map") %>%
    ##clearMarkers(group = "latMarker") %>%
    clearGroup(group = "latMarker") %>%
    addMarkers(input$lonIn, input$latIn, group = "latMarker",
               popup = paste("<b>","La Latitud de este punto es: ","</b>",input$latIn, br(),
                             
                             "<b>","La Longitud de este punto es: ","</b>", input$lonIn))
    
    # output$Click_text<-renderText(paste0(input$lonIn,' ',input$latIn))
  })
   
   observe({
     
     pos <- input$Map_click
     if (is.null(pos))
       return()
     leafletProxy("Map") %>%
       ##clearMarkers() %>%
       clearGroup(group = "latMarker") %>%
       
       addMarkers(pos$lng, pos$lat,group = "latMarker",
                  popup = paste("<b>","La Latitud de este punto es: ","</b>",pos$lat, br(),
                                
                                "<b>","La Longitud de este punto es: ","</b>", pos$lng))



     # output$Click_text<-renderText(paste0(pos$lng,' ', pos$lat))



   })
  


   observe({

     direccion <- as.character(input$calle)

     getPos <- geocode(direccion, 'latlon', source = 'google')
     
     
       
     
     leafletProxy("Map") %>%
       ##clearMarkers() %>%
       clearGroup(group = "latMarker") %>%
       addMarkers(getPos$lon, getPos$lat, group = "latMarker",
                  popup = paste("<b>","La Latitud de este punto es: ","</b>",getPos$lat, br(),
                                
                                "<b>","La Longitud de este punto es: ","</b>", getPos$lon))
    
     
     # output$Click_text<-renderText(paste0(getPos$lon,' ', getPos$lat))
     
     
     return(getPos)
     
   })

   


 
  
})
