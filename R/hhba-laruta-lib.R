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

trim<-function(s) gsub("^[[:space:]]+|[[:space:]]+$","",s)

corregir_juris<-function(data,juris,juris_abrev,categoria){
  juris<-trim(juris)
  juris_ok<-juris[1]
  print(paste('corrigiendo',juris_ok))
  j<-juris[2]
  for (j in juris){
    j_trimed<-trim(data$jurisdiccion)
    corregir<-grep(j,j_trimed)
    if (length(corregir)>0){
      data[corregir,]$juris_ok<-juris_ok
      data[corregir,]$juris_abrev<-juris_abrev
      data[corregir,]$categoria<-categoria
    }
  }
  data
}
organismos_unicos<-data.frame(organismo=character(),organismo_abrev=character(),categoria=character(),stringsAsFactors=FALSE)


agregar_organismo_unico<-function(juris,juris_abrev,categoria){
  organismos_unicos[nrow(organismos_unicos)+1,]<<-c(juris,juris_abrev,categoria)
}


agregar_organismo_unico("Poder Legislativo Nacional","Poder Legislativo","Institucional")
agregar_organismo_unico("Poder Judicial de la Nación","Poder Judicial","Institucional")
agregar_organismo_unico("Ministerio Público","Ministerio Público","Institucional")
agregar_organismo_unico("Jefatura de Gabinete de Ministros","Jefatura de Gabinete","Ejecutivo")
agregar_organismo_unico("Presidencia de la Nación","Presidencia","Ejecutivo")
agregar_organismo_unico("Ministerio de Defensa","Defensa","Exterior")
agregar_organismo_unico("Obligaciones a Cargo del Tesoro","Obligaciones a Cargo del Tesoro","Financiero")
agregar_organismo_unico("Ministerio de Ciencia, Tecnología e Innovación Productiva","Ciencia","Productivo")

ajustar_juris<-function(data){
  data$juris_ok<-""
  data$juris_abrev<-""
  data$categoria<-""
  for (j in c(1:nrow(organismos_unicos))){
    organismo_actual<-organismos_unicos[j,]
    data<-corregir_juris(data,
                         organismo_actual[,c("organismo")],
                         organismo_actual[,c("organismo_abrev")],
                         organismo_actual[,c("categoria")])
  }
  
  data<-corregir_juris(data,c("Ministerio de Desarrollo Social","Ministerio de Desarrollo Social y Medio Ambiente",
                              "Ministerio de Trabajo, Empleo y Formación de Recur. Humanos")
                       ,"Desarrollo Social","Básico")
  data<-corregir_juris(data,c("Ministerio de Trabajo, Empleo y Seguridad Social",
                              "Ministerio de Trabajo, Empleo y Formación de Recur. Humanos")
                       ,"Trabajo","Básico")
  data<-corregir_juris(data,c("Ministerio del Interior","Ministerio del Interior y Transporte")
                           ,"Interior","Interior")
  data<-corregir_juris(data,c("Ministerio de Salud","Ministerio de Salud y Ambiente")
                       ,"Salud","Básico")
  data<-corregir_juris(data,c("TOTAL","TOTAL GASTOS CORRIENTES Y DE CAPITAL ")
                       ,"TOTAL","TOTAL")
  data<-corregir_juris(data,c("ECONOMIA POR PROGRAMACIÓN DE LA EJECUCION")
                       ,"ECONOMIA POR PROGRAMACIÓN DE LA EJECUCION","TOTAL")
  data<-corregir_juris(data,c("SUBTOTAL","SUBTOTAL")
                       ,"SUBTOTAL","SUBTOTAL")
  
  data<-corregir_juris(data,c("Ministerio de Justicia, Seguridad  y Derechos Humanos","Ministerio de Justicia  y Derechos Humanos",
                              "Ministerio de Justicia y Derechos Humanos","Ministerio de Seguridad")
                       ,"Justicia, Seguridad  y Derechos Humanos","Interior")
  data<-corregir_juris(data,c("Ministerio de Relaciones Exteriores y Culto",
                              "Ministerio de Relaciones Exteriores, Comercio Internacional y Culto",
                              "Ministerio de Relac. Exteriores, Comercio Internac. y Culto",
                              "Ministerio de Relac Exteriores, Comercio Internac.y Culto")
                       ,"Cancillería","Exterior")
  data<-corregir_juris(data,c("Ministerio de Educación","Ministerio de Educación, Ciencia y Tecnología",
                              "Ministerio Educación")                      
                       ,"Educación", "Básico")
  data<-corregir_juris(data,c("Ministerio de Economía","Ministerio de Economía y Producción",
                              "Ministerio de Economía y Finanzas Públicas",
                              "Ministerio de Agricultura, Ganadería y Pesca",
                              "Ministerio de Agricultura, Ganadería y Pesca",
                              "Ministerio de Turismo")
                       ,"Economía", "Productivo")
  data<-corregir_juris(data,c("Ministerio de Planificación Federal, Inversión Pública y Servicios",
                              "Ministerio de Planificación Federal, Inversión Publica y Servicios",
                              "Ministerio de Infraestructura y Vivienda")
                        ,"Planificación","Productivo")
  data<-corregir_juris(data,c("Ministerio de Industria","Ministerio de Producción","Ministerio de Producción",
                              "Ministerio de Industria",
                              "Ministerio de la Producción")
                       ,"Industria", "Productivo")
  data<-corregir_juris(data,c("Servicio de la Deuda Pública",
                              "Servicio de la Deuda Publica"),
                        "Deuda Publica","Financiero")
  data_unmatched<-data[data$juris_ok=="",]
  if (nrow(data_unmatched)>0)
    stop(paste("Error: las filas ",paste(rownames(data_unmatched),collapse=";"), " no estan matcheadas con jurisdicciones"))
  data
}


agregar_indicadores<-function(data_normalizada_ok){
  
}

get_presupuesto_normalizado<-function(data){
  data_normalizada<-data.frame(anio=numeric(),anio_fecha=character(),type=character(),jurisdiccion=character(),
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
          data_normalizada[i,'anio_fecha']<-paste('01/01/',anio_aplicar,sep='')
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


agregar_enriquecer<-function(data_nomalizada){
  data_normalizada<-data_normalizada[order(data_normalizada$anio,data_normalizada$jurisdiccion,data_normalizada$type),]
  
  data_normalizada<-ajustar_juris(data_normalizada)
  
  data_normalizada_value<-aggregate(value~categoria+juris_ok+juris_abrev+anio+anio_fecha+type,data_normalizada,FUN=sum)
  data_normalizada_share<-aggregate(share~categoria+juris_ok+juris_abrev+anio+anio_fecha+type,data_normalizada,FUN=sum)
  
  data_normalizada_ok<-cbind(data_normalizada_value,data_normalizada_share)
  
  #elimino columnas repetidas
  data_normalizada_ok<-data_normalizada_ok[,c(1:7,14)]
  data_normalizada_ok<-data_normalizada_ok[order(data_normalizada_ok$anio,data_normalizada_ok$juris_ok,data_normalizada_ok$type),]
  data_normalizada_ok
}


make_treemap_por_anio<-function(data_normalizada_ok){
  for (anio in sort(unique(data_normalizada_ok$anio))){
    for (ty in sort(unique(data_normalizada_ok$type))){
      data_anio<-data_normalizada_ok[data_normalizada_ok$anio==anio & 
                      !data_normalizada_ok$juris_ok=="TOTAL" &
                      data_normalizada_ok$type==ty,]    
      if (nrow(data_anio)>0){
        if (ty=='PROY')
          tipo='proyectado'
        if (ty=='EJEC')
          tipo='ejecutado'
        #file_name<-paste(home_graficos,'presupuesto_treemap_',anio,'_', tipo,sep="")
        file_name<-paste(home_graficos,'presupuesto_',anio,'_', tipo,".png",sep="")
        print(paste('elaborando',file_name))
        png(file_name, height=heightPNG, width=widthPNG, bg="white")   
        #treemap(data_anio,c('categoria','juris_ok'),vSize='value',title=paste("Presupuesto Nacional",tipo, " en año",anio))
        treemap(data_anio,c('categoria','juris_abrev'),vSize='value',title=paste("Presupuesto Nacional",tipo, " en año",anio,"(por jurisdicción y categoría)","\nfuente: ONP (Ministerio de Economía)"))
        dev.off()    
      }
    }
  }
}




retrieve_docs<-function(anios,path,filename,filetype,output_dir){
  dir.create(output_dir,showWarnings=FALSE)
  for (anio in anios){
    #    path<-'http://www.mecon.gov.ar/onp/html/presutexto/ley#anio#/ley/pdf/anexo_estadistico/'
    path_aplicado<-sub('#anio#',anio,path)
    command<-paste('wget ',path_aplicado,filename,filetype,' -O ',output_dir,filename,'_',anio,filetype,sep='')
    print(command)
    if (!file.exists(paste(filename,filetype)))
      system(command)
    Sys.sleep(runif(1,0.2,1))
  }
}


