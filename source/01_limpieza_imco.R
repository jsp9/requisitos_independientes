rm(list = ls())
setwd("~/git/requisitos_independientes/source")

library(readxl)
library(httr)
packageVersion("readxl")
url1<-'http://imco.org.mx/wp-content/uploads/2017/06/IL-2017-Base-de-datos.xlsx'
GET(url1, write_disk(tf <- tempfile(fileext = ".xlsx")))

data<-read_excel(tf, skip = 3)

data<-data[!is.na(data[,1]),]
data<-data[,names(data)!='Descripción']

names(data)[names(data) %in%  c('X__1', 'X__2')]<-c('cve_ent', 'ent')

 dict<-c('cve_ent',
         'ent',
   "Número de habitantes en la entidad federativa en 2017",
   "Número de ciudadanos registrados ante el INE al 24 de marzo de 2017",
   "Número de ciudadanos registrados ante el INE que cuentan con credencia para votar al 24 de marzo de 2017",
   "Término del periodo durante el cual funciona el Congreso local",
   "Número de seguidores del congreso en twitter",
   "Número de seguidores del congreso en facebook",
   "Número de diputados de acuerdo a las constituciones locales al 24 de marzo de 2017",
   "Número de diputados electos por el principio de mayoría relativa",
   "Número de diputados electos por el principio de representación propocional",
   "Número de partidos políticos (nacionales y locales) con representación en el Congreso local",
   "Partido político con el mayor número diputados en el Congreso local",
   "Porcentaje de diputados del partido mayoritario respecto del total de diputados del Congreso local",
   "\"Mayoría simple\" si un partido polìtico cuenta con la mitad más uno de los diputados locales; \"Mayoría calificada\" si un partido cuenta con dos terceras partes de los diputados locales; \"Dividido\" en otro caso",
   "Número de votos exigidos para reformar la constitución local",
   "Número de diputados del PRI",
   "Número de diputados del PAN",
   "Número de diputados del PRD",
   "Número de diputados del PVEM",
   "Número de diputados de MORENA",
   "Número de diputados de MC",                                                                                     
   "Número de diputados de NA",
   "Número de diputados del PT",
   "Número de diputados del PES",
   "Número de diputados de partidos locales",
   "Número de diputados independientes",
   "Número máximo de años consecutivos como diputado local",
   "Número de representantes del género masculino",
   "Número de representantes del género femenino",
   "Presupuesto aprobado del Congreso en el ejercicio fiscal 2012",
   "Presupuesto aprobado del Congreso en el ejercicio fiscal 2013",
   "Presupuesto aprobado del Congreso en el ejercicio fiscal 2014",
   "Presupuesto aprobado del Congreso en el ejercicio fiscal 2015",
   "Presupuesto aprobado del Congreso en el ejercicio fiscal 2016",
   "Presupuesto aprobado del Congreso en el ejercicio fiscal 2017",
   "Crecimiento en términos reales del presupuesto del Congreso entre 2012 y 2017",
   "Crecimiento en términos reales del presupuesto del Congreso entre 2016 y 2017",
   "Presupuesto general de egresos de la entidad federativa en el ejercicio fiscal 2017",
   "Presupuesto aprobado de la Entidad de Fiscalización Superior local en el ejercicio fiscal 2017",        
   "Iniciativas de ley presentadas por diputados y grupos parlamentarios en 2016",                                        "Iniciativas de ley presentadas por el Poder Ejecutivo en 2016",                                                    "Iniciativas de ley presentadas por ciudadanos en 2016",                                                                "Iniciativas de ley aprobadas al Poder Ejecutivo por el Congreso local en 2016",
   "Reformas constitucionales aprobadas por el Congreso local en 2016",
   "Número de solicitudes recibidas en 2016",
   "Disponibilidad del padrón de cabilderos. Por cabildero se identifica al individuo ajeno al Congreso que represente a una persona física, organismo privado o social, que realice actividades para obtener una resolución o acuerdo favorable a los intereses propios o de terceros. El padrón de cabilderos está conformado por personas físicas y morales.")
 
data<-data[, dict]

dict<-as.data.frame(dict)

dict$var<-c('cve_ent', 'ent','hab', 'padron', 'ln', 'fecha_limite_congreso', 'seguidores_tw', 'seguidores_fb',
            'n_dip', 'n_dip_mr', 'n_dip_rp', 'n_part', 'part_mayoritario', 'sh_part_mayoritario',
            'status_congreso', 'votos_reformas', 'dip_pri', 'dip_pan', 'dip_prd', 'dip_pvem',
            'dip_morena', 'dip_mc', 'dip_na', 'dip_pt', 'dip_pes', 'dip_partloc', 'dip_indep',
            'duracion_dips', 'diputados', 'diputadas', paste('presupuesto', 2012:2017, sep='_'),
            'crecimiento_pres_12_17', 'crecimiento_pres_16_17', 'pes_2017', 'presupuesto_fiscalia_17',
            'iniciativas_dips_2016', 'iniciativas_gober_16', 'iniciativas_ciudadanas_16',
            'iniciativas_aprobadas_gober_16', 'reformas_aprobadas_16', 'solicitudes_16', 'existe_padron_cabilderos')
setwd("~/git/requisitos_independientes/data")
write.csv(dict, 'diccionario_datos.csv', row.names = F)

names(data)<-dict$var

str(data)

numericas<-c('hab', 'padron', 'ln', 'seguidores_tw', 'seguidores_fb', 'n_dip',
             'n_dip_mr', 'n_dip_rp',
             'n_part', 'sh_part_mayoritario', 'dip_pri', 'dip_pan', 'dip_prd', 'dip_pvem',
             'dip_morena', 'dip_mc', 'dip_na', 'dip_pt', 'dip_pes', 'dip_partloc', 'dip_indep',
             'duracion_dips', 'diputados', 'diputadas', paste('presupuesto', 2012:2017, sep='_'),
             'crecimiento_pres_12_17', 'crecimiento_pres_16_17', 'pes_2017', 'presupuesto_fiscalia_17',
             'iniciativas_dips_2016', 'iniciativas_gober_16', 'iniciativas_ciudadanas_16',
             'iniciativas_aprobadas_gober_16', 'reformas_aprobadas_16', 'solicitudes_16')
data<-as.data.frame(data)
for (i in numericas){
print(i)
data[data[,i] %in% c('NA', 'ND', 'sin respuesta-no disponible','sin respuesta-no dispobile', 'sin respuesta'), i]<-NA 
data[,i]<-gsub(pattern = 'K', replacement = '00', data[,i])
data[,i]<-gsub(pattern = ',', replacement = '', data[,i])
data[,i]<-as.numeric(data[,i])
}

write.csv(data, 'base_imco_limpia.csv')

