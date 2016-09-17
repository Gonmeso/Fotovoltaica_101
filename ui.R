library(shiny)
library(ggmap)
library(leaflet)


##Función para la creación de la interfaz
shinyUI(
  
  ##Ajuste de la página al especio de la ventana
  fluidPage(theme = "bootstrap.css",
    
    ##Creación de la barra superior
    navbarPage(
      
       ##Titulo 
       strong("Fotovoltaica 101", align = "center"),
    
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
                            
                            textInput('calle', "Dirección", value = "Spain"),

                            verbatimTextOutput('calle'),
                            
                            h3("Seleccione su posición", align = "center"),
                            
                            # div(img( src = 'Espana.jpg', height = 345, width = 490), style="text-align: center;"),
                            
                            leafletOutput("Mapa", width = "500", height = "500"),
                            
                            p(),
                            actionButton("recalc", "Nuevo Punto")
                          
                              
                            
                   ),
                             
                   
                   
                   
                   
                   
                   tabPanel('Coordenadas',
                            h3("La posición seleccionada es: "),
                            verbatimTextOutput("Click_text"),
                            verbatimTextOutput("Glat")
                            )
                   
                 )
                 
                 
               
               
      ),
      tabPanel('Introducción'),
      tabPanel('Introducción')
      
      
    )        
            
    
    ##Creación de la barra lateral, se puede incluir el main panel
    #sidebarLayout(
      
      
      #sidebarPanel(
        
        # navlistPanel(
        #   
        #   tabPanel('¿Qué es la energía fotovoltaica?',
        #            
        #            readLines("DefFotov.txt", n='1')
        #            
        #            ),
        #   
        #   tabPanel('', 'Ejemplos de módulos fotovoltaicos')
        #   
        #   )
        
        #),
      
      ##sidebarPanel('Ejemplos'),
      
       #mainPanel( 'Hola'
      #   
      #   # textOutput("DefFoto"),
      #   # 
      #   # imageOutput("EjFoto")
      #   # 
      #    readLines("DefFotov.txt", n='1'),
      #            style = "color:solidblack",
      #   
      #            br(),
      #            br(),
      #            br(),
      #   
      #            img( src = 'EjFoto.jpg', height = 216, width = 300, align = "left" , style='border:1px' )
      # 
        #         )
      
   
      
   # )
    
    
    
    
  )
)