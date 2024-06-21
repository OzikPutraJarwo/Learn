library(readxl)
Data_path_new <- read_excel("R/assets/Data Total No R.xlsx", 
  col_types = c("text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

library(factoextra)

# Lakukan PCA dengan data yang benar
res.pca <- prcomp(Data_path_new[, -which(names(Data_path_new) %in% c("Genotipe"))], scale. = TRUE)

# Plot biplot dengan fviz_pca_biplot
pca <- fviz_pca_biplot(res.pca, 
                      axes = c(1,2), 
                      repel = TRUE, # Label tidak bertabrakan
                      label = "all", 
                      geom.ind = c("arrow"), 
                      col.ind = c("#67a9cf","#d73027", "#1b7837"),
                      # Variable
                      geom.var = c("text"),
                      col.var = "#851b85",
                      habillage = Data_path_new$Genotipe,
                      # xlab = "PC1 (42.1%)",
                      # ylab = "PC2 (22.9%)"
                      ) +
       geom_text(aes(label = Data_path_new$Genotipe), vjust = -1)

print(pca)