
# Functions



tidyWorld <- function(countryName){
  
  encodedurl<-URLencode("https://pomber.github.io/covid19/timeseries.json")
  out <-  jsonlite::fromJSON(encodedurl)
  x <- out[[countryName]]
  names(x) <- c("Tarih", "Vaka sayisi", "Vefat sayisi", "Iyilesen sayisi")
  gather(x, type, number, `Vaka sayisi`:`Iyilesen sayisi`)
  
}

encodedurl<-URLencode("https://pomber.github.io/covid19/timeseries.json")
out <-  jsonlite::fromJSON(encodedurl)
df <- data.frame(matrix(names(out), nrow = length(out), ncol = 1))
names(df)<-"countries"

for (i in 1:length(out)){
  
  a <- length(out[[1]][,1])
  df$confirmed[i] <- out[[i]][a,2]
  df$deaths[i] <- out[[i]][a,3]
  df$recovered[i] <- out[[i]][a,4]
}

worlddata<- get_data_from_map(download_map_data("custom/world-highres"))
nout<-data.frame(names(out))
nout$`hc-key` <- worlddata$`hc-key`[match(names(out), worlddata$name)]
names(nout)[1]<-"countries"
nout<-merge(nout, df, by = "countries")
nout[c(12,28,30,39,40,42,46,58,72,91,126,148,164,165,167,177),2]<- c("bs","mm","cv","cg","cd","ci","cz","sz","gw","kr","mk","rs","tw","tz","tl","us")



