library(metan)

library(dplyr)
library(factoextra)

library(readxl)

Data_path_new <- read_excel("C:/Users/User/Documents/Belajar R/Data path new.xlsx", col_types = c("text", "numeric", "numeric", 
                    "numeric", "numeric", "numeric", 
                    "numeric", "numeric", "numeric"))
View(Data_path_new)
Data_z <- scale(x = Data_path_new [,2:9])
Data_dist <- dist(x = Data_z, method = "euclidean")
Data_A <- hclust(d = Data_dist, method = "average")
Dendogram <-fviz_dend(Data_A, cex = 0.5, main = "Cluster Dendrogram Average Linkage")
Dendogram                  
Data_A$labels <- Data_path_new$Genotype
fviz_dend(Data_A, k = 4, show_labels = TRUE, k_colors = c("#d7191c", "#2b83ba", "#1a9641", "#fdae61"),color_labels_by_k = FALSE, rect = T, main = "Dendogram Klasterisasi Genotipe")