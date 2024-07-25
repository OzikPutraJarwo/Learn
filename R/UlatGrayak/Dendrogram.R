library(metan)
library(dplyr)
library(factoextra)
library(readxl)

# Baca data
Data_path_new <- read_excel("E:/Blog/Learn/R/UlatGrayak/Pilihan.xlsx", 
  col_types = c("text", "numeric"))

# Tambahkan kolom klasterisasi berdasarkan aturan tertentu
Data_path_new <- Data_path_new %>%
  mutate(Cluster = case_when(
    Data_path_new[[2]] >= 14 & Data_path_new[[2]] <= 16 ~ "Cluster 1",
    Data_path_new[[2]] > 16 & Data_path_new[[2]] <= 27.09 ~ "Cluster 2",
    Data_path_new[[2]] > 27.09 & Data_path_new[[2]] <= 34 ~ "Cluster 3",
    Data_path_new[[2]] >= 35 & Data_path_new[[2]] <= 50 ~ "Cluster 4",
    TRUE ~ "Other"
  ))

# Hanya ambil data yang termasuk dalam cluster 1 hingga 4
Data_path_new <- Data_path_new %>% filter(Cluster != "Other")

# Visualisasi klasterisasi manual
plot(Data_path_new[[2]], col = as.factor(Data_path_new$Cluster),
     pch = 19, xlab = "Genotipe", ylab = "Nilai", main = "Manual Clustering")
legend("topright", legend = unique(Data_path_new$Cluster), col = unique(as.factor(Data_path_new$Cluster)), pch = 19)

# Skala data untuk dendrogram
Data_z <- scale(x = Data_path_new[, 2])

# Hitung jarak
Data_dist <- dist(x = Data_z, method = "euclidean")

# Buat hierarchical clustering
Data_A <- hclust(d = Data_dist, method = "average")

# Visualisasi dendrogram
Dendogram <- fviz_dend(Data_A, cex = 0.5, main = "Cluster Dendrogram Average Linkage")
print(Dendogram)

# Tambahkan label klaster ke hasil clustering
Data_A$labels <- Data_path_new$Genotipe

# Warna untuk klaster yang ditentukan
cluster_colors <- c(
  "Cluster 1" = "#d7191c", 
  "Cluster 2" = "#2b83ba", 
  "Cluster 3" = "#1a9641",
  "Cluster 4" = "#fdae61")

# Visualisasi dendrogram dengan warna klaster yang ditentukan
fviz_dend(Data_A, k = 4, show_labels = TRUE, 
          k_colors = cluster_colors[as.factor(Data_path_new$Cluster)],
          color_labels_by_k = FALSE, rect = TRUE, main = "")
