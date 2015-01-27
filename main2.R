#
rm(list=ls()) # clear the workspace

getwd()# make sure the data directory

library(phenex)
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
source('R/getPhenology.R')

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
#names(stack2013)
#asMap(stack2013$X1)
#KML(stack2013$X1, filename = "data/ndvi.kml")

***********************************************************************************
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
***********************************************************************************
# prepare the data for pheno analysis
greenup2013<-getPhenology(df2013, DOY2013, 2013)
greenup2014<-getPhenology(df2014, DOY2014, 2014)

diff <- greenup2014 - greenup2013

as<-as.data.frame(t(diff))
as$V1
boxplot(as,col=rainbow(10),main="", ylab ="green-up date (DOY)",ylim=c(-200, 200), xlab ="method")
hist(as$V1, breaks=200, main="Comparison of greenup dates ", xlab="DOY")


write.table(diff,"data/diff.txt")
greenup_diff <- modisRaster(diff,"Lelystad")

KML(greenup_diff, filename = "data/diff.kml")
****************
subdat<-SpatialPolygonsDataFrame(greenup, data=greenup)



plot(greenup)
points(true.ndvi@correctedValues,col="red")
lines(ndvi.mod[[1]]@modelledValues,col="blue")
