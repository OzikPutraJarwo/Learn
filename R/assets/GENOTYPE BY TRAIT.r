# Memuat paket yang diperlukan
# install.packages("ggbiplot")
# install.packages("factoextra")
library(ggbiplot)
library(factoextra)

# Membaca data dari file Excel
library(readxl)
file_path <- "./assets/PCA_LoadingFactor.xlsx"
data <- read_excel(file_path)

# Menyiapkan data untuk PCA
# Mengabaikan kolom 'Genotype' karena itu adalah label
data_pca <- data[,-1]

# Melakukan PCA
pca <- prcomp(data_pca, scale. = TRUE)

# Membuat biplot
ggbiplot(pca, obs.scale = 1, var.scale = 1, 
         groups = data$Genotype, ellipse = TRUE, 
         circle = TRUE) +
  theme_minimal() +
  labs(title = "Biplot PCA",
       x = "PC1",
       y = "PC2") +
  theme(legend.position = "right")