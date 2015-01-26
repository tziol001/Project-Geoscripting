# Function to automatic download MODIS data
 
# Description: Automatically obtain MODIS EVI or NDVI subsets for any of the existed   flux towers, for a specific year. The data for each pixel can be cleaned or not according to the MODIS reliability band, and they are returned in a data frame.

# parameter (type, description)

# site (Character, It can be one of the flux towers from around the world)
# band (Character, It can be one of the two vegetation indices "EVI" or "NDVI")  
# year (Numeric, All data which are different from this year will be removed)
# rel, (Logical, If rel is TRUE a cleaning will be performed in the vegetation indices values by using the MODIS reliability information band)


modisSubset <-
  function(site, band, year, rel = TRUE)
  {
    # download automatically MODIS sites information
    if(!file.exists("data/MODIS_Subset_Sites_Information.csv")){
      download.file("ftp://daac.ornl.gov//data/modis_ascii_subsets/5_MODIS_Subset_Sites_Information_Collection5.csv", "data/MODIS_Subset_Sites_Information.csv")
      Sites_info <- read.csv("data/MODIS_Subset_Sites_Information.csv")
    }
    else{
      Sites_info <- read.csv("data/MODIS_Subset_Sites_Information.csv")
    }
    
    # check if the selected fluxtower exists and specify in which row
    if (site %in% Sites_info$Site_Name){
      pos <- which(Sites_info$Site_Name == site)
      
    # create the extent, (xmin, xmax, ymin, ymax), by looking at modis subset info data frame.     
      extent <- extent(Sites_info$NW_Longitude_edge[pos], Sites_info$SE_Longitude_edge[pos], Sites_info$SE_Latitude_edge[pos], Sites_info$NW_Latitude_edge[pos])
      
    } else {
      stop("The area that you select is not contained in MODIS subsets")
    }
    
    # download the modis subset data for the selected fluxtower. If the file exists   already in the working directory the function just read the table withour download it again.
    fluxtower<- paste0(Sites_info$Site_ID[pos],".txt")
    
    filename <- paste("ftp://daac.ornl.gov//data/modis_ascii_subsets//C5_MOD13Q1/data/MOD13Q1.", fluxtower, sep = "")
    
    if(!file.exists(fluxtower)){
      download.file(filename, fluxtower)
      modis <- read.csv(fluxtower, colClasses = "character")
    }
    else{
      modis <- read.csv(fluxtower, colClasses = "character")
    }
    
    # convert the date format
    modis$Date <- as.Date(modis$Date,"A%Y%j")

    # create subsets for selected year and vegetation index, if rel is TRUE a cleaning procedure also will be executed
    if(rel){
      modisSubset_band <- modis[modis$Band == paste0("250m_16_days_",band) & as.numeric(format(modis$Date, "%Y")) == year,7:790]
      
      modisSubset_reliability <- modis[modis$Band == "250m_16_days_pixel_reliability" & as.numeric(format(modis$Date, "%Y")) == year, 7:790]
      
      # remove clouds based on provided '250m_16_days_pixel_reliability' layer
      modisSubset_band[modisSubset_reliability < 1] <- NA
            
    } else {
      
      modisSubset_band <- modis[modis$Band == paste0("250m_16_days_",band) & as.numeric(format(modis$Date, "%Y")) == year, 7:790]
              
    }
    
    return(modisSubset_band)
  }