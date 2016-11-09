setwd("D:/TFG/Fotovoltaica 101/Fotovoltaica_101")
library(data.table)

##Carga de DatosSiar para la creación de marcadores y popups
DatosSiar <- read.csv("data/Siar_Data.csv",  encoding="UTF-8")

##Lista para cargar los archivos con los datos de las estaciones
myData <- list.files("data/", pattern = "*.csv")

##Eliminamos la última posición (DatosSiar)
myData1 <- myData[1:length(myData)-1]


setwd("D:/TFG/Fotovoltaica 101/Fotovoltaica_101/data")

##Leemos los ficheros y los metemos en una lista
if(is.null(EstacionesSiar)==TRUE){

EstacionesSiar <- lapply(myData1, read.csv,header = TRUE,
                                          fileEncoding = "UTF-16LE",
                                          sep = ";" )
}

##Merge de todos los dataframes en uno
AllData <- rbindlist(EstacionesSiar, fill = TRUE)
