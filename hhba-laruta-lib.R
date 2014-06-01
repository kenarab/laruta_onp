pkgTest <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}

pkgTest("scrapeR")
pkgTest("RCurl")
pkgTest("tables")

corregir_juris<-function(data,juris,juris_ok){
  for (j in juris){
    data[data$jurisdiccion== j,]$juris_ok<-juris_ok
  }
  data
}
ministerios_unicos<-c("Poder Legislativo Nacional","Poder Judicial de la Nación","Ministerio Público","Presidencia de la Nación",
                          "Jefatura de Gabinete de Ministros","Ministerio de Defensa","Ministerio de Trabajo, Empleo y Seguridad Social",
                         "Ministerio de Desarrollo Social","Servicio de la Deuda Pública","Obligaciones a Cargo del Tesoro","Ministerio de Ciencia, Tecnología e Innovación Productiva",
                         "Ministerio de Planificación Federal, Inversión Pública y Servicios")


ajustar_juris<-function(data){
  data$juris_ok<-""
  for (j in ministerios_unicos ){
  data<-corregir_juris(data,j,j)
  }
  data<-corregir_juris(data,c("Ministerio del Interior","Ministerio del Interior y Transporte")
                           ,"Ministerio del Interior")
  data<-corregir_juris(data,c("Ministerio de Salud","Ministerio de Salud y Ambiente")
                       ,"Ministerio de Salud")
  data<-corregir_juris(data,c("TOTAL","TOTAL GASTOS CORRIENTES Y DE CAPITAL ")
                       ,"TOTAL GASTOS CORRIENTES Y DE CAPITAL ")
  data<-corregir_juris(data,c("Ministerio de Justicia, Seguridad  y Derechos Humanos","Ministerio de Justicia  y Derechos Humanos","Ministerio de Justicia y Derechos Humanos","Ministerio de Seguridad")
                       ,"Ministerio de Justicia, Seguridad  y Derechos Humanos")
  data<-corregir_juris(data,c("Ministerio de Relaciones Exteriores y Culto","Ministerio de Relaciones Exteriores, Comercio Internacional y Culto","Ministerio de Relac. Exteriores, Comercio Internac. y Culto")
                       ,"Ministerio de Relaciones Exteriores y Culto")
  data<-corregir_juris(data,c("Ministerio de Educación","Ministerio de Educación, Ciencia y Tecnología")                      
                       ,"Ministerio de Educación")
  data<-corregir_juris(data,c("Ministerio de Educación","Ministerio de Educación, Ciencia y Tecnología")                      
                       ,"Ministerio de Educación")
  data<-corregir_juris(data,c("Ministerio de Economía","Ministerio de Economía y Producción","Ministerio de Economía y Finanzas Públicas",
                              "Ministerio de Producción","Ministerio de Industria","Ministerio de Agricultura, Ganadería y Pesca","Ministerio de Turismo",
                              "Ministerio de la Producción")
                       ,"Ministerio de Economía")
  
}









unique(data_normalizada$jurisdiccion)
