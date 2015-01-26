# this function.....

df2raster <- function(x){
  raster<- raster(matrix(as.numeric(x)/10000, 28, 28))
  return (raster)
}
