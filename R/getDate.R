# This function....

getDate <-
  function(site, band, year)
  {
    Sites_info <- read.csv("data/MODIS_Subset_Sites_Information.csv")
    pos <- which(Sites_info$Site_Name == site)
    fluxtower<- paste0(Sites_info$Site_ID[pos],".txt")
    modis <- read.csv(fluxtower, colClasses = "character")
      
    # convert the date format
modis$Date <- as.Date(modis$Date,"A%Y%j")
 
 date <- modis[modis$Band == paste0("250m_16_days_",band) & as.numeric(format(modis$Date, "%Y")) == year,3:4] # NEW
  date$Site <- NULL
  date$Date<-as.numeric(strftime(date$Date, format="%j",tz="EST"))
 return(date)
}