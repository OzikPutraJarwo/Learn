library(metan)
library(dplyr)
library(factoextra)
library(readxl)

Data_path_new <- read_excel("./R/archive/Karat Daun/DATA MENTAH.xlsx", 
  col_types = c("text", "numeric"),
  sheet = "Dendrogram"
  )

Data_z <- scale(x = Data_path_new [ ,2])
Data_dist <- dist(x = Data_z, method = "euclidean")
Data_A <- hclust(d = Data_dist, method = "average")
Dendogram <-fviz_dend(Data_A, cex = 0.5, main = "Cluster Dendrogram Average Linkage")
Dendogram                  
Data_A$labels <- Data_path_new$Genotipe
fviz_dend(Data_A, k = 3, show_labels = TRUE, k_colors = c("#d7191c", "#2b83ba", "#1a9641"), color_labels_by_k = FALSE, rect = T, main = "")