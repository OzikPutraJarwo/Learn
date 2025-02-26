library(metan)
library(dplyr)
library(factoextra)
library(readxl)

# Membaca data
Data_path_new <- read_excel("./archive/Karat Daun/DATA MENTAH.xlsx", 
                             col_types = c("text", "numeric", "numeric"),
                             sheet = "Dendrogram"
)

# Melakukan skala data
Data_z <- scale(x = Data_path_new[, 3])
Data_dist <- dist(x = Data_z, method = "euclidean")
Data_A <- hclust(d = Data_dist, method = "average")

# Menambahkan label Genotipe ke objek hclust
names(Data_A$labels) <- Data_path_new$Genotipe  # Pastikan label diterapkan

# Menggambar dendrogram menggunakan plot
plot(Data_A, labels = Data_path_new$Genotipe, main = "Dendrogram dengan Genotipe", xlab = "Genotipe", sub = "", hang = -1)