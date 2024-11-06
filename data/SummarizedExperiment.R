# Instalamos y cargamos las bibliotecas 
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("SummarizedExperiment")
BiocManager::install("readr")

library(SummarizedExperiment)
library(readr)


# 1.Cargamos los datos y metadatos

# Metadatos de las características (features)
# Si exploramos el archivo csv vemos que hay 46 columnas, la última de ellas no tiene encabezado, puesto que en la descripción se explica que deberían ser 45 importaremos solo las 45 primeras
metadata_features <- read_csv2("C:/Users/pferr/Ferrero-Capilla-Paola-PEC1/datos descargados/features.csv",col_names = TRUE)
# Cargamos el csv de manera alternativa
metadata_features1 <- read.csv2("C:/Users/pferr/Ferrero-Capilla-Paola-PEC1/datos descargados/features.csv", header = F, sep = ";", quote = "\"", stringsAsFactors = FALSE)
# Como la última columna no tiene encabezado (ID) hay que eliminarla, también la primera fila porque importamos el csv sin que la tenga en cuenta como tal
metadata_features1 <- metadata_features1[ -1,-46]
# Asignamos nombre a las columnas
colnames(metadata_features1) <- colnames(metadata_features)
# Comprobamos que se ha cargado correctamente mostrando las primeras filas
head(metadata_features1)
# Comprobamos que las dimensiones son correctas
dim(metadata_features1)
# Comprobamos la clase de las columnas
str(metadata_features1)
# Puesto que las interpreta como strings en lugar de como numeric, convertimos los valores 
# Aplicamos la conversión a todas las columnas
metadata_features1 <- metadata_features1 %>%
  mutate_if(is.character, as.numeric)
# Comprobamos el resultado
str(metadata_features1)


# Metadatos de las muestras (metadata)
metadata_samples <- read.csv2("C:/Users/pferr/Ferrero-Capilla-Paola-PEC1/datos descargados/metadata.csv", header = TRUE, sep = ";", quote = "\"", stringsAsFactors = FALSE)
# Comprobamos que se ha cargado correctamente mostrando las primeras filas
head(metadata_samples)
# Comprobamos que las dimensiones son correctas
dim(metadata_samples)

# Datos de los metabolitos (metaboliteNames)
metabolite_names <- read.csv2("C:/Users/pferr/Ferrero-Capilla-Paola-PEC1/datos descargados/metaboliteNames.csv",header = TRUE, sep = ";", quote = "\"", stringsAsFactors = FALSE)
# Comprobamos que se ha cargado correctamente mostrando las primeras filas
head(metabolite_names)
# Comprobamos que las dimensiones son correctas
dim(metabolite_names)


# 2.Creamos el objeto SummarizedExperiment

# Paso previo, las filas de colData tienen que tener el mismo nombre que las columnas del assay
rownames(metadata_samples) <- colnames(metadata_features1)

# Creamos el contenedor
se <- SummarizedExperiment(
  assays = list(metabolites = as.matrix(metadata_features1)), # Los datos cuantitativos ómicos corresponden al slot de assays
  colData = metadata_samples, # La información de las muestras (covariables), cada fila corresponde a una columna de los datos de expresión
  rowData = metabolite_names # La información sobre los nombres de los metabolitos e ID de PubChem y KEGG
)

# Añadimos información del experimento
metadata(se)$description <- "ST000291: LC-MS Based Approaches to Investigate Metabolomic Differences in the Urine of Young Women after Drinking Cranberry Juice or Apple Juice" 
metadata(se)$source <- "https://github.com/nutrimetabolomics/metaboData/tree/main/Datasets/2024-fobitools-UseCase_1, This is data downlaoded from the metabolomics Workbench repository where it is stored with ID: ST000291"

# Mostramos el contenedor
se

# Exploramos el objeto 
# Dimensiones del dataset
dim(se)

# Resumen
summary(assay(se))

# Primeros registros
head(assay(se))

# Información sobre las muestras
colData(se)

# Metadatos del experimento
metadata(se)



