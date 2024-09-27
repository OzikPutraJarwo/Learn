# import Pkg; Pkg.add("DataFrames")
# import Pkg; Pkg.add("XLSX")
# import Pkg; Pkg.add("Statistics")
# import Pkg; Pkg.add("Distances")
# import Pkg; Pkg.add("Clustering")
# import Pkg; Pkg.add("Plots")

using DataFrames
using XLSX
using Statistics
using Distances
using Clustering
using Plots

# Membaca data dari file Excel
data_path = "R/assets/Data Total No R.xlsx"
data = DataFrame(XLSX.readtable(data_path, "Sheet1", infer_eltypes=true)[1])

# Mengambil kolom 2 sampai 25
data_z = select(data, 2:25)

# Melakukan standarisasi data
data_z = DataFrame(StandardScaler().fit_transform(Matrix(data_z)))

# Menghitung jarak Euclidean
data_dist = pairwise(Euclidean(), Matrix(data_z))

# Melakukan klasterisasi hirarkis dengan metode average linkage
data_a = hclust(data_dist, linkage=:average)

# Membuat dendrogram
plot(data_a, main="Cluster Dendrogram Average Linkage", c=:viridis, size=(800, 600), c=:black)