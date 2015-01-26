#
rm(list=ls()) # clear the workspace

getwd()# make sure the data directory

library(sp)
library(raster)
library(kml)
library(ggplot2)
library(rgdal)

source('R/ModisSubset.R')
source('R/getDate.R')
source('R/modisRaster.R')
source('R/df2raster.R')
source('R/DOYstack.R')
source('R/asMap.R')
source('R/getROI.R')

# run an example of ModisSubset
ndvi_clear13 <- modisSubset("Lelystad", "NDVI", 2013, rel = TRUE) 
ndvi_clear14 <- modisSubset("Lelystad", "NDVI", 2014, rel = TRUE) 

# run an example of modisRaster 
stack_2013 <- modisRaster(ndvi_clear13,"Lelystad")
stack_2014 <- modisRaster(ndvi_clear14,"Lelystad")

# get dates of the selected subsets
DOY2013<- getDate("Lelystad", "NDVI", 2013)
DOY2014<- getDate("Lelystad", "NDVI", 2014)

# gives names in stack layers
stack2013 <- DOYstack(stack_2013, DOY2013)
stack2014 <- DOYstack(stack_2014, DOY2014)

# plot an example by looking the names 
names(stack2013)
asMap(stack2013$X1)

KML(stack2013$X1, filename = "data/ndvi.kml")

help(raster)

**********************************************************************************
# url <- "https://github.com/tziol001/Project-Geoscripting/blob/master/data/clc2012.zip"
# download.file(url=url, destfile='data/corine.zip', method='auto')
unzip('data/clc2012.zip')

#import the corine landcover 2012
corine <- list.files ('clc2012/', pattern = glob2rx('*.shp'), full.names = TRUE)
layerName <- ogrListLayers(corine)
clc2012 <- readOGR(corine, layer = layerName)

# select the deciduous forest clc_code: 311
clc2012_forest <- clc2012[clc2012$CODE_12 == 311,]
***********************************************************************************

# run an example of getROI in order to create a data frame with values of region of interest
df2013<- getROI(stack2013, clc2012_forest)
df2014<- getROI(stack2014, clc2012_forest)

# prepare the data for pheno analysis
dn<-t(df2013)
dn<-as.data.frame(dn)
row.names(dn) <- ndvi_clear$Date

analysis<-cbind(DOY2013, dn)
