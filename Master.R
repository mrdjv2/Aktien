library(utils)
library(xml2)
library(rvest)

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
  
  URL<-paste("https://www.ariva.de/", ISIN[i], "/bilanz-guv", sep = "")
  
  download.file(URL, ISIN[i])
  
}
  

#test
test<-read_html("DE000A1EWWW0")

test2<-html_nodes(test, ".right")