source('hhba-laruta-lib.R')
#copie a mano los archivos obtenidos al csv 'onp-cua_com_jurisdiccion.csv'

#normalizar datos
data<-read.csv2(paste(home_data,'onp-cua_com_jurisdiccion.csv',sep=''),dec=",",stringsAsFactors=FALSE)
data_normalizada<-get_presupuesto_normalizado(data)

data_normalizada<-data_normalizada[order(data_normalizada$anio,data_normalizada$jurisdiccion,data_normalizada$type),]

data_normalizada<-ajustar_juris(data_normalizada)

names(data_normalizada)
data_normalizada_value<-aggregate(value~categoria+juris_ok+anio+type,data_normalizada,FUN=sum)
data_normalizada_share<-aggregate(share~categoria+juris_ok+anio+type,data_normalizada,FUN=sum)
data_normalizada_ok<-cbind(data_normalizada_value,data_normalizada_share)


data_normalizada_ok[data_normalizada_ok$juris_ok=='Servicio de la Deuda Pública',]

#elimino columnas repetidas
data_normalizada_ok<-data_normalizada_ok[,c(1:5,10)]
data_normalizada_ok<-data_normalizada_ok[order(data_normalizada_ok$anio,data_normalizada_ok$juris_ok,data_normalizada_ok$type),]
names(data_normalizada_ok)


#write.csv(data_normalizada_ok[data_normalizada_ok$juris_ok=='Servicio de la Deuda Pública',],paste(home_data,'onp-presupuesto_procesado_deuda.csv',sep=''))

write.csv(data_normalizada_ok,paste(home_data,'onp-presupuesto_procesado.csv',sep=''))

#treemap
make_treemap_por_anio(data_normalizada_ok)


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



