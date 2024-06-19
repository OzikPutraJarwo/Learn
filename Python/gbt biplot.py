import pandas as pd
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA

# Load the Excel file
file_path = './assets/Data Total.xlsx'
df = pd.read_excel(file_path, sheet_name='Sheet1')

# Drop the 'Genotipe' column and standardize the data
data = df.drop(columns=['Genotipe'])
genotypes = df['Genotipe']
data_standardized = (data - data.mean()) / data.std()

# Perform PCA
pca = PCA()
pca_scores = pca.fit_transform(data_standardized)

# Get the loadings for the principal components
loadings = pca.components_

# Biplot
plt.figure(figsize=(10, 7))

# Plotting the scores (genotypes)
for i in range(pca_scores.shape[0]):
    plt.scatter(pca_scores[i, 0], pca_scores[i, 1], color='b')
    plt.text(pca_scores[i, 0], pca_scores[i, 1], genotypes[i], fontsize=9)

# Plotting the loadings (traits)
for i in range(loadings.shape[1]):
    plt.arrow(0, 0, loadings[0, i]*max(pca_scores[:, 0]), loadings[1, i]*max(pca_scores[:, 1]), 
              color='r', head_width=0.05)
    plt.text(loadings[0, i]*max(pca_scores[:, 0])*1.15, loadings[1, i]*max(pca_scores[:, 1])*1.15, 
             data.columns[i], color='r', fontsize=9)

plt.xlabel('PC1')
plt.ylabel('PC2')
plt.title('Genotype-by-Trait Biplot')
plt.grid()
plt.show()
