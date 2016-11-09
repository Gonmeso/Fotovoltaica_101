library(shiny)
library(ggmap)
library(solaR)
library(htmltools)
source("SiarData.R")



 
##Función para formatear sencillamente, usado para los decimales de los PopUps

easyFormat <- function(x, y){
  
  format(round(x,y), nsmall = y)
  
}

##Creación del Icono usado para las estaciones meteorológicas
 
IconoPanel <- makeIcon(
  
  setwd("D:/TFG/Fotovoltaica 101/Fotovoltaica_101"),
  iconUrl = "www/SunIcon.png",
  iconWidth = 20,
  iconHeight = 20
  
)

##Contenido del PopUp de las estaciones

MPopup <- paste("<b>",DatosSiar$Estacion, "</b>",
                br(),
                "Provincia: ", DatosSiar$Provincia,
                br(),
                "Latitud: ",easyFormat(DatosSiar$lat, 2),
                br(),
                "Longitud: ", easyFormat(DatosSiar$lon, 2))

 
##Llamada al server
shinyServer(function(input, output) {
  
  ##Renderización del mapa para la salida por la interfaz (ui)
  
  output$Map <- renderLeaflet({
  
    leaflet() %>%
    addTiles() %>%  
    ##Adición de los marcadores de las estaciones, usando el popup descrito anteriormente, utilizando las coordenadas del archivo DatosSiar  
    addMarkers(
      DatosSiar$lon, DatosSiar$lat,
      icon = IconoPanel, group = "Estaciones",
      popup = MPopup
      )  %>%
    ##Control de capas, para permitir mostrar o no los marcadores de las estaciones, por defecto desactivado con hideGroup 
    addLayersControl(
      overlayGroups = "Estaciones",
      position = "bottomright",
      options = layersControlOptions(collapsed = FALSE)
      
    ) %>%
      
    hideGroup("Estaciones") %>%
    setView(lng=-3.7038, lat=40.4168, 5) 
  
  
  })

  
  posicion <- reactive(as.numeric(input$Map_click))

 
  ##Creación del marcador y el popup por introducción de coordenadas 
  observe({
    
  leafletProxy("Map") %>%
    
    clearGroup(group = "latMarker") %>%
    addMarkers(input$lonIn, input$latIn, group = "latMarker",
               popup = paste("<b>","La Latitud de este punto es: ","</b>",easyFormat(input$latIn, 2), br(),
                             
                             "<b>","La Longitud de este punto es: ","</b>", easyFormat(input$lonIn,2)))
    
    
  })
   
  ##Creación del marcador y popup por clic
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



     



   })
  
  lat1 <- reactive({
    pos <- input$Map_click
    as.numeric(pos$lat)
   
  })


   ##Creación de marcador y popup por introducción de la dirección
   observe({

     ##Recibe la dirección desde la UI
     direccion <- as.character(input$calle)
    
     ##Obtención de las coordenadas mediante geocode(), del paquete ggmap
     getPos <- geocode(direccion, 'latlon', source = 'google')
       
     
     leafletProxy("Map") %>%
  
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

   ##Obtención del dataframe de la estación seleccionada porr clic
   dataEstacion <- reactive({
     ##Debido al uso de funciones se encuentra esta condición, para evitar errores
     if(!is.null(input$Map_marker_click)){
      
      ##Latitud del clic  
      Num <- as.numeric(input$Map_marker_click$lat)
      
      ##Selecciona la fila de DatosSiar que coincide con el clic a la estación
      pillaDatos <- DatosSiar[DatosSiar$lat==Num,]
      
      ##Comprobación por consola
      PInfo <- as.vector(input$Map_marker_click)
      print(PInfo)
      print(pillaDatos)
      
      ##Se coge el dataframe de la estacion clicada
      estaEs <- AllData[pillaDatos$N_Estacion==AllData$IdEstacion&pillaDatos$N_Provincia==AllData$IdProvincia,] 
      
      return(as.data.frame(estaEs))
     }
     
   })
   
   ##Prueba del funcionamiento de la selección del dataframe por consola
   observe({
     if(!is.null(input$Map_marker_click)){
     print(dataEstacion())}
   })

})
