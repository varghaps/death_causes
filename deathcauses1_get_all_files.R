##Hungary detailed mortality data, from http://www.oefi.hu/halalozas/

## this part of the code downloads the data and merges it into a single R dataframe 


#load packages
library(XLConnect)
library(XML)


#scrape region list

    fileUrl<-"http://www.oefi.hu/halalozas/"

    doc <- htmlTreeParse(fileUrl,useInternal=TRUE, encoding="UTF-8")

    rootNode <- xmlRoot(doc)

    #select terseg1 aka kisterseg
    kistersegek<-xpathSApply(rootNode,"//select[@id='terseg1']/option", xmlAttrs)

    #massage data to get list of xls files to download
    kistersegek<-unique(unlist(kistersegek))
    kistersegek<-kistersegek[!kistersegek=="selected"]  #remove the word selected from region list
    kistersegek<-gsub(".html",".xls", kistersegek)



fajtak<-c("tenyleges", "varhato")

#download data for each region in a loop
data=NULL



for (i in kistersegek) {
  
    for (fajta in fajtak) {
    
        for (ev in 2005:2013) {

          #file_name<-paste0("http://www.oefi.hu/halalozas/tablak/xls/y=", ev, "&t=", fajta, "&terseg=Kisterseg&tid=", i)
          dest_name<-paste(fajta,ev,i, sep="_")
    
          #download.file(file_name, destfile=dest_name, mode="wb")
    
         #put together all data in a dataframe
         data<-rbind(data, readWorksheetFromFile(dest_name, sheet=1, startRow=2)) 

}}}

save(data,file="data.Rda")
