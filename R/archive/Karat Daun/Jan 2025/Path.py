import pandas as pd
import statsmodels.api as sm
from semopy import Model
import networkx as nx
import matplotlib.pyplot as plt

# Load dataset
file_path = "C:/Users/HP/Downloads/Raw Data Karat Daun.xlsx"
df = pd.read_excel(file_path)

# Define independent and dependent variables
dependent_vars = ['DI', 'NS']
independent_vars = ['PH', 'NL', 'NPB', 'FA', 'HA', 'TP', 'FP', 'PW', 'SW', 'W100', 'LT', 'ET', 'LC', 'TD', 'SD', 'CC']

# Check for multicollinearity using VIF
from statsmodels.stats.outliers_influence import variance_inflation_factor
X = df[independent_vars]
X = sm.add_constant(X)
vif_data = pd.DataFrame()
vif_data["Variable"] = X.columns
vif_data["VIF"] = [variance_inflation_factor(X.values, i) for i in range(X.shape[1])]
print("Variance Inflation Factors:")
print(vif_data)

# Define SEM model
sem_model = """
DI ~ PH + NL + NPB + FA + HA + TP + FP + PW + SW + W100 + LT + ET + LC + TD + SD + CC
NS ~ PH + NL + NPB + FA + HA + TP + FP + PW + SW + W100 + LT + ET + LC + TD + SD + CC
"""

model = Model(sem_model)
model.fit(df)

# Print model results
print("Path Analysis Results:")
print(model.inspect())

# Visualizing the Path Model
G = nx.DiGraph()

# Adding nodes
for var in independent_vars + dependent_vars:
    G.add_node(var)

# Adding edges based on SEM relationships
for dep in dependent_vars:
    for ind in independent_vars:
        G.add_edge(ind, dep)

plt.figure(figsize=(10, 6))
pos = nx.spring_layout(G)
nx.draw(G, pos, with_labels=True, node_size=3000, node_color='lightblue', edge_color='gray', font_size=10, font_weight='bold')
plt.title("Path Analysis Model")
plt.show()
