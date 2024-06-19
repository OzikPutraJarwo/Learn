import pandas as pd
from sklearn.decomposition import PCA

# Load the Excel file
file_path = './assets/Data Total.xlsx'
df = pd.read_excel(file_path, sheet_name='Sheet1')

# Drop the 'Genotipe' column and standardize the data
data = df.drop(columns=['Genotipe'])
data_standardized = (data - data.mean()) / data.std()

# Perform PCA
pca = PCA()
pca.fit(data_standardized)

# Get the eigenvalues (explained variance)
eigenvalues = pca.explained_variance_

# Create a dataframe for eigenvalues
eigenvalues_df = pd.DataFrame(eigenvalues, columns=['Eigenvalue'])
eigenvalues_df.index = [f'PC{i+1}' for i in range(len(eigenvalues))]

# Get the loadings for the principal components
loadings = pca.components_

# Identify significant components with eigenvalues > 1
significant_indices = [i for i, eig in enumerate(eigenvalues) if eig > 1]
significant_loadings = loadings[significant_indices, :]

# Create a dataframe to display the significant loadings
significant_loadings_df = pd.DataFrame(significant_loadings.T, index=data.columns, columns=[f'PC{i+1}' for i in significant_indices])

# Save the results to Excel files
eigenvalues_df.to_excel('eigenvalues.xlsx')
significant_loadings_df.to_excel('significant_loadings.xlsx')

print("Eigenvalues and loadings have been saved to 'eigenvalues.xlsx' and 'significant_loadings.xlsx'.")
