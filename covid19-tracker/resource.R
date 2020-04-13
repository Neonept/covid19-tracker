
library("rvest")

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
rdate<-gsub("I", "I", rdate)
rdate<-data.frame(rdate, stringsAsFactors = FALSE)
colnames(rdate)<-"Tarih"
write.csv(rdate, './data/date.txt', row.names = FALSE)


today<-t(data_todaysNumbers)
today<-as.data.frame(today)
colnames(today)<-c("Test sayisi", "Vaka sayisi", "Vefat sayisi", "Iyilesen sayisi")
today$date<-rdate$Tarih
write.csv(today, "./data/today.txt", row.names = FALSE)

total<-t(data_totalNumbers)
total<-as.data.frame(total)
total<-total[c(1:3,6)]
colnames(total)<-c("Test sayisi", "Vaka sayisi", "Vefat sayisi", "Iyilesen sayisi")
write.csv(total, "./data/total.txt", row.names = FALSE)


