#install.packages("scrapeR")
pkgTest("scrapeR")
pkgTest("RCurl")
pkgTest("rtf")

curl<-getCurlHandle()
url_onp<-"http://www.mecon.gov.ar/onp/html/presutexto/ley2014/leydoscatorce.html"
doc = htmlTreeParse(url_onp, useInternalNodes = T)

scrape(object=txt,parse=TRUE)
  
#script de ejemplo
#wget http://www.mecon.gov.ar/onp/html/presutexto/proy2014/ley/pdf/anexo_estadistico/cuadros_comparativos/cap1cu04.rtf -O cap1cu04_2014.rtf
# entidades 'http://www.mecon.gov.ar/onp/html/presutexto/ley2013/ley/pdf/anexo_estadistico/cuadros_comparativos/cap3cu03.rtf'

setwd('~/Descargas/')
anio<-2010
cap1cu04



retrieve_docs(2001,'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap1cuo4','.pdf','/var/tmp/hhba-laruta/jur-adm-nac/')
retrieve_docs(2002,'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap1cu04','.pdf','/var/tmp/hhba-laruta/jur-adm-nac/')
retrieve_docs(c(2003:2010),'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap1cu04','.doc','/var/tmp/hhba-laruta/jur-adm-nac/')
retrieve_docs(2011,'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap1cu04','.rtf','/var/tmp/hhba-laruta/jur-adm-nac/')
#2011 no hubo ley de presupueso, se extendio el anterior. No se de donde lo saque
retrieve_docs(c(2011:2014),'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap1cu04','.rtf','/var/tmp/hhba-laruta/jur-adm-nac/')
retrieve_docs(c(2014:2014),'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap1pla2','.rtf','/var/tmp/hhba-laruta/jur-adm-nac/')

output_dir<-'/var/tmp/hhba-laruta/jur-adm-cen/'
retrieve_docs(2001,'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap2cuo3','.pdf',output_dir)
retrieve_docs(2002,'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap2cu03','.pdf',output_dir)
retrieve_docs(c(2003:2010),'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap2cu03','.doc',output_dir)
retrieve_docs(2011,'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap2cu03','.rtf',output_dir)
#2011 no hubo ley de presupueso, se extendio el anterior. No se de donde lo saque
retrieve_docs(c(2011:2014),'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap2cu03','.rtf',output_dir)

output_dir<-'/var/tmp/hhba-laruta/jur-descent/'
retrieve_docs(2001,'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap3cuo3','.pdf',output_dir)
retrieve_docs(2002,'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap3cu03','.pdf',output_dir)
retrieve_docs(c(2003:2010),'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap3cu03','.doc',output_dir)
retrieve_docs(2011,'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap3cu03','.rtf',output_dir)
#2011 no hubo ley de presupueso, se extendio el anterior. No se de donde lo saque
retrieve_docs(c(2011:2014),'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/cuadros_comparativos/','cap3cu03','.rtf',output_dir)
