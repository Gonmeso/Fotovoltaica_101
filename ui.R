library(shiny)
library(ggmap)
library(leaflet)
source("SiarData.R")



##FunciÃ³n para la creaciÃ³n de la interfaz
shinyUI(
  
  ##Ajuste de la pÃ¡gina al especio de la ventana
  fluidPage(theme = "bootstrap.css",
    fluidRow(        
    
    ##CreaciÃ³n de la barra superior
    navbarPage(
      
       ##Titulo 
       "Fotovoltaica 101", position = "static-top", 
    
      #Tabs creadas, falta la parte de cada una 
      tabPanel('Introducción', 
               
            navlistPanel( widths = c(3,8),
                          
               tabPanel("¿Qué es Fotovoltaica 101?",
                        
                       div( strong( "¡Bienvenidos a Fotovoltaica 101!"
                                    # encoding = 'UTF-8'
                                    ),
                            style = 'text-align: center;'),
                            
                       
                       
                       div(
                         p("Fotovoltaica 101 tiene el objetivo de facilitar la compresión de los conceptos
                           básicos sobre los procesos y funcionamiento de la energía fotovoltaica. Surge
                           como una opción para el usuario alejado del sector energético o industrial que
                           se encuentre interesado en conocer como funciona la generación de energía fotovoltaica,
                           así como el diseño y los componentes necesarios para su obtención."),
                           br(),
                           div(img( src = 'EjFoto.jpg',
                                    height = 216,
                                    width = 300),
                               style="text-align: center;"),
                           br(),
                           "Fotovoltaica 101 explica los procesos seguidos y los datos necesarios mientras se
                           realiza el diseño del sistema, con esto se pretende crear un entorno interactivo y 
                           promover la actividad del usuario para facilitar la adquisición de los nuevos 
                           conocimientos.",
                           br(),
                         br(),
                         "Esta página se ha desarrollado completamente con R en RStudio.
                           RStudio es una interfaz para el entorno de programación R,
                           el cual es un software de uso libre, la interfaz RStudio puede
                           encontrase ",
                           a( href = 'https://www.rstudio.com/', "aquí"),
                           ", o clicando en la siguiente imagen:",
                           br(),
                           br(),
                           div(a(href = 'https://www.rstudio.com/',
                             img( src = 'bigorb.png',
                                    height = 100,
                                    width = 100
                                    )), style=" text-align: center;"),
                         br(),
                         br(),
                         p("En este tipo de entorno los usuarios hacen uso de los llamados 'paquetes'
                           estos permiten añadir nuevas funcionalidades y son desarrollados por
                           los usuarios de R. Concretamente en esta página se han usado principalmente los siguientes
                           paquetes:"),
                         tags$li(code("solaR")),
                         tags$li(code("Shiny")),
                         p("El paquete solaR ha sido desarrollado por ",
                           a( href = 'https://oscarperpinan.github.io/', "Oscar Perpiñán Lamigueiro")),
                         
                         
                         style = 'text-align: justify;'
                       )
                       
                        
                        ),
               
               tabPanel('¿Qué es R y RStudio?',
                        
                        div(
                          
                          p("R es un lenguaje y entorno de programación estadístico y gráfico, generalmente utilizado
                            para el tratamiento de datos y su análisis. Es un proyecto GNU, esto quiere decir que es
                            un sistema operativo de software libre, esto quiere decir que este tipo de software permite
                            a los usuarios modificar o mejorar el software, además de ejercer el control sobre sus tareas
                            de computación y la libre distribución de este.",
                            br(),
                            br(),
                            "Concretamente R, es una implementación del lenguaje S, el cual fue desarrollado en Bell
                            Laboratories por John Chambers en 1976, la diferencia entre R y S reside en que R cuenta
                            con un soporte de alcance estadístico. Actualmente la mayoría del código escrito en S, 
                            compilaría sin problemas bajo un entorno de R.",
                            br(),
                            br(),
                            "El desarrollo de R se produjo en 1993 en la Universidad de Auckland por Robert Gentleman 
                            y Ross Ihaka. Estos decidieron realizar una implementación de S con Scheme, sacando los
                            puntos fuertes de cada lenguaje en uno, donde la apariencia deriva de S mientras que la 
                            funcionalidad y la semántica provienen de Scheme. ",
                            br(),
                            br(),
                            "R continúa en desarrollo bajo el mando de R Development Core Team, el cual continúa
                            desarrollando R, mejorando la capacidad de cálculo, incluyendo nuevas funcionalidades
                            y codificaciones, soportes para nuevos sistemas operativos, mejoras en la gestión de 
                            memoria y en el rendimiento, etc…",
                            br(),
                            br(),
                            "La página oficial de R es :",
                            a( href = 'https://www.r-project.org/', 'https://www.r-project.org/')
                          ),
                          
                          style = 'text-align: justify'
                        )
                 
               ),
               
               tabPanel('¿Qué es Shiny?',
                        
                        div(
                          p(
                            "Shiny es un paquete de uso libre que permite la creación de webs potentes e 
                            interactivas directamente desde R. Con esto permite combinar la potencia de
                            análisis integrada en R con una web interactiva de fácil desarrollo, sin
                            necesidad de conocimiento de los lenguajes más comunes de programación web 
                            como HTML, CSS y JavaScript, aunque estos pueden combinarse con Shiny para 
                            aumentar las posibilidades de la interfaz, todo esto mediante paquetes derivados
                            de Shiny, como “shinyjs” para el uso de JavaScript, o el uso de HTML mediante
                            funciones ya implementadas dentro del paquete Shiny como",
                            code('html()'),
                            ".",
                            br(),
                            div(
                              a( href = 'https://shiny.rstudio.com/',
                                img( src = 'shiny.png', width = '40%', height = '40%', align = 'center')
                              
                            ),  style = 'text-align: center;'
                            ),
                            br(),
                            "Shiny, generalmente, está dividido en dos scripts (archivo de código),
                            en estos dos se encuentran las partes fundamentales de Shiny:",
                            br(),
                            tags$li("La interfaz de usuario, definida en Shiny como UI (User Interface)
                                   , bajo el script de ui.R."),
                            tags$li("Y el servidor, definido como Server bajo el script server.R."),
                            br(),
                            "El primer script como su propio nombre indica trata de la interfaz de usuario,
                            es la parte gráfica, donde se introduce el código para la creación de los
                            elementos de la interfaz. Es decir, en este script se encuentra aquello que
                            queremos mostrar, información, imágenes, etc… Por si sola no es un medio
                            interactivo, sino que necesita del server donde se encuentra el código del
                            contenido con el que se quiere interactuar. Shiny por defecto tiene muchas
                            funcionalidades incluidas en su código con las que crear elementos."
                          ),
                          style = 'text-align: justify'
                        )
                 
               ),
              
               tabPanel('Conceptos básicos',
                        
                        div(
                          
                          strong("¿Qué es la energía solar fotovoltaica"),
                          br(),
                          br(),
                          p("La energía fotovoltaica es la producción de energía eléctrica de origen renovable
                            mediante el uso de células fotovoltaicas, este tipo de energía esta basada en el 
                            efecto fotoeléctrico, el cual consiste en una emisión de electrones producidas en
                            un material al  ser este iluminado  con radiación electromagnética, gracias al
                            efecto fotoeléctrico, es  posible la conversión de luz en energía eléctrica.", 
                            br(),
                            br(),
                            "El efecto fotoeléctrico se descubrió a finales del siglo XIX por Heinrich Hertz,
                            cuando observó que los arcos que producían dos electrodos conectados a alta tensión
                            eran mayores cuando estos se encontraban iluminados, que cuando estos se encontraban
                            a oscuras.",
                            br(),
                            br(),
                            "Para continuar la explicación del efecto fotoeléctrico, vamos a definir primero
                            ciertos conceptos necesarios:"
                            
                          )
                          
                          , style = 'text-align: justify'
                        )
              

               
               ),
              tabPanel('Noticias'),
              
              tabPanel('Modulos', div(id = "Modulos"))
              
            )
            ),
      
      
      tabPanel('Localización',
               
               
                 #CreaciÃ³n de la tabla lateral dentro de LocalizaciÃ³n
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
                   
                   tabPanel(title = 'Datos módulo',
                            value = 'dMod',
                            
                            
                            
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
                            
                            h6(strong("Aqui se muestran los datos sobre el generador escogido,
                               asimismo, si no se encuentra el generador deseado, puede
                               introducir los datos manualmente:"), style = "font-family:verdana" ),
                            
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
                            
                            selectInput("slctInv",
                                        "Selecciona el inversor",
                                        choices = c("Ninguno",as.character(Datos_Inversores$Nombre))
                                        ),
                            
                            column(3,
                                   
                                   numericInput('GKi1',
                                                'Ki1',
                                                step = 0.001,
                                                width = '100px',
                                                c(0,1)
                                   ),
                                   
                                   numericInput('GKi2',
                                                'Ki2',
                                                step = 0.001,
                                                width = '100px',
                                                c(0,1)
                                   ),
                                   
                                   numericInput('GKi3',
                                                'Ki3',
                                                step = 0.001,
                                                width = '100px',
                                                c(0,1)
                                   )
                            ),
                             
                            column(3,
                                  
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
                                               'Vmin - Vmax',
                                               min = 0,
                                               max = 1000,
                                               c(0,100)
                                   
                                   ),
                                   offset =  1 
                                   
                                   
                                   
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