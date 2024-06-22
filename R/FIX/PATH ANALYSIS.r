# Mengambil excel

library(readxl)
Excel_Data_Total <- read_excel(
  "R/assets/Data Total.xlsx", 
  col_types = c(
    "text", "text","numeric", 
    "numeric", "numeric", "numeric", 
    "numeric", "numeric", "numeric", 
    "numeric", "numeric", "numeric", 
    "numeric", "numeric", "numeric", 
    "numeric", "numeric", "numeric", 
    "numeric", "numeric", "numeric", 
    "numeric", "numeric", "numeric", 
    "numeric", "numeric"
  )
)

# Input data

# Hasil : BPT, BPL, BBT, BBL, BSB

model <- lm(
  BPT ~ 
  TT + JD + DB + JCA + JCT + JCB + JCL + CP + JR + JAR + PP + LP + TP + PB + LB + TB + JPT + JBP + JBT, 
  data = Excel_Data_Total
  ) 

# Mengecek VIF

library(olsrr)
ols_vif_tol(model)

# Data grafik

modelHasilVIF <- "BBL ~ TT + JD + DB + CP + JR + JAR + LP + TP + JPT + JBP + JBT"
library(lavaan)
modelOrtogonal <- sem(modelHasilVIF, data = Excel_Data_Total, orthogonal=TRUE)
print(modelOrtogonal)

# Format & print grafik

library(semPlot)
semPaths(modelOrtogonal,"std", intercepts = TRUE, mar = c(2,1,1,-4), intStyle = "single", thresholds = TRUE, rotation = 2, layout = "tree3", curvature = 10, title.cex = 0.3, nCharNodes = 4, nCharEdges = 3, nDigits = 2, sizeMan = 4, sizeInt = 2, sizeLat = 2, edge.label.cex=0.8, exoVar = FALSE, fade=FALSE, esize = 3, asize = 1.5, edge.width = 1, node.width = 1, width = 6, height = 9, ThreshAtSide = TRUE, thresholdSize = 3, optimizeLatRes = TRUE, centerLevels = TRUE, layoutSplit = TRUE, cardinal = TRUE, edge.label.position=0.45)