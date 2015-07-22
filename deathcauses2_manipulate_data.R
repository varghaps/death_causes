##Hungary detailed mortality data

##data manipulation


library(reshape2)
library(dplyr)


#remove accents from names
names(data)<-iconv(names(data), to='ASCII//TRANSLIT')

#rename sex_age_group in variable names
names(data)[6:24]<-gsub("X","ffi_", names(data)[6:24] )
names(data)[25:43]<-gsub("X","no_", names(data)[25:43] )
names(data)[25:43]<-substr(names(data)[25:43], 1, nchar(names(data)[25:43])-2)

#subset of female variables
nok<-c(1:5,25:43)

#the original data is in a wide format, with sex-age pairs in separate columns

#create long data for each sex
data_long_ffi<-melt(data[1:24], measure.vars=names(data)[6:24], variable.name="kor", value.name="halalozas")
data_long_no<-melt(data[nok], measure.vars=names(data)[25:43], variable.name="kor", value.name="halalozas")

#female and male index
data_long_ffi$nem="ffi"
data_long_no$nem="no"

#merge the two datasets (female and male)
data_long<-merge(data_long_ffi, data_long_no)

#add total deaths as variable
data_long<-data_long %>% group_by(nem, ev, terseg, kor, Ertek) %>% mutate(halal_total = halalozas[1]) 

save(data_long,file="data_long.Rda")
####### data_long saved #########

#load("~/R/hun/data_long.Rda")

data_long<-ungroup(data_long)

#change coding of age, region
data_long$kor<-gsub("ffi_", "", data_long$kor)
data_long$kor<-gsub("no_", "", data_long$kor)
data_long$kor<-gsub(".", "_", data_long$kor, fixed=TRUE)
data_long$terseg<-gsub("Kistérség :  ", "", data_long$terseg, fixed=TRUE)
data_long$terseg<-gsub("Kistérség: ", "", data_long$terseg, fixed=TRUE)

#recode as numeric
data_long$ev<-as.numeric(data_long$ev)
data_long$halalozas<-as.numeric(data_long$halalozas)
data_long$halal_total<-as.numeric(data_long$halal_total)

#select how many years to average
how_many_years<-3

#average data for the most recent x years selected above
data_average<-data_long %>% filter(ev>2013-how_many_years & Ertek=="tényleges") %>% group_by(nem, terseg, kor, Halalok.kategoria) %>% summarize(halalozas=mean(halalozas), halal_total=mean(halal_total))

#calculate share of deaths variable
data_average<-ungroup(data_average) %>% mutate(halal_ossz_arany=halalozas/halal_total)

#recode NaN as zeros
data_average$halal_ossz_arany[is.nan(data_average$halal_ossz_arany)]<-0

#summarize top causes
data_av_top<- data_average %>% filter(halal_ossz_arany>0 | Halalok.kategoria=="Összes halálozás") %>% group_by(nem, terseg, kor) %>% top_n(10, halal_ossz_arany) 

data_av_top<- ungroup(data_av_top)
save(data_av_top, file="data_av_top.Rda")
