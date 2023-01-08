library(utils)
library(xml2)
library(rvest)
library(XML)
library(curl)
library(rlist)
library(tidyr)
library(stringr)


Auslesen<-function()
{
  
  #14 Die Aktie
  #18 Personal
  #20 Bewertung
  
  
  #6 Die Aktie
  #8 Personal
  #10 Bewertung
  
  if(length(html_table(Seite))==16){
    indexvector<-c(6,8,10)
  }
  
  if(length(html_table(Seite))==26){
    indexvector<-c(14,18,20)
  }
  
  
  
  for(index in indexvector){
  
    temp<-data.frame(html_table(Seite)[[index]])
    
    names(temp)<-temp[1,]
    rownames<-temp[,1]
    temp<-temp[,-1]
    
    for(i in 1:length(rownames)){rownames[i]<- paste(rownames[i], i, sep =" ")}
    
    row.names(temp) <- rownames
    
    temp<-temp[-1,]
    
    rows_to_delete<-c()
    
    for(i in 1:length(row.names(temp))){
      
      if(substr(row.names(temp)[i], 4, 10)=="Quartal"){
        
        
        rows_to_delete<-cbind(rows_to_delete, row.names(temp)[i])
        
      }
      
      
    }
    
    
    temp<-temp[!(row.names(temp) %in% rows_to_delete),]
    temp<-temp[colSums(!is.na(temp)) > 0]
    temp<-temp[!apply(temp == "", 1, all),]
    
    
    rownames<-row.names(temp)
    for(i in 1:length(rownames)){rownames[i]<- trimws(substr(rownames[i], 1, (nchar(rownames[i])-2)))}
    
    row.names(temp)<-rownames
   
    if(index == 14 || index ==  6){Die_Aktie<-temp}
    if(index == 18 || index ==  8){Personal<-temp}
    if(index == 20 || index == 10){Bewertung<-temp}
    
     
  }
  
  Gesamt<-rbind(Bewertung, Die_Aktie, Personal)
  
  
  return(Gesamt)
  
}


ISIN<-c("DE000A1EWWW0",        "NL0000235190",        "DE0008404005",        "DE000BASF111",
        "DE000BAY0017",        "DE0005200000",        "DE0005190003",        "DE000A1DAHH0",
        "DE0005439004",        "DE0006062144",        "DE000DTR0CK8",        "DE0005140008",
        "DE0005810055",        "DE0005552004",        "DE0005557508",        "DE000ENAG999",
        "DE0005785604",        "DE0005785802",        "DE0008402215",        "DE0006047004",
        "DE0006048432",        "DE0006231004",        "IE00BZ12WP82",        "DE0007100000",
        "DE0006599905",        "DE000A0D9PT0",        "DE0008430026",        "DE000PAG9113",
        "DE000PAH0038",        "NL0012169213",        "DE0007037129",        "DE0007164600",
        "DE0007165631",        "DE0007236101",        "DE000ENER6Y0",        "DE000SHL1006",
        "DE000SYM9999",        "DE0007664039",        "DE000A1ML7J1",        "DE000ZAL1111")

n<-length(ISIN)

setwd("C:\\Users\\danie\\Documents\\Aktien\\Rohdaten\\Dax")

for(i in 1:n){
  
  #URL<-paste("https://www.ariva.de/", ISIN[i], "/bilanz-guv", sep = "")
  
  #download.file(URL, ISIN[i])
  
  #URL<-paste("https://www.ariva.de/", ISIN[i], "/bilanz-guv?page=6", sep = "")
  #download.file(URL, paste(ISIN[i], "_2011_2016", sep=""))
  
  #URL<-paste("https://www.ariva.de/", ISIN[i], "/bilanz-guv?page=12", sep = "")
  #download.file(URL, paste(ISIN[i], "_2005_2010", sep=""))
}

Seite<-read_html("DE000A1EWWW0_2005_2010")  
Gesamt<-Auslesen()

Seite<-read_html("DE000A1EWWW0_2011_2016")  
Gesamt<-cbind(Gesamt,Auslesen())


Seite<-read_html("DE000A1EWWW0")  
Gesamt<-cbind(Gesamt,Auslesen())




Gesamt<-Gesamt[1:(length(Gesamt)-1)]
Gesamt[Gesamt == "-"] <- "0"

n<-dim(Gesamt)[1]
m<-dim(Gesamt)[2]

for(i in 1:n){
  for(j in 1:m){
    Gesamt[i,j]<-as.numeric(str_replace(Gesamt[i,j], ",", "."))
  }
}

for(i in 1:length(row.names(Gesamt))){row.names(Gesamt)[i]<- str_replace(row.names(Gesamt)[i], " EUR", " TEUR")}



if(length(html_table(Seite))==26){
  Branche <-as.character(html_table(Seite)[[22]][7,2])
  Sektor <- as.character(html_table(Seite)[[22]][9,2])
  Land <- as.character(html_table(Seite)[[22]][5,2])
}

Gesamt$Name<-word(html_text(Seite), start = 1, end = 1, sep = fixed(" "))
Gesamt$Branche<-Branche
Gesamt$Sektor<-Sektor
Gesamt$Land<-Land