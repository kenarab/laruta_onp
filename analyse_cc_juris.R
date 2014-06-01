data<-read.csv(paste(home_data,'onp-cua_com_jurisdiccion.csv',sep=''),stringsAsFactors=FALSE)
data_normalizada<-data.frame(anio=numeric(),type=character(),jurisdiccion=character(),value=numeric(),share=numeric(),stringsAsFactors=FALSE)
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
        i<-i+1
      }
    }
  }
}
warnings()
data_normalizada<-data_normalizada[order(data_normalizada$anio,-data_normalizada$type),]

data_normalizada[data_normalizada$jurisdiccion=='Obligaciones a Cargo del Tesoro',]
xtabs(share~jurisdiccion+type+anio,data_normalizada)
