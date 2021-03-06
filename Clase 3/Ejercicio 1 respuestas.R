#################################
### Respuestas Guia Ejercicios 1
### 31/08/2018
#################################

library(wbstats)
library(Hmisc)
library(car)

# 1) Bajar datos del banco mundial u otro organismo relevante para sus tema de investigaci�n

mydf <-  wb(indicator = c("SP.POP.TOTL",
                          "SP.DYN.LE00.IN",
                          "SP.DYN.TFRT.IN",
                          "EN.ATM.CO2E.PC"), 
            startdate = 1990, enddate = 2010)



# 2) Transformar los datos en un data.frame que se pueda utilizar para hacer an�lisis estad�sticos

countries <- wbcountries()

### Identificar a los pa�ses
countries<-countries[,c("iso3c", "region")]

### Merge ambas DF
mydf<-merge(mydf, countries, by="iso3c")


# Eliminar datos agregados
mydf <- mydf[!mydf$region %in% "Aggregates", ]
# Reshape data into a wide format


wdf <- reshape(
  mydf[, c(
    "country", "region", "date", "value", "indicator")], 
  v.names = "value", 
  idvar=c("date", "country", "region"), 
  timevar="indicator", direction = "wide")

names(wdf)<-c("country", "region", "date", "totpop", "lifeexpect", "fertility", "co2")

# 3) Separar los datos en dos poblaciones de inter�s (te�ricamente)

table(wdf$region)

wdf$diffinterest<-ifelse(wdf$region=="Latin America & Caribbean ", 1, 0)
table(wdf$region, wdf$diffinterest)


wdf$dummy<-0
wdf$dummy[wdf$region=="Latin America & Caribbean "]<-1
table(wdf$diffinterest, wdf$dummy)


# 4a) Hacer una prueba de t de una sola muestra

# t-test # hyp: La mitad de la poblaci�n miente 
# One sample t test
t.test(wdf$lifeexpect, mu=50) 

t.test(wdf$lifeexpect[wdf$region=="Sub-Saharan Africa "], mu=53.7) 






# 4b) Hacer una prueba de t de dos muestras (para eso separar los datos en dos grupos que sean te�ricamente razonables)

# T-est de dos grupos, donde y es num�rico y x es binario
t.test(lifeexpect ~ dummy, data = wdf)

# Paired t test

a2000<-wdf$lifeexpect[wdf$date==2000]
a2005<-wdf$lifeexpect[wdf$date==2005]

mean(a2000, na.rm=T) # Con dado real
mean(a2005, na.rm=T) # Con dado digital
t.test(a2000, a2005, paired = TRUE) 


##### Otra prueba
# Chi-square Test

wdf$mtemprano<-ifelse(wdf$lifeexpect < 75, 1, 0)

chisq.test(wdf$mtemprano, wdf$region) # variables categ�ricas
chisq.test(wdf$mtemprano, wdf$dummy) # variables categ�ricas

mean(wdf$mtemprano, na.rm=T)
mean(wdf$mtemprano[wdf$dummy==1], na.rm=T)


table(wdf$mtemprano, wdf$dummy)
summary(table(wdf$mtemprano, wdf$dummy)) #Chisq


table(wdf$mtemprano, wdf$region)
summary(table(wdf$mtemprano, wdf$region)) #Chisq


# 5a) Calcular la covarianza entre dos variables de inter�s del DF que generaron

cov(wdf$lifeexpect, wdf$co2, use = "complete.obs")

# 5b) Interpretar los resultados

### Hay una covariance positiva, donde pa�ses con m�s emiciones son tb los pa�ses con mayor expectativa de vida
### �Por qu�? Tal vez porque los pa�ses m�s desarrollados tienen mayor producci�n de CO2 (USA por ejemplo) y 
### tb tiene expextativas de vida altos

# 6a) Calcular la correlaci�n entre dos variables de inter�s del DF que generaron

cor(wdf$lifeexpect, wdf$co2, use = "complete.obs")
cor.test(wdf$lifeexpect, wdf$co2, use = "complete.obs") 

rcorr(wdf$lifeexpect, wdf$co2) 


scatterplot( co2 ~  lifeexpect, data = wdf, ylab="Expectativa de Vida", xlab="Emisiones CO2", col=carPalette()
             , regLine=list(method=lm, lty=1, lwd=2, col="Red"))


scatterplot( co2 ~  lifeexpect | region, data = wdf, ylab="Expectativa de Vida", xlab="Emisiones CO2", col=carPalette()
           , regLine=list(method=lm, lty=1, lwd=2, col="Red", by.groups=T))



# 6b) Interpretar los resultados


