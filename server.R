library(shiny)
library(ggmap)
library(solaR)
library(htmltools)
library(rsconnect)
source("SiarData.R")



 
##Función para formatear sencillamente, usado para los decimales de los PopUps

easyFormat <- function(x, y){
  
  format(round(x,y), nsmall = y)
  
}

##Creación del Icono usado para las estaciones meteorológicas
 
IconoPanel <- makeIcon(
  
##  setwd("D:/TFG/Fotovoltaica 101/Fotovoltaica_101"),
  iconUrl = "www/SunIcon.png",
  iconWidth = 20,
  iconHeight = 20
  
)

##Contenido del PopUp de las estaciones

MPopup <- paste("<b>",DatosSiar$Estacion, "</b>",
                br(),
                "Provincia: ",
                DatosSiar$Provincia,
                br(),
                "Latitud: ",
                easyFormat(DatosSiar$lat, 2),
                br(),
                "Longitud: ",
                easyFormat(DatosSiar$lon, 2))

 
##Llamada al server
shinyServer(function(input, output) {
  
  ##Renderización del mapa para la salida por la interfaz (ui)
  
  output$Map <- renderLeaflet({
  
    leaflet() %>%
    addTiles() %>%  
    ##Adición de los marcadores de las estaciones, usando el popup descrito anteriormente, utilizando las coordenadas del archivo DatosSiar  
    addMarkers(
        DatosSiar$lon, DatosSiar$lat,
        layerId = DatosSiar$ID,
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
    addMarkers(input$lonIn,
               input$latIn,
               group = "latMarker",
               popup = paste("<b>",
                             "La Latitud de este punto es: ",
                             "</b>",
                             easyFormat(input$latIn, 2),
                             br(),
                             "<b>",
                             "La Longitud de este punto es: ",
                             "</b>",
                             easyFormat(input$lonIn,2)))
    
    
  })
   
  ##Creación del marcador y popup por clic
   observe({
     
     pos <- input$Map_click
     if (is.null(pos))
       return()
     leafletProxy("Map") %>%
       ##clearMarkers() %>%
       clearGroup(group = "latMarker") %>%
       
       addMarkers(pos$lng,
                  pos$lat,
                  group = "latMarker",
                  popup = paste("<b>",
                                "La Latitud de este punto es: ",
                                "</b>",
                                easyFormat(pos$lat,2),
                                br(),
                                "<b>",
                                "La Longitud de este punto es: ",
                                "</b>", easyFormat(pos$lng,2)))


   })
  



   ##Creación de marcador y popup por introducción de la dirección
   observe({

     ##Recibe la dirección desde la UI
     direccion <- as.character(input$calle)
    
     ##Obtención de las coordenadas mediante geocode(), del paquete ggmap
     getPos <- geocode(direccion,
                       'latlon',
                       source = 'google')
       
     
     leafletProxy("Map") %>%
  
       clearGroup(group = "latMarker") %>%
       
       addMarkers(getPos$lon,
                  getPos$lat,
                  group = "latMarker",
                  popup = paste("<b>",
                                "La Latitud de este punto es: ",
                                "</b>",
                                easyFormat(getPos$lat, 2),
                                br(),
                                "<b>",
                                "La Longitud de este punto es: ",
                                "</b>",
                                easyFormat(getPos$lon,2)))
    
     
     # output$Click_text<-renderText(paste0(getPos$lon,' ', getPos$lat))

     
     return(getPos)
     
   })

   ##Obtener la latitud y longitud de las marcadores originales
   
   lat2 <- reactive({
     
     input$Map_marker_click$lat
    
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
      ##Num <- as.numeric(input$Map_marker_click$lat)
      clickID <- input$Map_marker_click$id
      ##Selecciona la fila de DatosSiar que coincide con el clic a la estación
      pillaDatos <- DatosSiar[ID == clickID]
      
      ##Comprobación por consola
      PInfo <- as.vector(input$Map_marker_click)
      print(PInfo)
      print(pillaDatos)
      
      ##Se coge el dataframe de la estacion clicada
      estaEs <- AllData[ID == clickID]
      
      ##Paso de MJ/m2 a Wh/m2
      estaEs$G0 <- estaEs$G0*1000000/3600
      
      estaEs
     }
     
   })
   
   ##Prueba del funcionamiento de la selección del dataframe por consola
   observe({
     
     if(!is.null(input$Map_marker_click)){
       
       print(dataEstacion())
       
       a <- as.data.frame(fSolD(as.numeric(lat2()), fBTd("serie")))
       
       print(horizontalPlane())
       
       
       print(head(a))
       
       output$grafico <-  renderPlot({
         
         px1 <- xyplot(horizontalPlane())
         px2 <- xyplot(generatorPlane())
                                     
         print(px1, position=c(0, .5, 1, 1), more=TRUE)
         print(px2, position=c(0, 0, 1, .5))
         
         box("figure")
                                     })
      
     }
     
       print(generatorPlane())
       print(head(aRed()))

     })
   
   observe({
     
     if(!is.null(input$Map_marker_click)){
       
       lat <- lat2()
       lng <- lng2()
       
       if(lat>43.81|lat<35.76|lng>3.94|lng< -9.27){
       
       showModal(modalDialog(
         
         title = "UPS!",
         "No tenemos datos para esta zona, actualmente solo tenemos datos de España",
         easyClose = TRUE
         
       ))
       
       }
         
     }
     
   })
   


   
# ///////SOLAR//////
   
   ##Movimiento relativo, sirve tanto para estaciones como click
   dailyMove <- reactive({
     
     if(!is.null(input$Map_marker_click)){
       
       calcSol(as.numeric(lat2()), fBTd("serie"))
       
     }
     
     
   })  
   

   horizontalPlane <- reactive({
     
     if(!is.null(input$Map_marker_click)){
       
       datos <- as.data.frame(dataEstacion())

       SolD <- fSolD(as.numeric(lat2()),
                     fBTd("serie", year = as.POSIXlt(Sys.Date())$year+1900-1))
       
       G0d <- zoo(datos$G0, index(SolD))
       Ta <- zoo(datos$Ta, index(SolD))
       G0d <- cbind.zoo(G0=G0d,Ta=Ta)

       calcG0(as.numeric(lat2()),
              modeRad = "bd",
              dataRad= G0d)
     }
     
   })
   
  generatorPlane <- reactive({
    
    if(!is.null(input$Map_marker_click)){
    
    g0 <- horizontalPlane()
    
    calcGef(lat2(),modeRad = 'prev', dataRad = g0)
    
    }
    
  })
   
  aRed <- reactive({
    
    if(!is.null(input$Map_marker_click)){
      
      inclin <- generatorPlane()
      
      fProd(inclin)
      
    }
    
  })
  

})
