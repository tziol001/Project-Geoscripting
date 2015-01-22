
rm(list=ls()) # clear the workspace

getwd()# make sure the data directory

library(sp)
library(raster)
library(kml)

# select the fluxtower
fluxtower <- c("fn_nlloobos.txt")
filename <- paste("ftp://daac.ornl.gov//data/modis_ascii_subsets//C5_MOD13Q1/data/MOD13Q1.",
                  fluxtower, sep = "")

# download the modis subset data
if (!file.exists(fluxtower)) {
  download.file(filename, destfile = paste("data/",fluxtower), method = "auto")
  modis <- read.csv(paste("data/",fluxtower), colClasses = "character")
} 
  stop ("The selected fluxtower is not supported")

## the site coordinates are projected in lat/long
latlong <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
## convert these to sinusoidal projection
modissin <- 
  "+proj=sinu +lon_0=0 +x_0=0 +y_0=0+a=6371007.181 +b=6371007.181+units=m +no_defs"

## The 28x28 dimensions are specified by looking: http://daac.ornl.gov/cgi-bin/MODIS/GR_col5_1/corners.1.pl?site=fn_nlloobos&res=250m

#Subset of ndvi values and correspondings days
# ndvi <- modis[modis$Band == "250m_16_days_NDVI" , c(3, 7:790)]
 ndvi <- modis[modis$Band == "250m_16_days_NDVI" , 7:790]
# The 28x28 dimensions are specified by looking: http://daac.ornl.gov/cgi-bin/MODIS/GR_col5_1/corners.1.pl?site=fn_nlloobos&res=250


ndvi<- raster(t(matrix(as.numeric(ndvi)/10000, 28, 28)))

a<- apply(ndvi, 1, function(x) raster(t(matrix(as.numeric(x)/10000, 28, 28))))

cv <- modis[modis$Band == "250m_16_days_NDVI" & modis$Date=="A2001033", 7:790]
cv <- raster(t(matrix(as.numeric(cv)/10000, 28, 28)))

sa<- t(matrix(as.numeric(cv)/10000)

sa<- t(matrix(as.numeric(unlist(ndvi))/10000))








projection(ndvi)<-latlong

# create the extent by looking at modis subset site: http://daac.ornl.gov/cgi-bin/MODIS/GR_col5_1/mod_viz.html
xmin<- 5.695686
xmax<- 5.798324
ymin<- 52.137500
ymax<- 52.195833
extent <- extent(xmin, xmax, ymin, ymax)

# use the extent in the raster layer
ndvi<-setExtent(ndvi, extent, keepres=FALSE, snap=FALSE)

ndvi
#result
plot(ndvi)
KML(ndvi) 