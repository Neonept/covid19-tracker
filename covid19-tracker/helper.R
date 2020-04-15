
library(data.table)
library(rvest)
library(dplyr)

todayn<-fread("./data/today.txt")
totaln<-fread("./data/total.txt")
daten<-fread("./data/date.txt", sep = ",")
daten<-as.data.frame(daten)
todayn<-as.data.frame(todayn)
totaln<-as.data.frame(totaln)

dat<-read.csv("./data/data_turkey.txt")
a <- read.csv("./data/first_index.txt")
b <- read.csv("./data/last_index.txt")
a <- a$x
b <- b$x

url <- "https://covid19.saglik.gov.tr"
webpage <- read_html(url)


todaysNumbers <- html_nodes(webpage,'.baslik-k-2 span:nth-child(2)')
data_todaysNumbers<-html_text(todaysNumbers)
data_todaysNumbers<-gsub("\\.", "", data_todaysNumbers)
data_todaysNumbers<-as.numeric(data_todaysNumbers)


totalNumbers <- html_nodes(webpage,'.col-sm-6 span+ span')
data_totalNumbers<-html_text(totalNumbers)
data_totalNumbers<-gsub("\\.", "", data_totalNumbers)
data_totalNumbers<-gsub("\r\n                                                                        ", "", data_totalNumbers)
data_totalNumbers<-gsub("\r\n                                                                    ", "", data_totalNumbers)
data_totalNumbers<-as.numeric(data_totalNumbers)


dates <- html_nodes(webpage, '.text-center p')
data_dates<-html_text(dates)
rdate<-paste(data_dates[1], data_dates[2], data_dates[3])
rrdate<-strsplit(rdate, split = "")
rrdate<-unlist(rrdate)
rdate<-gsub(rrdate[5], "I", rdate)
rdate<-data.frame(rdate, stringsAsFactors = FALSE)
colnames(rdate)<-"Tarih"

today<-t(data_todaysNumbers)
today<-as.data.frame(today)
colnames(today)<-c("Test sayisi", "Vaka sayisi", "Vefat sayisi", "Iyilesen sayisi")
today$date<-rdate$Tarih


total<-t(data_totalNumbers)
total<-as.data.frame(total)
total<-total[c(1:3,6)]
colnames(total)<-c("Test sayisi", "Vaka sayisi", "Vefat sayisi", "Iyilesen sayisi")
total$date<-rdate$Tarih


if (daten$Tarih != rdate$Tarih){
  daten <- rdate
  todayn <- rbind(todayn, today)
  totaln <- rbind(totaln, total)
  write.csv(daten, "./data/date.txt", row.names = FALSE)
  write.csv(todayn, "./data/today.txt", row.names = FALSE)
  write.csv(totaln, "./data/total.txt", row.names = FALSE)
  a=5
}

ch_todayn<-todayn[,2:5]
ch_totaln<-totaln[,2:5]
changetest<-(todayn$`Test sayisi`[length(todayn$`Test sayisi`)]-todayn$`Test sayisi`[length(todayn$`Test sayisi`)-1])/
  todayn$`Test sayisi`[length(todayn$`Test sayisi`)-1]

changevaka<-(todayn$`Vaka sayisi`[length(todayn$`Vaka sayisi`)]-todayn$`Vaka sayisi`[length(todayn$`Vaka sayisi`)-1])/
  todayn$`Vaka sayisi`[length(todayn$`Vaka sayisi`)-1]






url2<- "https://tr.wikipedia.org/wiki/T\u00FCrkiye%27de_2020_koronavir\u00FCs_pandemisi"
webpage2 <- read_html(url2)
turkey <- html_nodes(webpage2,'.mw-parser-output div td:nth-child(1)')
data_turkey<-html_text(turkey)
data_turkey<-data_turkey[(a+1):(b+1)]
data_turkey<-gsub("\n", "", data_turkey)
data_turkey<-data.frame(data_turkey)
colnames(data_turkey)<-"Sehirler"

if (all(data_turkey$Sehirler != dat$Sehirler)){
  
  a <- a+1
  b <- b+1
  
  data_turkey<-data_turkey[(a+1):(b+1)]
  data_turkey<-gsub("\n", "", data_turkey)
  data_turkey<-data.frame(data_turkey)
  colnames(data_turkey)<-"Sehirler"
  write.csv(data_turkey, "./data/data_turkey.txt", quote = FALSE, row.names = FALSE)
  write.csv(a, "./data/first_index.txt", quote = FALSE, row.names = FALSE)
  write.csv(b, "./data/last_index.txt", quote = FALSE, row.names = FALSE)
  
}



turkey2 <- html_nodes(webpage2,'.mw-parser-output div td:nth-child(2)')
data_turkey2<-html_text(turkey2)
data_turkey2<-data_turkey2[a:b]
data_turkey2<-gsub("\n", "", data_turkey2)

data_turkey$`Vaka sayisi` <- data_turkey2

mapdata <- get_data_from_map(download_map_data("countries/tr/tr-all"))
mapdata <- mapdata[-4,]
mapdata<-select(mapdata, name, longitude, latitude)
mapdataSort<- mapdata[order(mapdata$name),]

mapdata1<-mapdataSort[,1]
mapdata1$lat<-mapdataSort$latitude
mapdata1$lon<-mapdataSort$longitude
mapdata1$z<-data_turkey$`Vaka sayisi`
colnames(mapdata1)[1]<-"name"

mapdata1$z<-as.numeric(mapdata1$z)
