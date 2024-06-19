# Install and load necessary packages
# install.packages("readxl")
# install.packages("tidyverse")
# install.packages("factoextra")

library(readxl)
library(tidyverse)
library(factoextra)

# Read the Excel file
file_path <- "./assets/PCA_LoadingFactor.xlsx"
data <- read_excel(file_path)

# View the first few rows of the data
head(data)

# List of relevant columns (characteristics)
character_columns <- c("TT")

# Ensure all selected columns are numeric
# Convert non-numeric columns to numeric if applicable
data <- data %>%
  mutate(across(all_of(character_columns), as.numeric))

# Remove rows with NA values resulting from the conversion
characteristics_data <- data %>% select(all_of(character_columns)) %>% drop_na()

# Perform PCA using prcomp
pca_result <- prcomp(characteristics_data, scale. = TRUE)

# Extract eigenvalues
eigenvalues <- pca_result$sdev^2
print("Eigenvalues")
print(eigenvalues)

# Filter components with eigenvalue >= 1
filtered_indices <- which(eigenvalues >= 1)
print("Filtered components with eigenvalue >= 1")
print(filtered_indices)

# Extract loadings for components with eigenvalue >= 1
loadings <- pca_result$rotation[, filtered_indices]
print("Loadings for components with eigenvalue >= 1")
print(loadings)

# Plot the PCA individuals
fviz_pca_ind(pca_result, geom.ind = "point", col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE) + 
  theme_minimal()

# Plot the PCA variables
fviz_pca_var(pca_result, col.var = "contrib", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"))

# Visualize the scree plot
fviz_eig(pca_result, addlabels = TRUE, ylim = c(0, 50))
