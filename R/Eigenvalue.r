library(readxl)
library(dplyr)

# Read xl & standarisasi
data <- read_excel("./assets/Data Total No R.xlsx")
numeric_data <- data %>% select(-Genotipe) %>% mutate(across(everything(), as.numeric))
numeric_data <- numeric_data %>% na.omit()
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
cat("\nPrincipal Component Value\n\n")
print(results)

# Loadings
loadings <- pca$rotation # All
significant_pcs <- results$Component[results$Eigenvalue > 1]
filtered_loadings <- loadings[, significant_pcs] # Filtered
cat("\nFiltered Loadings\n\n")
print(filtered_loadings)