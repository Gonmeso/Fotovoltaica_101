setwd("D:/TFG/Fotovoltaica 101/Fotovoltaica_101")
library(readr)
DatosSiar <- read.csv("data/Siar_Data.csv",  encoding="UTF-8")


TryFata <- read.csv("data/Almeria/AL01_La Mojonera_01_01_2015_31_12_2015.csv", 
                    header = TRUE,
                    fileEncoding = "UTF-16LE",
                    sep = ";")
