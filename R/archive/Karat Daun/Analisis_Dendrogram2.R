# Memuat paket
library(ggplot2)
library(dendextend)

# Membaca data dari data frame
data <- read.table(header = TRUE, text = "
Genotype K
UBASK16 1
UBASK13 1
UBASK14 1
UBASK12 1
UBASK15 1
UBASK61 1
UBASK63 3
UBASK64 1
UBASK62 1
UBASK65 1
UBASK31 1
UBASK36 1
UBASK34 2
UBASK32 3
UBASK35 1
UBASK41 1
UBASK46 1
UBASK43 3
UBASK42 1
UBASK45 1
UBASK21 2
UBASK26 1
UBASK23 2
UBASK24 2
UBASK25 1
UBASK51 1
UBASK56 1
UBASK53 1
UBASK54 2
UBASK52 1
AJM 1
AGP 2
GBG 1
TGM 1
UB1 1
UB2 1
")

# Membuat matriks jarak
dist_matrix <- dist(data$K)

# Menghitung hierarki clustering
hc <- hclust(dist_matrix)

# Mengonversi hasil clustering menjadi dendrogram
dend <- as.dendrogram(hc)

# Menggambar dendrogram
plot(dend, main = "Dendrogram of Genotypes", xlab = "Genotypes", ylab = "Height")

#######################################

# Install and load the dendextend package
if (!require(dendextend)) install.packages("dendextend", dependencies = TRUE)
library(dendextend)

# Hierarchical clustering
hc <- hclust(dist_matrix, method = "ward.D2")

# Convert to dendrogram and customize
dend <- as.dendrogram(hc)

# Tambahkan warna pada klaster
dend <- color_branches(dend, k = 3) # Misal 3 klaster
dend <- set(dend, "labels_colors", k = 3) # Warna label sesuai klaster

# Plot dendrogram
plot(dend, main = "Dendrogram with dendextend", xlab = "Genotypes", ylab = "Height")

#######################################

# Install and load the ape package
if (!require(ape)) install.packages("ape", dependencies = TRUE)
library(ape)

# Convert hclust to phylo object
phylo_tree <- as.phylo(hc)

# Plot as a cladogram
plot(phylo_tree, type = "cladogram", main = "Cladogram with ape")

# Plot as a radial tree
plot(phylo_tree, type = "fan", main = "Radial Tree with ape")

######################################

# Install and load ggtree
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
if (!require(ggtree)) BiocManager::install("ggtree")
library(ggtree)

# Convert hclust to phylo object
phylo_tree <- as.phylo(hc)

# Plot tree with ggtree
ggtree(phylo_tree) +
  geom_tiplab() +
  labs(title = "Dendrogram with ggtree", x = "Distance", y = "Genotype")