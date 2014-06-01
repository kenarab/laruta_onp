
#copie a mano los archivos


#normalizar datos
data<-read.csv(paste(home_data,'onp-cua_com_jurisdiccion.csv',sep=''),stringsAsFactors=FALSE)
data_normalizada<-data.frame(anio=numeric(),type=character(),jurisdiccion=character(),
                             value=numeric(),share=numeric(),total_anio=numeric(),stringsAsFactors=FALSE)
anios<- sort(unique(data$anio))
i<-1
for (anio in anios){
  data_anio<-data[data$anio==anio,]    
  for (juris in data_anio$juris){
    for (type in c('PROY','EJEC')){
      anio_aplicar<-anio
      if (type=='PROY'){
        data_field<-'act'
        names(data)
      }
      if (type=='EJEC'){
        data_field<-'ant'
        anio_aplicar<-anio-1
      }
      total_anio<-
        sum(as.numeric(data_anio[-grep('TOTAL',data_anio$jurisdiccion),data_field]))
      log(total_anio,10)
      if (anio_aplicar>=min(anios)){
        value<-as.numeric(data_anio[data_anio$juris==juris,data_field])
        new_record<-c(as.numeric(anio_aplicar),type,juris,value)
        print(paste(new_record))
        data_normalizada[i,'anio']<-anio_aplicar
        data_normalizada[i,'type']<-type
        data_normalizada[i,'jurisdiccion']<-juris
        data_normalizada[i,'value']<-value
        data_normalizada[i,'share']<-value/total_anio
        data_normalizada[i,'total_anio']<-total_anio
        i<-i+1
      }
    }
  }
}
warnings()
data_normalizada<-data_normalizada[order(data_normalizada$anio,data_normalizada$type),]


data_normalizada<-ajustar_juris(data_normalizada)
data_normalizada_value<-aggregate(value~jurisdiccion+anio+type,data_normalizada,FUN=sum)
data_normalizada_share<-aggregate(share~jurisdiccion+anio+type,data_normalizada,FUN=sum)
data_normalizada_ok<-cbind(data_normalizada_value,data_normalizada_share)
names(data_normalizada_ok)
#elimino columnas repetidas
data_normalizada_ok<-data_normalizada_ok[,c(1:4,8)]


xtabs(share~jurisdiccion+type+anio,data_normalizada_ok)

plot(xtabs(share~type+jurisdiccion+anio,data_normalizada))
tab(share~jurisdiccion+type+anio,data_normalizada)
