library(shiny)



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
               readLines("DefFotov.txt", n='1'),
               div(img( src = 'EjFoto.jpg', height = 216, width = 300), style="text-align: center;")
               
               ),
      tabPanel('Localización',
               
               
               
                 navlistPanel(
                   tabPanel('Mapa',
                            h3("Seleccione su posición", align = "center"),
                            div(img( src = 'Espana.jpg', height = 345, width = 490), style="text-align: center;")
                            ),
                   
                   tabPanel('Coordenadas',
                            h3("La latitud de su posición es:"),
                            br(),
                            h3("La longitud de su posición es:")
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