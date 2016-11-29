##setwd("D:/TFG/Fotovoltaica 101/Fotovoltaica_101")
library(data.table)


if(!exists("DatosSiar")){
##Carga de DatosSiar para la creaci�n de marcadores y popups
DatosSiar <- fread("data/Siar_Data.csv",  encoding="UTF-8")
DatosSiar$ID <- with(DatosSiar,
                     paste(N_Provincia, N_Estacion, sep = '.'))
}

if(!exists("AllData")){

    ##Lista para cargar los archivos con los datos de las estaciones
    myData <- list.files("data/", pattern = "Estaciones_Siar")
    
    ##Leemos los ficheros y los metemos en una lista
    old <- setwd('data/')
    EstacionesSiar <- lapply(myData, read.csv2,
                             fileEncoding = "UTF-16LE")                         
    setwd(old)
    ##Merge de todos los dataframes en uno
    AllData <- rbindlist(EstacionesSiar, fill = TRUE)
    ## Selecciono variables de inter�s
    AllData <- AllData[, c(1, 2, 3, 6, 11), with = FALSE]
    names(AllData)[c(4, 5)] <- c("Ta", "G0")
    AllData[ ,
            ID := paste(IdProvincia,
                        IdEstacion,
                        sep = '.')
            ]
    ## �ndice temporal como POSIXct para calcG0 etc.
    AllData[,
            Fecha := as.POSIXct(Fecha,
                                format = '%d/%m/%Y')
            ]
    ##Paso de MJ/m2 a Wh/m2
    AllData[,
            G0 := G0*1000/3.6
            ]

}