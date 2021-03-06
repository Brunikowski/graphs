# install.packages("RCurl")
rm(list=ls(all.names = T))
library(RCurl)
library(data.table)
# library(ggplot2)
library(dplyr)
# mynewdat<-read.table('https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv',
#                      sep=",")
mynewdat<-read.table('https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv',sep = ",", header=T)

# mynewdat$weekdays<-format(mynewdat$date,"%A")
mynewdat$weekdays<-weekdays(as.Date(mynewdat$date))

mynewdat$daytype<-mynewdat$weekdays
wind<-which(grepl(paste(c("Sonntag", "Samstag"), collapse = "|"),mynewdat$weekdays))
nowind<-which(!grepl(paste(c("Sonntag", "Samstag"), collapse = "|"),mynewdat$weekdays))

mynewdat$daytype[wind]<-"weekend"
mynewdat$daytype[nowind]<-"work"

chdat<-mynewdat[which(mynewdat$country_region_code=="CH"),]
df<-chdat
write.table(df, sep=",", file = "C:\\Users\\Stephan\\Documents\\mobility\\google_mobility_change_CH.csv", row.names=F)


temp <- tempfile(fileext = ".zip")
# https://www.covid19.admin.ch/api/data/20210102-5g4kldkc/downloads/sources-csv.zip
url<-"https://www.covid19.admin.ch/api/data/20210102-5g4kldkc/downloads/sources-csv.zip"
# url<-"https://www.covid19.admin.ch/api/data/20210102*.zip"

download.file(url = url, temp)
con <- unz(temp, "data/COVID19Cases_geoRegion_AKL10_w.csv")
cases <- read.table(con, header=T, sep=",")
con <- unz(temp, "data/COVID19Death_geoRegion_AKL10_w.csv")
deaths <- read.table(con, header=T, sep=",")
coviddf<-bind_cols(cases, deaths)
write.table(coviddf, sep=",", row.names = F, file = "C:\\Users\\Stephan\\Documents\\mobility\\cases_CH.csv")
