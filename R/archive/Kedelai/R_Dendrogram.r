library(metan)
library(dplyr)
library(factoextra)
library(readxl)

Data_path_new <- read_excel("./Kedelai/Data Total Lengkap.xlsx", 
  col_types = c("text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

Data_z <- scale(x = Data_path_new [ ,2:20])
Data_dist <- dist(x = Data_z, method = "euclidean")
Data_A <- hclust(d = Data_dist, method = "average")
Dendogram <-fviz_dend(Data_A, cex = 0.5, main = "Cluster Dendrogram Average Linkage")
Dendogram                  
Data_A$labels <- Data_path_new$Genotipe
fviz_dend(Data_A, k = 6, show_labels = TRUE, k_colors = c("#d7191c", "#2b83ba", "#1a9641", "#fdae61", "#960f8b", "#8d5307"),color_labels_by_k = FALSE, rect = T, main = "")