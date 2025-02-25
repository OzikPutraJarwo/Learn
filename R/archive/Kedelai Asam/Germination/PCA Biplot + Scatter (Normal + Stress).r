packages <- c("tidyverse", "factoextra", "readxl", "ggplot2", "scales")
lapply(packages, function(pkg) {
  if (!require(pkg, character.only = TRUE)) install.packages(pkg)
})

library(tidyverse)
library(factoextra)
library(readxl)
library(ggplot2)
library(scales)

file_path <- "R/archive/Kedelai Asam/Germination/Dataset for PCA.xlsx"
df_normal <- read_excel(file_path, sheet = 1)
df_stress <- read_excel(file_path, sheet = 2)

colnames(df_normal) <- gsub("_Normal", "", colnames(df_normal))
colnames(df_stress) <- gsub("_Stress", "", colnames(df_stress))

df_normal$Treatment <- "Control"
df_stress$Treatment <- "Stress"

df_combined <- bind_rows(df_normal, df_stress)

df_numeric <- df_combined %>% select(-Genotype)

pca_result <- prcomp(df_numeric %>% select(-Treatment), center = TRUE, scale. = TRUE)

pca_plot <- fviz_pca_biplot(pca_result,
  geom.ind = "point",
  col.ind = as.factor(df_combined$Treatment),
  palette = c("green", "red"),
  addEllipses = TRUE,
  ellipse.type = "norm",
  labelsize = 5,
  legend.title = list(fill = "Treatments"), 
  repel = TRUE,
  alpha.var = "contrib"
) + 
  theme_minimal()

print(pca_plot)