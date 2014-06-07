source('hhba-laruta-lib.R')
#copie a mano los archivos obtenidos al csv 'onp-cua_com_jurisdiccion.csv'

#normalizar datos
data<-read.csv2(paste(home_data,'onp-cua_com_jurisdiccion.csv',sep=''),dec=",",stringsAsFactors=FALSE)

data_normalizada<-get_presupuesto_normalizado(data[data$anio>2002,])
data_normalizada_ok<-agregar_enriquecer(data_normalizada)
data_procesada<-agregar_indicadores(data_normalizada_ok)

data_normalizada_ok[c(1:10),]


#write.csv(data_normalizada_ok[data_normalizada_ok$juris_ok=='Servicio de la Deuda Pública',],paste(home_data,'onp-presupuesto_procesado_deuda.csv',sep=''))


#treemap
names(data_normalizada_ok)
make_treemap_por_anio(data_normalizada_ok)

write.csv(data_normalizada_ok,paste(home_data,'onp-presupuesto_procesado.csv',sep=''))

data_normalizada_ok_openspending$identificador<-rownames(data_normalizada_ok)
write.csv(data_normalizada_ok[,-which(names(data_normalizada_ok)=='juris_ok')],paste(home_data,'onp-presupuesto_procesado_openspending.csv',sep=''))



write.csv(data_normalizada_ok,paste(home_data,'onp-presupuesto_procesado_desnorm.csv',sep=''))



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



