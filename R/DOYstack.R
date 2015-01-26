# This function...

DOYstack <- function(stack, date) {
  
  date <- as.list(t(date))
  
  for (i in 1:length(date) ) {
    names(stack)[i]=date[i]
  }

  return(stack)
}
