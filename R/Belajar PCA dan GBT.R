library(readxl)
Data_path_new <- read_excel("./assets/Mencoba Path Analysis.xlsx", 
                            col_types = c("text","numeric", "numeric", "numeric", 
                                          "numeric", "numeric", "numeric", 
                                          "numeric"))

library(metan)
pca<-gtb(Data_path_new, "Genotype", resp = c("R", "BPB", "PB", "BuT", "HB", "BiT"), centering = "trait", scaling = "sd", svp = "trait" )
summary(pca)
print(pca)
plot(pca)

pc <- prcomp(x = Data_path_new[ , -1],
             center = TRUE, 
             scale. = FALSE)
print(pc)
summary(pc)
biplot(pc)
library(factoextra)
fviz_pca_biplot(pc,
                label = "var",
                col.ind = "black",
                col.var = "contrib",
                gradient.cols = c("blue","green","red"))

library(factoextra)
res.pca <- prcomp(x= Data_path_new[ ,2:9], scale = TRUE)
res.pca
fviz_pca_biplot(res.pca, repel = TRUE, geom.ind = c("arrow","text"),
                col.var = "#2E9FDF",
                col.ind = "#696969")

