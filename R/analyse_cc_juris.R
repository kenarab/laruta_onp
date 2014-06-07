source('hhba-laruta-lib.R')
#copie a mano los archivos obtenidos al csv 'onp-cua_com_jurisdiccion.csv'

#normalizar datos
data<-read.csv2(paste(home_data,'onp-cua_com_jurisdiccion.csv',sep=''),dec=",",stringsAsFactors=FALSE)

data_normalizada<-get_presupuesto_normalizado(data)
aggregate(data_normalizada$value,by=list(data_normalizada$type,data_normalizada$anio),FUN=sum)

data_normalizada[grep('Ministerio de Planificación Federal',data_normalizada$jurisdiccion),]



data_normalizada<-data_normalizada[order(data_normalizada$anio,data_normalizada$jurisdiccion,data_normalizada$type),]

data_normalizada<-ajustar_juris(data_normalizada)

data_normalizada_value<-aggregate(value~categoria+juris_ok+juris_abrev+anio+type,data_normalizada,FUN=sum)
data_normalizada_share<-aggregate(share~categoria+juris_ok+juris_abrev+anio+type,data_normalizada,FUN=sum)
data_normalizada_ok<-cbind(data_normalizada_value,data_normalizada_share)

#verifico que no hay jurisdicciones sin corregir
data_normalizada[nchar(data_normalizada$juris_ok)==0,]
#elimino columnas repetidas
data_normalizada_ok<-data_normalizada_ok[,c(1:6,12)]
data_normalizada_ok<-data_normalizada_ok[order(data_normalizada_ok$anio,data_normalizada_ok$juris_ok,data_normalizada_ok$type),]
names(data_normalizada_ok)

#write.csv(data_normalizada_ok[data_normalizada_ok$juris_ok=='Servicio de la Deuda Pública',],paste(home_data,'onp-presupuesto_procesado_deuda.csv',sep=''))


#treemap
names(data_normalizada_ok)
make_treemap_por_anio(data_normalizada_ok)

write.csv(data_normalizada_ok,paste(home_data,'onp-presupuesto_procesado.csv',sep=''))



#TODO 
  
tab_share<-xtabs(share~juris_ok+type+anio,data_normalizada_ok[data_normalizada_ok$value])

write.csv2(tab_share,file="~/Dropbox/hhba-laruta/tab_share.csv")

tab_value<-xtabs(value~juris_ok+type+anio,data_normalizada_ok)

names(mdata)


#paquete tabular
data<-ajustar_juris(data)
names(data)
mdata <- melt(data,id=c("anio","juris_ok"))
names(mdata)


