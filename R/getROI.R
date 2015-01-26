# this function...

getROI <-
  function(raster, ROI)
  {

# project the layer using the ndvi raster projection
ROI_proj2raster <- spTransform(ROI, CRS(proj4string(raster)))

# mask the Lelysta forest
masked_ROI <- mask(raster, ROI_proj2raster)

# get the values for a raster brick into a new data frame!
valuetable <- getValues(masked_ROI)
valuetable <- as.data.frame(masked_ROI)

return (valuetable)
}