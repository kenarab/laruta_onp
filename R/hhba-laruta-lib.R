source("hhba-laruta-config.R")
pkgTest <- function(x)
{
  if (!require(x,character.only = TRUE,quietly=TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
  print(paste("package loaded",x))
}

pkgTest("scrapeR")
pkgTest("RCurl")
pkgTest("reshape")
pkgTest("treemap")

corregir_juris<-function(data,juris,juris_ok,categoria){
  for (j in juris){
    data[data$jurisdiccion== j,]$juris_ok<-juris_ok
    data[data$jurisdiccion== j,]$categoria<-categoria
  }
  data
}
organismos_unicos<-data.frame(organismo=character(),categoria=character(),stringsAsFactors=FALSE)
organismos_unicos[1,]<-c("Poder Legislativo Nacional","Institucional")
organismos_unicos[2,]<-c("Poder Judicial de la Nación","Institucional")
organismos_unicos[3,]<-c("Ministerio Público","Institucional")
organismos_unicos[4,]<-c("Jefatura de Gabinete de Ministros","Ejecutivo")
organismos_unicos[5,]<-c("Presidencia de la Nación","Ejecutivo")
organismos_unicos[6,]<-c("Ministerio de Defensa","Externo")
organismos_unicos[7,]<-c("Ministerio de Trabajo, Empleo y Seguridad Social","Basico")
organismos_unicos[8,]<-c("Ministerio de Desarrollo Social","Basico")
organismos_unicos[9,]<-c("Servicio de la Deuda Pública","Financiero")
organismos_unicos[10,]<-c("Obligaciones a Cargo del Tesoro","Financiero")
organismos_unicos[11,]<-c("Ministerio de Ciencia, Tecnología e Innovación Productiva","Económico")
organismos_unicos[12,]<-c("Ministerio de Planificación Federal, Inversión Pública y Servicios","Económico")



ajustar_juris<-function(data){
  data$juris_ok<-""
  data$categoria<-""
  j<-1
  for (j in c(1:nrow(organismos_unicos))){
    organismo_actual<-organismos_unicos[j,]
    data<-corregir_juris(data,
                         organismo_actual[,c("organismo")],
                         organismo_actual[,c("organismo")],
                         organismo_actual[,c("categoria")])
  }
  data<-corregir_juris(data,c("Ministerio del Interior","Ministerio del Interior y Transporte")
                           ,"Ministerio del Interior","Interior")
  data<-corregir_juris(data,c("Ministerio de Salud","Ministerio de Salud y Ambiente")
                       ,"Ministerio de Salud","Basico")
  data<-corregir_juris(data,c("TOTAL","TOTAL GASTOS CORRIENTES Y DE CAPITAL ")
                       ,"TOTAL GASTOS CORRIENTES Y DE CAPITAL ","TOTAL")
  data<-corregir_juris(data,c("Ministerio de Justicia, Seguridad  y Derechos Humanos","Ministerio de Justicia  y Derechos Humanos","Ministerio de Justicia y Derechos Humanos","Ministerio de Seguridad")
                       ,"Ministerio de Justicia, Seguridad  y Derechos Humanos","Interior")
  data<-corregir_juris(data,c("Ministerio de Relaciones Exteriores y Culto","Ministerio de Relaciones Exteriores, Comercio Internacional y Culto","Ministerio de Relac. Exteriores, Comercio Internac. y Culto")
                       ,"Ministerio de Relaciones Exteriores y Culto","Externo")
  data<-corregir_juris(data,c("Ministerio de Educación","Ministerio de Educación, Ciencia y Tecnología")                      
                       ,"Ministerio de Educación", "Basico")
  data<-corregir_juris(data,c("Ministerio de Economía","Ministerio de Economía y Producción","Ministerio de Economía y Finanzas Públicas",
                              "Ministerio de Producción","Ministerio de Industria","Ministerio de Agricultura, Ganadería y Pesca","Ministerio de Turismo",
                              "Ministerio de la Producción")
                       ,"Ministerio de Economía", "Económico")
}



get_presupuesto_normalizado<-function(data){
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
  data_normalizada
}

make_treemap_por_anio<-function(data){
  for (anio in sort(unique(data$anio))){
    for (ty in sort(unique(data$type))){
      data_anio<-data[data$anio==anio & 
                      !data$juris_ok=="TOTAL GASTOS CORRIENTES Y DE CAPITAL " &
                      data$type==ty,]    
      if (nrow(data_anio)>0){
        if (ty=='PROY')
          tipo='proyectado'
        if (ty=='EJEC')
          tipo='ejecutado'
        file_name<-paste(home_graficos,'presupuesto_treemap_',anio,'_', tipo)
        print(paste('elaborando',file_name))
        png(file_name, height=heightPNG, width=widthPNG, bg="white")   
        treemap(data_anio,c('categoria','juris_ok'),vSize='value',title=paste("Presupuesto Nacional",tipo, " en año",anio))
        dev.off()    
      }
    }
  }
}
