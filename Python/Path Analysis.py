import pandas as pd
import statsmodels.api as sm
from statsmodels.formula.api import ols

# Load the data
file_path = './assets/PATH ANALYSIS 2.xlsx'
data = pd.read_excel(file_path)

# Define the path analysis formula
formula = 'BSB ~ TT + JD + DB + JCA + JCT + JCB + JCL + CP + JR + JAR + JPT + BPT + BPL + PP + LP + TP + JBP + JBT + BBT + BBL + PB + LB + TB'

# Fit the model
model = ols(formula, data=data).fit()

# Print the summary of the model
print(model.summary())

# Extracting coefficients and p-values for tabular representation
results = pd.DataFrame({
    'Coefficient': model.params,
    'P-Value': model.pvalues
})

# Save results to a CSV file
results.to_csv('path_analysis_results.csv', index=True)
