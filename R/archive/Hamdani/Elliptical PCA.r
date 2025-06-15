library(factoextra)
library(ggplot2)

data = read.csv("R/archive/Hamdani/data.csv")

data.pca <- prcomp(data[, -6], 
                  scale = TRUE)

summary(data.pca)

fviz_pca_ind(data.pca, 
            habillage=data$Species,
            addEllipses=TRUE)