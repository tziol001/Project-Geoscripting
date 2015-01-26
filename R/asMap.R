# create a plot using ggplot package

asMap <-
  function(raster)
  {

map.points <- rasterToPoints(raster)

# convert points to dataframe
df <- data.frame(map.points)

# create the appropriate column headings
colnames(df) <- c("Longitude", "Latitude", "Value")

# crate map with ggplot
ggplot(aes(x = Longitude, y = Latitude, fill = Value), data = df) + 
  geom_raster() + coord_equal() + 
  ggtitle("Normalized Difference Vegetation Index in Lelystad") + 
  theme(plot.title = element_text(lineheight=.8, face="bold"))+
  scale_fill_continuous(low="brown", high="green", limits=c(-0,1)) +
  labs(fill = "NDVI")  +
  theme_bw()
}