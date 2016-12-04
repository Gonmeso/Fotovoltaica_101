library(shiny)
library(ggmap)
library(leaflet)


##Función para la creación de la interfaz
shinyUI(
  
  ##Ajuste de la página al especio de la ventana
  fluidPage(theme = "bootstrap.css",
    fluidRow(        
    
    ##Creación de la barra superior
    navbarPage(
      
       ##Titulo 
       "Fotovoltaica 101", position = "static-top",
    
      #Tabs creadas, falta la parte de cada una 
      tabPanel('Introducción', 
               
            navlistPanel( widths = c(3,8),
                          
               tabPanel("Que es Fotovoltaica 101?"),          
              
               tabPanel('Conceptos básicos',
              
               readLines("DefFotov.txt", n='1'),
               div(img( src = 'EjFoto.jpg', height = 216, width = 300), style="text-align: center;")
               
               ),
              tabPanel('Noticias'),
              
              tabPanel('Modulos', div(id = "Modulos"))
              
            )
            ),
      
      
      tabPanel('Localizacion',
               
               
                 #Creación de la tabla lateral dentro de Localización
                 navlistPanel( id = "Loca",
                   
                   widths = c(3,8),
                   
                   tabPanel('Mapa',
                            
                          
                            column(4,
                            numericInput('lonIn', "Longitud", value = 0, width = '50px')),
                            
                            column(5,
                            numericInput('latIn', "Latitud", value = 0, width = '50px')),
                            
                            textInput('calle', "Dirección", value = "Spain"),

                            
                            h3("Seleccione su posición", align = "center"),
                            
                            
                            column(12, 
                            leafletOutput("Map"),
                            br(),
                            p(plotOutput("grafico")),
                            
                            actionLink('toMod',
                                         "Ir a modulos")
                            
                            

                         
                            
                            )
                            
                            
                            
                   ),
                   
                   tabPanel(title = 'Datos modulo',
                            id = 'dMod',
                            
                            
                            
                            selectInput('slctCel',
                                        'Selecciona el tipo de celula',
                                        choices = c('Ninguno',
                                                    as.character(unique(Datos_Modulos$Tipo))),
                                        selectize = FALSE),
                            
                            uiOutput('sSelect'),
                            
                            p(
                              h5("En caso de no encontrarse el modulo buscado,
                                 puede introducir los datos necesarios de froma manual aqui:",
                                 width = '300px')
                            ),
                            
                            column(3,
                                   
                                   numericInput('GVocn',
                                                'Vocn',
                                                c(0.00, 200.00),
                                                step = 0.1,
                                                width = '100px'),
                                   
                                   numericInput('GIscn',
                                                'Iscn',
                                                step = 0.1,
                                                width = '100px',
                                                c(0.0, 100.0)),
                                   
                                   numericInput('GVmn',
                                                'Vmn',
                                                step = 0.1,
                                                width = '100px',
                                                c(0, 100)),
                                   
                                   numericInput('GImn',
                                               'Imn',
                                               step = 0.1,
                                               width = '100px',
                                               c(0,100))
                                   
                                    ),
                            
                            column(4,
                                   
                                   numericInput('GNcs',
                                                'Ncs',
                                                c(0,150),
                                                width = '100px',
                                                step = 1),
                                   
                                   numericInput('GNcp',
                                                'Ncp',
                                                step = 1,
                                                width = '100px',
                                                c(0.0, 100.0)),
                                   
                                   numericInput('GCoef',
                                                'CoefV',
                                                step = 0.0001,
                                                width = '100px',
                                                c(0, 0.5)),
                                   
                                   numericInput('GTONC',
                                                'TONC',
                                                step = 0.1,
                                                width = '100px',
                                                c(0,100))
                                   
                            )
                            ),
                   tabPanel("Datos Generador",
                            
                            h4("Aqui se muestran los datos sobre el generador escogido,
                               asimismo, si no se encuentra el generador deseado, puede
                               introducir los datos manualmente:"),
                            
                            column(3,
                                   
                                   numericInput('GNms',
                                                'Nms',
                                                step = 1,
                                                width = '100px',
                                                c(0,100)
                                                ),
                                   
                                   numericInput(
                                     'GNmp',
                                     'Nmp',
                                     step = 1,
                                     width = '100px',
                                     c(0,100)
                                   )
                                  
                                   )
                            
                            ),
                   
                   tabPanel("Datos inversor",
                            column(3,
                                   
                                   numericInput('GKi',
                                                'Ki',
                                                step = 1,
                                                width = '100px',
                                                c(0,100)
                                   ),
                                   
                                   numericInput(
                                     'GPinv',
                                     'Pinv',
                                     step = 100,
                                     width = '100px',
                                     c(0,50000)
                                   ),
                                   
                                   numericInput(
                                     'GGumb',
                                     'Gumb',
                                     step = 1,
                                     width = '100px',
                                     c(0,100)
                                   )
                                   
                            ),
                            column(4,
                                   
                                   sliderInput('GVminmax',
                                               'Vmin - VMax',
                                               min = 0,
                                               max = 1000,
                                               c(0,100)
                                               
                                                
                                   )
                                   
                                   
                                   
                            )
                            
                            )
                             
                 )
                 
                 
               
               
      ),
      
      tabPanel('Introducción'),
      tabPanel('Introducción')
      
      
    )        
            
    
    
    
  )
)
)