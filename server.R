library(shiny)
library(ggmap)
library(solaR)
library(htmltools)
library(rsconnect)
library(plyr)
source("SiarData.R")



 
##Función para formatear sencillamente, usado para los decimales de los PopUps

easyFormat <- function(x, y){
  
  format(round(x,y), nsmall = y)
  
}

##Creación del Icono usado para las estaciones meteorológicas
 
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
     
     input$Map_marker_click$lng
     
     
     
   })

   ##Obtención del dataframe de la estación seleccionada porr clic
   dataEstacion <- reactive({
     
     ##Debido al uso de funciones se encuentra esta condición, para evitar errores
     if(!is.null(input$Map_marker_click)){
       
       lat <- lat2()
       lng <- lng2()
      
      ##Latitud del clic  
      ##Num <- as.numeric(input$Map_marker_click$lat)
      clickID <- input$Map_marker_click$id
      
      if(!is.null(clickID)){
      ##Selecciona la fila de DatosSiar que coincide con el clic a la estación
      pillaDatos <- DatosSiar[ID == clickID]
      
      output$EstList <- renderDataTable({
        
        pillaDatos[,c(2,4,5)]
      })
      
      ##Comprobación por consola
      PInfo <- as.vector(input$Map_marker_click)

      
      ##Se coge el dataframe de la estacion clicada
      estaEs <- AllData[ID == clickID]
      
      output$EstData <- renderDataTable({
        names(estaEs)[c(4,5)] <- c("Temperatura Ambiente", "Radiación")
        estaEs[,c(3:5)]
        },
        options = list(pageLength = 10))
      
      estaEs
      
      } else{
      
      EstacionesSelect <- DatosSiar #[ sqrt((abs(DatosSiar$lon-lng))^2 + (abs(DatosSiar$lat-lat))^2) <= 0.05]
      # EstacionesSelect <- DatosSiar[c(DatosSiar$lon-lng<=0.5)]
      
      EstacionesSelect$Dist <- sqrt((abs(EstacionesSelect$lon-lng))^2 + (abs(EstacionesSelect$lat-lat))^2)
      
      EstacionesSelect <- EstacionesSelect[EstacionesSelect$Dist <= 0.5, ]
      
      if(!is.na(EstacionesSelect[1,1])){
      
      pondera <- (1/EstacionesSelect$Dist^2)/sum(1/EstacionesSelect$Dist^2)
      
      EstacionesSelect$Ponderacion <- pondera
      
      output$EstList <- renderDataTable({
        
        EstacionesSelect[,c(2,4,5,11)]
        
        }, options = list (pageLength = 10))
      
      ind <- which(AllData$ID %in% EstacionesSelect$ID) 
      
      finalSel <- data.frame()
      
      finalSel <- rbind(finalSel, AllData[ind,])
      
      finalSel <- na.omit(finalSel)
      
      
      for( i in 1:length(EstacionesSelect$ID)){
        
        if(EstacionesSelect$ID[i] %in% finalSel$ID){
          
          ind2 <- which(finalSel$ID %in% EstacionesSelect$ID[i])
          finalSel$Ponderacion[ind2] <- EstacionesSelect$Ponderacion[i]  
          
        }
      }
      
      finalSel$G0 <- finalSel$G0*finalSel$Ponderacion
      finalSel$Ta <- finalSel$Ta*finalSel$Ponderacion
      
      
      estaEs <- ddply(finalSel,.(Fecha),summarize,G0=sum(G0), Ta=sum(Ta),number=length(G0))

      output$EstData <- renderDataTable({
        names(estaEs)[c(2,3)] <- c("Radiación", "Temperatura ambiente")
        estaEs[,c(1,2,3)]
        },
                                        options = list(pageLength = 10))
      estaEs
      }
      }
     }
     
   })
   
   ##Prueba del funcionamiento de la selección del dataframe por consola
   observe({
     

     
     if(!is.null(input$Map_marker_click)){
       # Datos_Est<- dataEstacion()
       
       # if(!is.na(Datos_Est[1,1])&exists('DatosSiar')){
       
       # print(Datos_Est)
       
       # a <- as.data.frame(fSolD(as.numeric(lat2()), fBTd("serie")))
       
       # print(horizontalPlane())
       
       
       # print(head(a))
       
       validate(
         need(!is.null(horizontalPlane()), "No tenemos datos para esta zona, selecciona otros")
       )
       


       output$graficoRad <- renderPlot({
         px1 <- xyplot(horizontalPlane())
       })
       output$grafico <-  renderPlot({
         
         px1 <- xyplot(horizontalPlane())
         px2 <- xyplot(generatorPlane())
                                     
         print(px1, position=c(0, .5, 1, 1), more=TRUE)
         print(px2, position=c(0, 0, 1, .5))
         
         box("figure")
                                     })
       
       output$Graf2 <- renderPlot({
         
         xyplot(aRed())
         
       })
       
       # print(generatorPlane())
       print(aRed())
      
     # }
     
       validate(
         need(!is.null(horizontalPlane()), "No tenemos datos para esta zona, selecciona otros")
       )

     } 
     })
   
   observe({
     
     if(!is.null(input$Map_marker_click)){
       
       lat <- lat2()
       lng <- lng2()
       
       if(lat>43.81|lat<35.76|lng>3.94|lng< -9.27){
       
       showModal(modalDialog(
         
         title = "UPS!",
         "No tenemos datos para esta zona, actualmente solo tenemos datos de España",
         footer = modalButton("Ok"),
         easyClose = TRUE
         
       ))
       
       }
       
       if(is.null(horizontalPlane())&!(lat>43.81|lat<35.76|lng>3.94|lng< -9.27)){
         
         showModal(modalDialog(
           
           title = "UPS!",
           "No tenemos datos para esta zona,por favor seleccione otro punto",
           footer = modalButton("Ok"),
           easyClose = TRUE
           
         ))
         
       }
     }
     
     output$getU <- renderText({
       paste0("Día = ", input$plot_click$x, "\nTensión = ", input$plot_click$y)
     })
     
   })
   


   
# ///////SOLAR//////
   
   ##Movimiento relativo, sirve tanto para estaciones como click
   
   
   dailyMove <- reactive({
     
     if(!is.null(input$Map_marker_click)){
       
       calcSol(as.numeric(lat2()), fBTd("serie"))
       
     }
     
     
   })  
   

   horizontalPlane <- reactive({
     
     if(!is.null(input$Map_marker_click)&!is.null(dataEstacion())){
       
         datos <- as.data.frame(dataEstacion())
         lat <- as.numeric(lat2())
         
         G0d <- zoo(datos[, c("G0", "Ta")],
                  as.POSIXct(datos$Fecha, format = '%d/%m/%Y'))
         if(!is.null('G0d')){
         
         rad <- calcG0(lat, 
                  modeRad = "bd",
                  dataRad = list(lat = lat,
                                 file = G0d)
                )
         
         output$RadData <- renderDataTable({
           
           rad1 <- as.data.frameD(rad)
           names(rad1) <- c("Global (W/m^2)","Difusa (W/m^2)","Directa(W/m^2)","Día","Mes","Año")
           rad1
           
         }, options = list(pageLength = 10,
                           scrollX=TRUE))
         
         output$MRadData <- renderDataTable({
           
           rad1 <- as.data.frameM(rad)
           names(rad1) <- c("Global (kW/m^2)","Difusa (kW/m^2)","Directa(kW/m^2)","Mes","Año")
           rad1
           
         }, options = list(pageLength = 10,
                           scrollX=TRUE))
         
         output$YRadData <- renderDataTable({
           
           rad1 <- as.data.frameY(rad)
           names(rad1) <- c( "Global (kW/m^2)","Difusa (kW/m^2)","Directa(kW/m^2)","Año")
           rad1
           
         }, options = list(pageLength = 10,
                           scrollX=TRUE))
         
         output$RadGraf <- renderPlot({
           
           xyplot(rad)

           
         })
         
         rad
         
         }
     }
     
   })
   
  generatorPlane <- reactive({
    
    if(!is.null(input$Map_marker_click)&!is.null(horizontalPlane())){
    
    g0 <- horizontalPlane()
    
    
    hrad <- calcGef(lat2(),modeRad = 'prev', dataRad = g0)
    
    output$HRadData <- renderDataTable({
      
      hrad1 <- as.data.frameD(hrad)
      # names(rad1) <- c("Global (Wh/m^2)","Difusa (Wh/m^2)","Directa(Wh/m^2)","Día","Mes","Año")
      hrad1
      
    }, options = list(pageLength = 10))
    
    output$MHRadData <- renderDataTable({
      
      hrad1 <- as.data.frameM(hrad)
      # names(hrad1) <- c("Global (Wh/m^2)","Difusa (Wh/m^2)","Directa(Wh/m^2)","Mes","Año")
      hrad1
      
    }, options = list(pageLength = 10,
                      scrollX=TRUE))
    
    output$YHRadData <- renderDataTable({
      
      hrad1 <- as.data.frameY(hrad)
      # names(hrad1) <- c( "Global (Wh/m^2)","Difusa (Wh/m^2)","Directa(Wh/m^2)","Año")
      hrad1
      
    }, options = list(pageLength = 10,
                      scrollX=TRUE))
    
    output$HRadGraf <- renderPlot({
      
      xyplot(hrad)
      # box("figure")
      
    })
    
    hrad
    
    }
    
  })
   
  aRed <- reactive({
    
    if(!is.null(input$Map_marker_click)){
      
      
      inclin <- generatorPlane()
      
      
      
      module = Datos_Modulos[1,]
      inversor = Datos_Inversores[1,]
      generator = list(Nms = 12, Nmp = 11)
      
      
      
      if(!is.null(input$slctMod)){
       
         #Para cuando el m?dulo se selecciona directamente 
        if(input$slctCel!="Personalizado"){
        
        module = Datos_Modulos[Datos_Modulos$Nombre==input$slctMod,]
        }
        
        # Actualizaci?n de valores cuando los datos se introducen en modo Personalizado
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
        
        # IDEM m?dulos
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
        Nms <- input$GNms
        Nmp <- input$GNmp

        
        aRed <- prodGCPV(lat2(),dataRad = inclin, modeRad = "prev", 
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
                              ),
              generator = list(Nms = Nms, Nmp = Nmp)
              
              )
        
        output$RedData <- renderDataTable({
          
          aRed <- as.data.frameD(aRed)
          names(aRed) <- c("Tensión en alterna (V)","Tensión en continua(V)","Productividad","Día","Mes","Año")
          aRed
          
        }, options = list(pageLength = 10,
                          scrollX=TRUE))
      
        output$MRedData <- renderDataTable({
          
          aRed <- as.data.frameM(aRed)
          names(aRed) <- c("Tensión en alterna (kV)","Tensión en continua (kV)","Productividad","Mes","Año")
          aRed
          
        }, options = list(pageLength = 10,
                          scrollX=TRUE))

        output$YRedData <- renderDataTable({
          
          aRed <- as.data.frameY(aRed)
          names(aRed) <- c("Tensión en alterna (kV)","Tensión en continua (kV)","Productividad","Año")
          aRed
          
        }, options = list(pageLength = 10,
                          scrollX=TRUE))
        
        output$DRedGraf <- renderPlot({
          
          plot(c(1:length(as.data.frameD(aRed)$Eac))
               ,as.data.frameD(aRed)$Eac,
               type = "l",
               main = "Tensión en corriente alterna",
               xlab = "Días",
               ylab = "Tensión Diaria")
          # box("figure")
          
        })
        
        aRed
        
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
  
  # Tanto para m?dulos como inversores, si se selecciona un predeterminado, este valor no se modifica
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
