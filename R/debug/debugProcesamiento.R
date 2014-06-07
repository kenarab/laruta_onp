#debugueando 140607 Sigue andando mal.

data_normalizada_value<-aggregate(value~categoria+juris_ok+juris_abrev+anio+type,data_normalizada,FUN=sum)
data_normalizada_share<-aggregate(share~categoria+juris_ok+juris_abrev+anio+type,data_normalizada,FUN=sum)
nrow(data_normalizada_value)
nrow(data_normalizada_share)


sort(unique(data_normalizada_share$juris_ok))
sort(unique(data_normalizada_value$juris_ok))

for (i in c(1:nrow(data_normalizada_share))){
  if (data_normalizada_share[i,]$juris_ok!=data_normalizada_value[i,]$juris_ok){
    print(data_normalizada_share[i,])
    print(data_normalizada_value[i,])
    stop(paste(data_normalizada_share[i,]$juris_ok,data_normalizada_value[i,]$juris_ok))
  }
}
