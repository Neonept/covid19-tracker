
# Functions



tidyWorld <- function(countryName){
  
  encodedurl<-URLencode("https://pomber.github.io/covid19/timeseries.json")
  out <-  jsonlite::fromJSON(encodedurl)
  x <- out[[countryName]]
  names(x) <- c("Tarih", "Vaka sayisi", "Vefat sayisi", "Iyilesen sayisi")
  gather(x, type, number, `Vaka sayisi`:`Iyilesen sayisi`)
  
}
