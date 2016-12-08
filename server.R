library(shiny)
library(ggmap)
library(solaR)
library(htmltools)
library(rsconnect)
source("SiarData.R")



 
##Funci贸n para formatear sencillamente, usado para los decimales de los PopUps

easyFormat <- function(x, y){
  
  format(round(x,y), nsmall = y)
  
}

##Creaci贸n del Icono usado para las estaciones meteorol贸gicas
 
IconoPanel <- makeIcon(
  
  # setwd('Fotovoltaica_101/'),
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
shinyServer(function(input, output, session) {
  
  ##Renderizaci贸n del mapa para la salida por la interfaz (ui)
  
  output$Map <- renderLeaflet({
  
    leaflet() %>%
    addTiles() %>%  
    ##Adici贸n de los marcadores de las estaciones, usando el popup descrito anteriormente, utilizando las coordenadas del archivo DatosSiar  
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

 
  ##Creaci贸n del marcador y el popup por introducci贸n de coordenadas 
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
   
  ##Creaci贸n del marcador y popup por clic
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
  



   ##Creaci贸n de marcador y popup por introducci贸n de la direcci贸n
   observe({

     ##Recibe la direcci贸n desde la UI
     direccion <- as.character(input$calle)
    
     ##Obtenci贸n de las coordenadas mediante geocode(), del paquete ggmap
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

   ##Obtenci贸n del dataframe de la estaci贸n seleccionada porr clic
   dataEstacion <- reactive({
     ##Debido al uso de funciones se encuentra esta condici贸n, para evitar errores
     if(!is.null(input$Map_marker_click)){
      
      ##Latitud del clic  
      ##Num <- as.numeric(input$Map_marker_click$lat)
      clickID <- input$Map_marker_click$id
      ##Selecciona la fila de DatosSiar que coincide con el clic a la estaci贸n
      pillaDatos <- DatosSiar[ID == clickID]
      
      ##Comprobaci贸n por consola
      PInfo <- as.vector(input$Map_marker_click)
      print(PInfo)
      print(pillaDatos)
      
      ##Se coge el dataframe de la estacion clicada
      estaEs <- AllData[ID == clickID]
      
      estaEs
     }
     
   })
   
   ##Prueba del funcionamiento de la selecci贸n del dataframe por consola
   observe({
     
     Datos_Est<- dataEstacion()
     
     if(!is.null(input$Map_marker_click)){
       
       if(!is.na(Datos_Est[1,1])&exists('DatosSiar')){
       
       print(Datos_Est)
       
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
       
       print(generatorPlane())
       print(aRed())
      
     }
     


     } 
     })
   
   observe({
     
     if(!is.null(input$Map_marker_click)){
       
       lat <- lat2()
       lng <- lng2()
       
       if(lat>43.81|lat<35.76|lng>3.94|lng< -9.27){
       
       showModal(modalDialog(
         
         title = "UPS!",
         "No tenemos datos para esta zona, actualmente solo tenemos datos de Espa帽a",
         footer = modalButton("Ok"),
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
         lat <- as.numeric(lat2())
         
         G0d <- zoo(datos[, c("G0", "Ta")],
                  as.POSIXct(datos$Fecha, format = '%d/%m/%Y'))
         if(!is.null('G0d')){
         
         calcG0(lat, 
                modeRad = "bd",
                dataRad = list(lat = lat,
                               file = G0d)
                )
         }
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
      
      
      
      module = Datos_Modulos[1,]
      inversor = Datos_Inversores[1,]
      
      
      
      if(!is.null(input$slctMod)){
       
         #Para cuando el m骴ulo se selecciona directamente 
        if(input$slctCel!="Personalizado"){
        
        module = Datos_Modulos[Datos_Modulos$Nombre==input$slctMod,]
        }
        
        # Actualizaci髇 de valores cuando los datos se introducen en modo Personalizado
        else{
          module = Datos_Modulos[1,]
          module$Vocn <- input$GVocn
        module$Vmn <- input$GVmn
        module$Iscn <- input$GIscn
        module$Imn <- input$GImn
        module$Ncs <- input$GNcs
        module$Ncp <- input$GNcp
        module$CoefVT <- input$GCoef
        module$TONC <- input$GTONC
        }
          
        
        if(is.na(module$CoefVT)){
          module$CoefVT = 0.0023
          
        }
      }
      if(!is.null(input$slctInv)){
        
        # IDEM modulos
        if(input$slctInv!="Personalizado"){
        
        inversor = Datos_Inversores[Datos_Inversores$Nombre==input$slctInv,]
        }
        
        # IDEM m骴ulos
        else{
          inversor$Ki1 <- input$GKi1
        inversor$Ki2 <- input$GKi2
        inversor$Ki3 <- input$GKi3
        inversor$Pinv <- input$GPinv
        inversor$Gumb <- input$GGumb
        inversor$Vmin <- input$GVminmax[1]
        inversor$Vmax <- input$GVminmax[2]
        }
        
       
          
          if(is.na(inversor$Gumb)){
            inversor$Gumb = 20
          }
          
          if(is.na(inversor$Ki1)&is.na(inversor$Ki2)&is.na(inversor$Ki3)){
            inversor$Ki1 = 0.01
            inversor$Ki2 = 0.025
            inversor$Ki3 = 0.05
          }
        
      }
        

        
        fProd(inclin, 
              module = list( Vocn = module$Vocn,
                             Iscn = module$Iscn,
                             Vmn = module$Vmn,
                             Imn = module$Imn,
                             Ncs = module$Ncs,
                             Ncp = module$Ncp,
                             CoefVT = module$CoefVT,
                             TONC = module$TONC),
              
              inverter = list(Ki = c(inversor$Ki1, inversor$Ki2,inversor$Ki3),
                              Pinv = inversor$Pinv,
                              Vmin = inversor$Vmin,
                              vmax = inversor$Vmax,
                              Gumb = inversor$Gumb
                              )
              )
        
      
      
      # # else
      # # 
      # # fProd(inclin)
      # 
      
    }
    
  })
  
  output$sSelect <- renderUI({
    
    if(input$slctCel!="Personalizado"){
    selectInput('slctMod',
                'Selecciona el modulo a usar',
                choices = Datos_Modulos$Nombre[Datos_Modulos$Tipo==input$slctCel],
                selectize = FALSE)
    }
    
    # No tener este segundo render provocaba que no se actualizaran los datos en Personalizado
    else
      selectInput('slctMod',
                  'Selecciona el modulo a usar',
                  choices = "Personalizado",
                  selectize = FALSE)
    
  })
  
  # Tanto para m骴ulos como inversores, si se selecciona un predeterminado, este valor no se modifica
  observe({
    if(!is.null(input$slctMod)){
      
    module = Datos_Modulos[Datos_Modulos$Nombre==input$slctMod,]
    
    if(input$slctCel!="Personalizado"){
      
    if(is.na(module$CoefVT)){
      module$CoefVT = 0.0023
      
    }
    updateNumericInput(session, "GVocn", value = module$Vocn)
    updateNumericInput(session, "GVmn", value = module$Vmn)
    updateNumericInput(session, "GIscn", value = module$Iscn)
    updateNumericInput(session, "GImn", value = module$Imn)
    updateNumericInput(session, "GNcs", value = module$Ncs)
    updateNumericInput(session, "GNcp", value = module$Ncp)
    updateNumericInput(session, "GCoef", value = module$CoefVT)
    updateNumericInput(session, "GTONC", value = module$TONC)
    
    module$Vocn <- input$GVocn
    module$Vmn <- input$GVmn
    module$Iscn <- input$GIscn
    module$Imn <- input$GImn
    module$Ncs <- input$GNcs
    module$Ncp <- input$GNcp
    module$CoefVT <- input$GCoef
    module$TONC <- input$GTONC
    
    }
    }
    })
  
  observe({
    if(!is.null(input$slctInv)){
      
      inversor = Datos_Inversores[Datos_Inversores$Nombre==input$slctInv,]
      
      if(input$slctInv!="Personalizado"){
        
        if(is.na(inversor$Gumb)){
        inversor$Gumb = 20
        }
        
        if(is.na(inversor$Ki1)&is.na(inversor$Ki2)&is.na(inversor$Ki3)){
          inversor$Ki1 = 0.01
          inversor$Ki2 = 0.025
          inversor$Ki3 = 0.05
        }
      
      updateNumericInput(session, "GKi1", value = inversor$Ki1)
      updateNumericInput(session, "GKi2", value = inversor$Ki2)
      updateNumericInput(session, "GKi3", value = inversor$Ki3)
      updateNumericInput(session, "GPinv", value = inversor$Pinv)
      updateNumericInput(session, "GGumb", value = inversor$Gumb)
      updateSliderInput(session, "GVminmax", value = c(inversor$Vmin, inversor$Vmax))
      
      inversor$Ki1 <- input$GKi1
      inversor$Ki2 <- input$GKi2
      inversor$Ki3 <- input$GKi3
      inversor$Pinv <- input$GPinv
      inversor$Gumb <- input$GGumb
      inversor$Vmin <- input$GVminmax[1]
      inversor$Vmax <- input$GVminmax[2]
      

      
      }
      else
        inversor = Datos_Inversores[1,]  
      inversor$Ki1 <- input$GKi1
      inversor$Ki2 <- input$GKi2
      inversor$Ki3 <- input$GKi3
      inversor$Pinv <- input$GPinv
      inversor$GGumb <- input$GGumb
    }
  })
  
  
  
  # ///////////HIPERENLACES DENTRO DE SHINY////////
  
  
  observeEvent(input$toMod,{
    
    updateNavlistPanel(session,
                      inputId = 'Loca',
                      selected = 'dMod'
                      )
    
  })
  

  
})
