# this function...

getPhenology <-
  function(df, DOYdf, year )
  {
    t.df<-as.data.frame(t(df))
    
    analysis<-cbind(DOYdf, t.df)
    
    x = DOYdf$Date
    ndvi <- matrix( nrow=366, ncol=length(t.df), byrow=FALSE)
    for(i in 1:length(t.df)){
      ndvi[x,i] <- analysis[,i]
    }
      #Fit an assymmetric Gausian
      ndvi.mod <- modelNDVI(ndvi.values=ndvi, year.int=year, 
                            correction="bise", method="Gauss",asym=TRUE,slidingperiod=40)
      
      #estimate phenological parameters
      metrics <- matrix( nrow=1, ncol=length(ndvi.mod), byrow=FALSE)
      metrics<-as.data.frame(metrics)
      
      for(i in 1:length(metrics)){
        #greenup day  
        metrics[1,i] <- round((phenoPhase(ndvi.mod[[i]], phase="greenup", method="global", threshold=0.35)
                               + phenoPhase(ndvi.mod[[i]], phase="greenup", method="global", threshold=0.40)
                               + phenoPhase(ndvi.mod[[i]], phase="greenup", method="global", threshold=0.45))/3)
        
      }
      return (metrics)
    }