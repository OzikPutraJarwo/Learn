# Instalasi library (jika belum diinstal)
# install.packages("readxl")
# install.packages("dplyr")

# Memuat library yang dibutuhkan
library(readxl)
library(dplyr)

# Membaca data dari file Excel
data <- read_excel("./assets/PCA_LoadingFactor.xlsx")

# Melihat data yang telah diimpor
# print(data)

# Memeriksa struktur data untuk melihat tipe kolom
str(data)

# Mengonversi semua kolom kecuali 'Genotipe' menjadi numerik
numeric_data <- data %>% select(-Genotipe) %>% mutate(across(everything(), as.numeric))

# Memeriksa jika ada NA yang muncul setelah konversi
# print(sapply(numeric_data, function(x) sum(is.na(x))))

# Menghapus baris dengan NA (jika ada)
numeric_data <- numeric_data %>% na.omit()

# Standarisasi data
data_std <- scale(numeric_data)

# Inisialisasi PCA
pca <- prcomp(data_std, scale = TRUE)

# Menyusun hasil
eigenvalues <- pca$sdev^2
explained_variance_ratio <- eigenvalues / sum(eigenvalues)
cumulative_variance_ratio <- cumsum(explained_variance_ratio)

# Tabel hasil
results <- data.frame(
    Component = paste0("PC", 1:length(eigenvalues)),
    Eigenvalue = eigenvalues,
    Variance_Percent = explained_variance_ratio * 100,
    Cumulative_Variance_Percent = cumulative_variance_ratio * 100
)

# Menampilkan hasil
print(results)

# Melihat loadings (kontribusi variabel pada komponen utama)
loadings <- pca$rotation

# Menampilkan semua loadings
print(loadings)

# Memfilter PC dengan eigenvalues lebih dari 1
significant_pcs <- results$Component[results$Eigenvalue > 1]
filtered_loadings <- loadings[, significant_pcs]

# Menampilkan loadings yang difilter
print("Loadings")
print(filtered_loadings)