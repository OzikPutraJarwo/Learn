library(factoextra)
library(ggplot2)

data = iris

data.pca <- prcomp(data[, -5], 
                  scale = TRUE)

summary(data.pca)

fviz_pca_ind(data.pca, 
            habillage=data$Species,
            addEllipses=TRUE)