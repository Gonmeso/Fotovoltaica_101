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
               
            navlistPanel( 
              
              tabPanel('Conceptos básicos',
              
               readLines("DefFotov.txt", n='1'),
               div(img( src = 'EjFoto.jpg', height = 216, width = 300), style="text-align: center;")
               
               ),
              tabPanel('Noticias'),
              
              tabPanel('Modulos')
              
            )
            ),
      
      
      tabPanel('Localización',
               
               
                 #Creación de la tabla lateral dentro de Localización
                 navlistPanel(
                   tabPanel('Mapa',
                            
                          
                            column(4,
                            
                            numericInput('lonIn', "Longitud", value = 0, width = '50px')),
                            
                            column(5,
                            numericInput('latIn', "Latitud", value = 0, width = '50px')),
                            
                            textInput('calle', "Dirección", value = "Spain"),

                            
                            h3("Seleccione su posición", align = "center"),
                            
                            # div(img( src = 'Espana.jpg', height = 345, width = 490), style="text-align: center;"),
                            
                            column(12, 
                            leafletOutput("Map"),
                            br(),
                            p(plotOutput("grafico"))
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