##setwd("D:/TFG/Fotovoltaica 101/Fotovoltaica_101")
library(data.table)


if(!exists("DatosSiar")){
##Carga de DatosSiar para la creación de marcadores y popups
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
AllData[ ,
        ID := paste(IdProvincia,
                    IdEstacion,
                    sep = '.')
        ]
colnames(AllData)[colnames(AllData)=="Radiación..MJ.m2."] <- "G0"
colnames(AllData)[colnames(AllData)=="Temp.Media..ºC."] <- "Ta"
}