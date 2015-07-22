##Hungary detailed mortality data

## Translate death causes data (and remove some unneeded rows)

#load data
if (!exists("data_av_top")) load("data_av_top.Rda")

#create new data frame
death_causes<-data_av_top

#change variable names to English
names(death_causes)<-c("sex", "region", "age", "death_cause", "n_deaths", "total_n_deaths", "death_share")

#recode sex variable
death_causes$sex[death_causes$sex=="ffi"]<-"male"
death_causes$sex[death_causes$sex=="no"]<-"female"

#recode death causes from key table

    if (!exists("death_key_table")) death_key_table<-read.csv("death_codes.csv")

    #recode accented characters that do not allow merging
      death_key_table$death_cause<-iconv(death_key_table$death_cause, to="ASCII//TRANSLIT") 
      #need stringi package because non-utf character recode does not work otherwise
      library(stringi)
      death_causes$death_cause<-stri_trans_general(death_causes$death_cause, "Latin-ASCII")

#check whether all death causes match in two tables
index<-death_causes$death_cause %in% death_key_table$death_cause
table(index)
#OK, so we can merge the two

death_causes<-merge(death_causes, death_key_table, by="death_cause")

#remove avoidable, and smoking-related
death_causes$to_remove<-death_causes$death_cause_english %in% c("Avoidable deaths (amenable causes)", "Attributable to smoking")

death_causes<-death_causes[!death_causes$to_remove,]


save(death_causes,file="death_causes.Rda")