import numpy as np
import pandas as pd
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

# Data contoh (gantilah dengan data Anda sendiri)
data = np.array([
    [2.5, 2.4],
    [0.5, 0.7],
    [2.2, 2.9],
    [1.9, 2.2],
    [3.1, 3.0],
    [2.3, 2.7],
    [2, 1.6],
    [1, 1.1],
    [1.5, 1.6],
    [1.1, 0.9]
])

# Standarisasi data
scaler = StandardScaler()
data_std = scaler.fit_transform(data)

# Inisialisasi PCA
pca = PCA()
pca.fit(data_std)

# Menyusun hasil
eigenvalues = pca.explained_variance_
explained_variance_ratio = pca.explained_variance_ratio_
cumulative_variance_ratio = np.cumsum(explained_variance_ratio)

# Tabel hasil
results = pd.DataFrame({
    'Component': [f'PC{i+1}' for i in range(len(eigenvalues))],
    'Eigenvalue': eigenvalues,
    'Variance (%)': explained_variance_ratio * 100,
    'Cumulative Variance (%)': cumulative_variance_ratio * 100
})

print(results)
