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

easyFormat <- function(x, y){
  
  format(round(x,y), nsmall = y)
  
}
 
IconoPanel <- makeIcon(
  
  iconUrl = "www/SunIcon.png",
  iconWidth = 20,
  iconHeight = 20
  
)

MPopup <- paste("<b>",DatosSiar$Estacion, "</b>",
                br(),
                "Provincia: ", DatosSiar$Provincia,
                br(),
                "Latitud: ",easyFormat(DatosSiar$lat, 2),
                br(),
                "Longitud: ", easyFormat(DatosSiar$lon, 2))

 
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
    setView(lng=-3.7038, lat=40.4168, 5) 
  
  
  })

  
  posicion <- reactive(as.numeric(input$Map_click))

  # output$Click_text<-renderText(paste0(posicion$lng, ' ', posicion$lat))
  observe({
    
  leafletProxy("Map") %>%
    ##clearMarkers(group = "latMarker") %>%
    clearGroup(group = "latMarker") %>%
    addMarkers(input$lonIn, input$latIn, group = "latMarker",
               popup = paste("<b>","La Latitud de este punto es: ","</b>",easyFormat(input$latIn, 2), br(),
                             
                             "<b>","La Longitud de este punto es: ","</b>", easyFormat(input$lonIn,2)))
    
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
                  popup = paste("<b>","La Latitud de este punto es: ","</b>",easyFormat(pos$lat,2), br(),
                                
                                "<b>","La Longitud de este punto es: ","</b>", easyFormat(pos$lng,2)))



     # output$Click_text<-renderText(paste0(pos$lng,' ', pos$lat))



   })
  
  lat1 <- reactive({
    pos <- input$Map_click
    as.numeric(pos$lat)
   
  })


  
   observe({

     direccion <- as.character(input$calle)

     getPos <- geocode(direccion, 'latlon', source = 'google')
     
     lat1 <- getPos$lat
       
     
     leafletProxy("Map") %>%
       ##clearMarkers() %>%
       clearGroup(group = "latMarker") %>%
       addMarkers(getPos$lon, getPos$lat, group = "latMarker",
                  popup = paste("<b>","La Latitud de este punto es: ","</b>",easyFormat(getPos$lat, 2), br(),
                                
                                "<b>","La Longitud de este punto es: ","</b>", easyFormat(getPos$lon,2)))
    
     
     # output$Click_text<-renderText(paste0(getPos$lon,' ', getPos$lat))

     
     return(getPos)
     
   })

   ##Obtener la latitud y longitud de las marcadores originales
   
   lat2 <- reactive({
     pos <- input$Map_marker_click$lat
     as.numeric(pos)
     
  })
   
   lng2 <- reactive({
     pos <- input$Map_marker_click$lng
     as.numeric(pos)
     
   })

   observe({
     
     PInfo <- as.vector(input$Map_marker_click)
     print(PInfo)
     
   })
  
})
