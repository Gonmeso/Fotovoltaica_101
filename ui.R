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
                            ciertos conceptos necesarios:",
                            tags$li("Fotón: dentro de la física, esta se encuentra definida como aquella
                                    partícula de luz que se propaga en el vacío, este es responsable de 
                                    las manifestaciones cuánticas del fenómeno electromagnético.
                                    Esta partícula es portadora de rayos gamma, rayos X, luz visible,
                                    ultravioleta, infrarroja, ondas de radio, etc… esto quiere decir, 
                                    que es portadora de todas las formas de radiación electromagnética. "),
                            br(),
                            tags$li("Frecuencia: son el número de repeticiones de un fenómeno periódico 
                                    por unidad de tiempo. En este caso, la frecuencia de una onda
                                    electromagnética, esta determina el tipo de onda con las que nos
                                    encontramos, luz visible, infrarrojos, rayos gamma, etc…"),
                            br(),
                            tags$li("Electrón: constituyente elemental de la materia, es una partícula
                                    subatómica que se encuentra cargada negativamente. "),
                            br(),
                            "En el efecto fotoeléctrico, para poder expulsarse un electrón, se necesita
                            que un átomo absorba suficiente energía, en este caso, el metal absorbe una
                            cantidad de energía necesaria, proveniente de un fotón, para que el electrón
                            pueda ser emitido. La energía proveniente del fotón viene determinada por la 
                            frecuencia de la luz, donde la intensidad no cambia la cantidad de energía sino
                            la cantidad de fotones disponibles. En el caso de no llegar a superar el umbral
                            de la energía necesaria, la energía absorbida es re-emitida.",
                            br(),
                            div(
                              img( src = "efecto-fotoelectrico.jpg"),
                              style = 'text-align: center;'
                            ),
                            br(),
                            "Para la energía fotovoltaica, se utiliza un semiconductor, en el cual el fotón 
                            permite al semiconductor liberar un electrón, en este momento se produce un vacío
                            en el átomo del cual es arrancado el electrón, tras esto se busca crear una
                            diferencia de potencial, donde se genera tensión, mediante la recolocación de los
                            electrones y los huecos en la dirección opuesta del material, evitando que estos
                            se distribuyan libremente. El efecto fotoeléctrico descrito, sucede en las células
                            solares, las cuales se explicara su funcionamiento, materiales y tipos en apartados
                            posteriores dentro de esta web, donde se expondrá con mayor detalle.",
                            br()
                            
                            
                            
                          )
                          
                          , style = 'text-align: justify'
                        )
                        
                      
               ),
               
               tabPanel( 'Componentes de un sistema',
                         
                         div(
                           p(
                             "Los sistemas fotovoltaicos se encuentran formados por una gran cantidad
                             de componentes, cada uno con ciertas características dependiendo del tipo
                             de sistema que se quiera diseñar. Las características pueden variar por 
                             la tecnología de las celdas, si el sistema es residencial o comercial, la
                             tensión deseada, etc… Los componentes que vamos a tratar en profundidad y 
                             sus características son: ",
                             br(),
                             tags$li( actionLink( 'PanyCel',
                                                  'Paneles y células')),
                             br(),
                             tags$li(actionLink( 'Inver',
                                                 'Inversores')),
                             br(),
                             tags$li(actionLink( 'Bat',
                                                 'Baterias')),
                             br(),
                             "Un sistema fotovoltaico contiene más componentes que los mencionados
                             anteriormente, pero estos no son intrínsecos a los sistemas, como pueden
                             ser el cableado o los sistemas de anclaje. ",
                             br(),
                             div(
                               img( src = 'ComponentesSisyema.png',
                                    width = '100%',
                                    height = '100%'),
                               style = 'text-align: center;border: dotted;'
                             )
                             
                            
                             
                           ),
                           
                           style = 'text-align: justify;'
                         )
                         
      ),
               
              tabPanel('Noticias'),
              
              tabPanel('Modulos', div(id = "Modulos"))
              
            )
            ),
      
      tabPanel('Componentes',
               
               navlistPanel(widths = c(3,8),
                            
                            tabPanel('Células y paneles',
                                     div(
                                       p(
                                         "Un panel fotovoltaico, es un conjunto de células fotovoltaicas con
                                         el fin de producir electricidad mediante el efecto fotoeléctrico 
                                         utilizando la luz como fuente. Dependiendo de la tensión deseada, 
                                         estos paneles pueden colocar en serie, lo mismo sucede con la intensidad
                                         o corriente eléctrica, donde se pueden colocan en paralelo con el fin de alcanzar
                                         la intensidad deseada. Estos módulos pueden estar formados por distintos tipo
                                         de células, por lo que se clasifican en distintas tecnologías, donde una célula
                                         fotovoltaica se trata de un dispositivo formado por un material que presente el", 
                                         actionLink( 'pHeffect',
                                                     'efecto fotoeléctrico'), 
                                         "un semiconductor, generalmente silicio.",
                                         br(),
                                         br(),
                                         "Cada célula está formada por dos tipos distintos de semiconductores, uno cargado
                                         positivamente (tipo n) en la zona superior y otra cargada negativamente (tipo p)
                                         en la carga inferior, a esto se le conoce como un dispositivo electrónico de unión
                                         tipo “pn”. Cuando un rayo de luz incide sobre una célula solar, un electrón es
                                         liberado de la capa inferior donde este es atraído por la carga positiva de la capa
                                         n, la capa superior, el desplazamiento del electrón deja un “hueco” cerca de la unión
                                         entre las dos capas, un electrón situado en una zona cercana de la capa p, asciende
                                         para cubrir el hueco. Con esto a medida que la luz mantiene el proceso y se siguen 
                                         liberando electrones, se genera una corriente eléctrica.",
                                         br(),
                                         div(
                                           img( src = 'Funcionamientocelula.png'),
                                           style = 'text-align: center'
                                         ),
                                         br(),
                                         div(strong("Obtención del Silicio"),
                                             style = 'text-align: center;'),
                                         br(),
                                         "Un punto a favor del silicio, es que se obtiene mediante una reducción de uno de
                                         los compuestos más comunes de la tierra, la sílice, donde esta se puede obtener 
                                         fácilmente del cuarzo. Para ello, uno de los primeros pasos es la purificación del
                                         silicio, donde se busca una pureza entorno al 98%, esta purificación se realiza mediante
                                         procesos químicos, Lavado y Decapado, estos procesos se usan hasta que se puede denominar
                                         al silicio purificado como “silicio de grado solar”, donde se permiten impurezas en este
                                         de hasta una parte por millón (ppm). ",
                                         br(),
                                         br(),
                                         "Posteriormente, se funde el silicio con el fin de comenzar un proceso de crecimiento 
                                         cristalino, este proceso trata de obtener cristales mayores mediante la adición de compuestos
                                         que dependiendo del tiempo de enfriado (cristalización), cuanto mayor sea este, mayor serán
                                         los cristales, en el caso del silicio de esto dependerá si se trata de silicio monocristalino 
                                         o policristalino.",
                                br(),
                                br(),
                                "Para la obtención de lingotes de silicio monocristalino, uno de los métodos más usados 
                                en la actualidad es el “Proceso Czochralski”, este proceso usa el silicio fundido 
                                comprobando que este se encuentre un poco por encima de su temperatura de fusión, evitando
                                así que se solidifique. Inicialmente se produce el “dopaje” del semiconductor, esto es,
                                añadir fósforo, o boro dependiendo del tipo de conductor que se quiera obtener, tipo “p”
                                con fósforo o tipo “n” con boro. Este silicio dopado se introduce en un crisol mientras
                                una varilla gira, esta contiene en la punta lo que se conoce como “semilla”, esto es una 
                                pequeña cantidad de monocristal del semiconductor fundido. Esta semilla provoca que al entrar
                                en contacto con el semiconductor fundido, este se agrega a la semilla y comienza un proceso 
                                de solidificación con la estructura cristalina del monocristal, creciendo así este. Mientras 
                                rota la varilla, esta se va sacando del crisol poco a poco y alrededor de la varilla se va 
                                formando un cilindro monocristalino. Mediante el control de la velocidad de rotación y la
                                temperatura permite crear un lingote monocristalino y controlar el tamaño de estos. Como
                                toque final se comienza la purificación del lingote obtenido mediante la fusión por zonas.",
                                br(),
                                div(
                                  img( src = 'Czochralski.jpg'),
                                  style = 'text-align: center'
                                )
                                
                                
                              ),
                              
                              style = 'text-align: justify;'
                            )
                                     
                                     ),
                            

                            
                            tabPanel('Inversores',
                                     
                                     div(
                                       p(
                                         "Este dispositivo cumple con la función de invertir la corriente continua 
                                         obtenida de los paneles fotovoltaicos a corriente alterna para su uso. Es
                                         un parte primordial de cualquier sistema fotovoltaico, pues la corriente
                                         alterna es la más utilizada gracias a su fácil transformación lo que
                                         favorece su generación, transporte y distribución. Es un dispositivo
                                         necesario, tanto para sistemas residenciales como de gran magnitud. ",
                                         br(),
                                         br(),
                                         "Estos además de invertir la corriente, este dispositivo regulara la tensión
                                         y frecuencia para su uso, donde en sistemas residenciales se transformara
                                         a 220 voltios y una frecuencia de 50 Hz. Hay que tener en cuenta también 
                                         la fuente de la corriente continua, donde se necesita que esta proporcione
                                         con cierta estabilidad la energía para poder cumplir con la inversión deseada.
                                         Esta fuente puede ser de 12, 24 o 48 V, pero en este caso al provenir de
                                         paneles fotovoltaicos, estos pueden rondar entre los 150 y 800 voltios. El
                                         número de inversores depende la potencia máxima producida por los paneles y la
                                         potencia máxima que es capaz de soportar el inversor. ",
                                         br(),
                                         br(),
                                         "En sistemas residenciales estos se conectan directamente a la línea eléctrica
                                         del domicilio, para transformar la energía con las propiedades adecuadas y así
                                         inyectarla en la línea para su uso, mientras este se mantenga encendido.  Para
                                         mantener la fuente de energía estable, los inversores se conectan a baterías
                                         de manera que pueda suministrarse la energía uniformemente, además el inversor
                                         es el encargado de controlar cuando es necesario obtener energía de la batería,
                                         mantenerla o cargarla de la forma más óptima, con el fin de aprovechar la 
                                         energía de la forma más favorable. En el caso de no estar conectado a una batería,
                                         el inversor proporcionará solo la energía que sea segura para la red, evitando
                                         así peligros para los sistemas conectados a esta. ",
                                         br(),
                                         br(),
                                         "Uno de los puntos más favorables de los inversores es la eficiencia de estos,
                                         la cual ronda entre el 92% y el 96%, esto se debe a las pérdidas provocadas por
                                         la conversión y por el porcentaje de autoconsumo. Actualmente se han llegado a 
                                         obtener eficiencias cercanas al 98% y 99%. ",
                                         br(),
                                         br(),
                                         "Cabe mencionar, que al ser un componente necesario para los sistemas, los 
                                         fabricantes también se han focalizado en reducir su precio pero manteniendo la eficiencia.",
                                         br(),
                                         br(),
                                         "En la siguiente imagen podemos observar un esquema de un sistema fotovoltaico y la
                                         posición del inversor en el circuito:",
                                         div(
                                           img( src = 'esquema_inversor.gif' ),
                                           style = 'text-align: center;'
                                         ),
                                         br(),
                                         br(),
                                         br()
                                         
                                       ),
                                       
                                       style = 'text-align: justify;'
                                     )
                                     
                                     ),
                            
                            tabPanel('Baterias',
                                     
                                     div(
                                       p(
                                         "Las baterías son los dispositivos encargados de almacenar la energía excedente
                                         generada por los paneles y suministrar energía al inversor en los momentos que
                                         los paneles no genere la cantidad necesaria de energía, para mantener la estabilidad
                                         del sistema.",
                                         br(),
                                         br(),
                                         div(
                                           img( src = "Bateria.jpg"),
                                           style = 'text-align: center;'
                                         ),
                                         br(),
                                         br(),
                                         "Se suelen utilizar agrupaciones, bancos de baterías, para poder almacenar la suficiente
                                         energía para mantener la energía estable en el caso de que no pueda producir la energía
                                         necesaria en periodos de tiempo nuboso. Esto se debe a que en el caso de que se produzcan 
                                         descargas totales de las baterías se van a producir más ciclos completos de carga,
                                         lo que se traduce en una menor vida efectiva de las baterías. Para esto se recomienda
                                         un banco de baterías que sea capaz de mantener alimentando al inversor cerca de 5 días.",
                                         br(),
                                         br(),
                                         "La capacidad de las baterías se mide en amperios por hora (amp-hr) a “N” voltios donde 
                                         la carga se estima en una duración de 20 horas, es decir, la batería puede alimentar a 
                                         “N” voltios, “X” amperios totales en 20 horas.",
                                         br(),
                                         br(),
                                         br()
                                         
                                       ),
                                       
                                       style = 'text-align'
                                     )
                                     
                                     )
                            
                            
                            )
               
               ),
      
      
      tabPanel('Diseño',
               
               
                 #CreaciÃ³n de la tabla lateral dentro de LocalizaciÃ³n
                 navlistPanel( id = "Loca",
                   
                   widths = c(3,8),
                   
                   tabPanel('Geometría solar y localización',
                            
                          
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
                   
                   tabPanel(title = 'Paneles y células',
                            value = 'dMod',
                            
                            div(
                              p(
                                "Los paneles tienen ciertas especificaciones que son necesarias para ver la
                                eficiencia del sistema o la cantidad de paneles que necesitaremos para conseguir
                                una cierta potencia. La información se divide entre:",
                                tags$li("Datos eléctricos: Potencia máxima, eficiencia de la célula y del panel,
                                        tensión en circuito abierto y condiciones estándar, corriente en cortocircuito
                                        y condiciones estándar, tensión máxima, coeficientes de temperatura y la
                                        temperatura de funcionamiento."),
                                tags$li("Datos mecánicos: número de células en serie y en paralelo, cables de salida,
                                        cristal protector y peso."),
                                tags$li("Condiciones de funcionamiento: temperatura máxima y mínimo de funcionamiento,
                                        máxima carga soportada y resistencia a impactos."),
                                tags$li("Certificados y garantías. "),
                                br(),
                                "En este caso los datos más relevantes, que son utilizados para el cálculo, son:",
                                br(),
                                br(),
                                tags$li("Tensión en circuito abierto (Vocn): tensión en la célula cuando la corriente
                                        neta en el dispositivo es cero."),
                                tags$li("Corriente en cortocircuito (Iscn): corriente máxima en el dispositivo cuando
                                        la tensión en este es igual a cero."),
                                tags$li("Tensión en condiciones estándar (Vmn): tensión máxima en condiciones estándar*."),
                                tags$li("Corriente en condiciones estándar (Imn): corriente máxima en condiciones estándar*."),
                                tags$li("Nº de células en serie (Ncs) y en paralelo (Ncp)"),
                                tags$li("Temperatura de funcionamiento (TONC): temperatura de funcionamiento del panel en
                                        condiciones estándar"),
                                tags$li("Coeficiente de tensión por temperatura (CoefV): reducción de la tensión por célula
                                        y por grado."),
                                br(),
                                div(
                                  p(
                                    "*Las condiciones estándar (Standar Test Conditions en inglés) son a:",
                                    tags$li("Temperatura: 25ºC"),
                                    tags$li("Irradiación: 1000 W/m2"),
                                    tags$li("Espectro de masa de aire: AM 1.5")
                                  ),
                                  style = 'border: dotted; background: #E5E5E5'
                                )
                              ),
                              
                              style = 'text-align: justify'
                            ),
                           
                            br(),
                            strong("Aquí podemos seleccionar el panel deseado según su tecnología con las especificaciones
                                   mencionadas previamente o introducir los datos por nuestra cuenta: "),
                            br(),
                            
                            selectInput('slctCel',
                                        'Selecciona el tipo de celula',
                                        choices = c("Personalizado",as.character(unique(Datos_Modulos$Tipo))),
                                        selected = "Por defecto"
                                        ),
                            
                            uiOutput('sSelect'),
                            
                            
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
                   tabPanel("Generadores",
                            
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
                   
                   tabPanel("Inversores",
                            
                            selectInput("slctInv",
                                        "Selecciona el inversor",
                                        choices = c("Personalizado",as.character(Datos_Inversores$Nombre)),
                                        selected = "Por Defecto"
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
      
      tabPanel('Resultados',
               
               navlistPanel( id = 'Result', widths = c(3,8),
               
               tabPanel("Datos Estación",
                       column(12, 
                        div(
                          p(
                            "A continuación, se muestran los datos del punto seleccionado, estos pueden filtrarse
                            usando los filtros que se encuentran al final de la tabla",
                            br(),
                            br(),
                            dataTableOutput("EstData"),
                            br(),
                            "La(s) estaciones seleccionadas son:",
                            dataTableOutput("EstList")
                            
                          ) 
                          ),
                          style = 'textalign = justify;'
                        )
                       
                        
                        
                        
                        ),
               
               tabPanel("Radiación en plano horizontal",
                        column(12,
                        div(
                          p(
                            strong("A continuación se muestran las radiaciones globales, directas y 
                                   difusas de los datos seleccionados:"),
                            br(),
                            dataTableOutput("RadData"),
                            br(),
                            br(),
                            strong("Los valores medios mensuales son:"),
                            br(),
                            dataTableOutput("MRadData"),
                            br(),
                            br(),
                            strong("Los valores medios anuales son:"),
                            dataTableOutput("YRadData"),
                            br(),
                            br(),
                            h4("Radiaciones en plano horizontal:"),
                            plotOutput("RadGraf")
                          
                          )
                        ),
                        style = 'texalign=justify;'
                        )
                        ),
               
               tabPanel("Radiación en plano generador",
                        column(12,
                               div(
                                 p(
                                   strong("A continuación se muestran las radiaciones globales, directas y 
                                          difusas de los datos seleccionados:"),
                                   br(),
                                   dataTableOutput("HRadData"),
                                   br(),
                                   br(),
                                   strong("Los valores medios mensuales son:"),
                                   br(),
                                   dataTableOutput("MHRadData"),
                                   br(),
                                   br(),
                                   strong("Los valores medios anuales son:"),
                                   dataTableOutput("YHRadData"),
                                   # br(),
                                   # br(),
                                   h4("Radiaciones en plano generador:"),
                                   plotOutput("HRadGraf")
                                   
                                   )
                               ),
                               style = 'texalign=justify;'
                        )
               ),
               
               tabPanel("Energía producida",
                        
                        "Se produce la siguiente energía",
                        
                        plotOutput("Graf2")
                        
                        )
               
               )
               ),
      tabPanel('Introducción')
      
      
    )        
            
    
    
    
  )
)
)