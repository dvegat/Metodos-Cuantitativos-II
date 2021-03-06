#################################
### Respuestas Guia Ejercicios 1
### 31/08/2018
#################################
library(Hmisc)
library("?")

# 1) Bajar datos del banco mundial u otro organismo relevante para sus tema de investigaci�n. Pueder ser �til utilizar el paquete "wbstats" y
# la funci�n de m�s abajo o ir directamente a las p�ginas del banco mundial a buscar los datos

#Funciones que pueden ser �tiles:
mydf <-  wb(indicator = c("Algo relevante"), 
            startdate = a�o, enddate = a�o)

mydf<-merge(df1, df2, by="id")

# 2) Transformar los datos en un data.frame que se pueda utilizar para hacer an�lisis estad�sticos (pa�s, a�o, indicadores hacia el lado)
#Funciones que pueden ser �tiles:
dfw <- reshape(mydf[, list(
    country, region, date, value, indicator)], 
  v.names = "value", 
  idvar=c("date", "country", "region"), 
  timevar="indicator", direction = "wide")

# 3) Separar los datos en dos poblaciones de inter�s (te�ricamente)

df$varname<-ifelse(condicion, valor.si, valor.otro)

# 4a) Hacer una prueba de t de una sola muestra

t.test(variable, media) 

# 4b) Hacer una prueba de t de dos muestras (para eso separar los datos en dos grupos que sean te�ricamente razonables)

t.test(variable ~ dymmy, data = datos)

# 5a) Calcular la covarianza entre dos variables de inter�s del DF que generaron

cov()  # opciones use = "complete.obs" tal vez sea �til

# 5b) Interpretar los resultados


# 6a) Calcular la correlaci�n entre dos variables de inter�s del DF que generaron

cor()
cor.test()
rcorr()

# 6b) Interpretar los resultados


