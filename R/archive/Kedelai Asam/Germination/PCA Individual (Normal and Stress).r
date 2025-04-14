packages <- c("tidyverse", "factoextra", "readxl", "ggplot2", "ggrepel")
lapply(packages, function(pkg) {
  if (!require(pkg, character.only = TRUE)) install.packages(pkg)
})

library(tidyverse)
library(factoextra)
library(readxl)
library(ggplot2)
library(ggrepel)

# ⿡ Load dataset dari sheet Normal (Control)
file_path <- "R/archive/Kedelai Asam/Germination/Dataset for PCA.xlsx"  # Sesuaikan dengan nama file Anda
df_normal <- read_excel(file_path, sheet = 1)
# df_normal <- read_excel(file_path, sheet = 2)

# ⿢ Bersihkan nama kolom agar seragam (menghapus "_Normal")
colnames(df_normal) <- gsub("_Normal", "", colnames(df_normal))
# colnames(df_normal) <- gsub("_Stress", "", colnames(df_normal))

# ⿣ Simpan kolom Genotype untuk digunakan sebagai label
genotype_labels <- df_normal$Genotype

# ⿤ Hapus kolom kategori (Genotype) karena PCA hanya menerima numerik
df_numeric_normal <- df_normal %>% select(-Genotype)

# ⿥ Jalankan PCA untuk kondisi Control
pca_normal <- prcomp(df_numeric_normal, center = TRUE, scale. = TRUE)

# ⿦ Konversi hasil PCA ke DataFrame untuk ditambahkan label
pca_scores <- as.data.frame(pca_normal$x)
pca_scores$Genotype <- genotype_labels  # Menambahkan nama Genotype

# ⿧ Buat PCA Biplot Manual dengan ggplot() agar fleksibel
pca_plot_normal <- ggplot(pca_scores, aes(x = PC1, y = PC2)) +
  geom_point(color = "black") +  # Titik individu hitam
  geom_text_repel(aes(label = Genotype), size = 4, color = "black", max.overlaps = Inf) +  # Label Genotype
  labs(title = "Individuals - Control", x = paste0("PC1 (", round(summary(pca_normal)$importance[2,1] * 100, 1), "%)"),
       y = paste0("PC2 (", round(summary(pca_normal)$importance[2,2] * 100, 1), "%)")) +
  theme_minimal()

# ⿨ Tambahkan Vektor Variabel ke PCA Plot
pca_var <- as.data.frame(pca_normal$rotation)  # Ambil loading variabel
pca_var$Variable <- rownames(pca_var)  # Tambahkan label variabel

pca_plot_normal <- pca_plot_normal +
  geom_segment(data = pca_var, aes(x = 0, y = 0, xend = PC1 * 3, yend = PC2 * 3), 
               arrow = arrow(length = unit(0.2, "cm")), color = "steelblue") +  # Vektor variabel
  geom_text_repel(data = pca_var, aes(x = PC1 * 3, y = PC2 * 3, label = Variable),
                  color = "steelblue", size = 4, max.overlaps = Inf)  # Label variabel

# ⿩ Tampilkan plot untuk kondisi Control dengan Label
print(pca_plot_normal)