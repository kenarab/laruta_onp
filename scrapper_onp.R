#install.packages("scrapeR")
library("scrapeR")
library("RCurl")

curl<-getCurlHandle()
url_onp<-"http://www.mecon.gov.ar/onp/html/presutexto/ley2014/leydoscatorce.html"
doc = htmlTreeParse(url_onp, useInternalNodes = T)

scrape(object=txt,parse=TRUE)

setwd('~/Descargas/')
anio<-2010
for (anio in c(2003:2014)){
  if (anio %in% c(2011:2014))
    filetype<-'.rtf'
  else
    filetype<-'.doc'
  command<-paste('wget http://www.mecon.gov.ar/onp/html/presutexto/proy',anio,'/ley/pdf/anexo_estadistico/cuadros_comparativos/cap1cu04',filetype,' -O cap1cu04_',anio,filetype,sep='')
  print(command)
  system(command)
}
