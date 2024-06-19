library(readxl)

Data_path_new <- read_excel("./assets/PCA_LoadingFactor.xlsx", col_types = c("text", "numeric", "numeric", 
                    "numeric", "numeric", "numeric", 
                    "numeric", "numeric"))
# View(Data_path_new)

# Metan

library(metan)
pca <- gtb(Data_path_new, 
           "Genotype", 
           resp = c("R", "BPB", "PB", "BuT", "HB", "BiT"), 
           centering = "trait", 
           scaling = "sd", 
           svp = "trait"
           )
plot(pca)

# FactoExtra

pc <- prcomp(x = Data_path_new[ ,2:8],
             center = TRUE, 
             scale. = FALSE
             )
print(pc)
summary(pc)
biplot(pc)
library(factoextra)
fviz_pca_biplot(pc,
                label = "var",
                repel = TRUE,
                col.ind = "#696969",
                col.var = "#2E9FDF",
                gradient.cols = c("blue","green","red")
                )

# FactoExtra 2

# library(factoextra)
# res.pca <- prcomp(x= Data_path_new[ ,2:8], scale = TRUE)
# res.pca
# fviz_pca_biplot(res.pca, repel = TRUE, 
#                 geom.ind = c("arrow","text"),
#                 col.var = "#2E9FDF",
#                 col.ind = "#696969"
#                 )