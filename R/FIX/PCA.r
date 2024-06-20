library(readxl)
Data_path_new <- read_excel("E:/Blog/Learn/R/assets/Data Total.xlsx", 
  col_types = c("text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

library(factoextra)
res.pca <- prcomp(x= Data_path_new[ ,3:26], scale = TRUE)
res.pca

pca <- fviz_pca_biplot(res.pca, 
                      axes = c(1,2), 
                      repel = TRUE, # Label tidak bertabrakan
                      label = "all", 
                    # title = "Hubungan Genotipe dengan Var. Pertumbuhan",
                      geom.ind = c("point"), 
                      geom.var = c("arrow","text"),
                      habillage = Data_path_new$Genotipe,
                      col.var = "#762a83",
                      col.ind = c("#67a9cf","#d73027", "#1b7837"),
                    # addEllipses = TRUE, # Kotak di legend
                    # xlab = "PC1", # X axes title
                    # ylab = "PC2", # Y axes title
                      ) 
pca