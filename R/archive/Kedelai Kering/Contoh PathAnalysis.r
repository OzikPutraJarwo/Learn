# Instalasi Library

# install.packages("httpgd")

# Pemanggilan Library

library(readxl)
library(olsrr)
library(lavaan)
library(semPlot)
         
# Setting excel data

Excel_Data_Total <- read_excel(
  "R/archive/Kedelai Kering/Contoh Data Total.xlsx", 
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

model <- lm(
  BPT ~ 
  TT + JD + DB + JCA + JCT + JCB + JCL + CP + JR + JAR + PP + LP + TP + PB + LB + TB + JPT + JBP + JBT, 
  data = Excel_Data_Total
  ) 

# Mengecek VIF

ols_vif_tol(model)

# Data grafik

modelHasilVIF <- "BBL ~ TT + JD + DB + CP + JR + JAR + LP + TP + JPT + JBP + JBT"
modelOrtogonal <- sem(modelHasilVIF, data = Excel_Data_Total, orthogonal=TRUE)
print(modelOrtogonal)

# Format & print grafik

semPaths(
    modelOrtogonal,
    "std", 
    intercepts = TRUE, 
    mar = c(1,-1,1,-8),     # Margin
    intStyle = "single",    
    thresholds = TRUE,      
    rotation = 2,           # Rotasi
    layout = "tree2",       # Layout
    curvature = 20,         # Kelengkungan
    title.cex = 0.3,
    nCharNodes = 4,
    nCharEdges = 3,
    nDigits = 2,            
    sizeMan = 4, 
    sizeInt = 2, 
    sizeLat = 2, 
    edge.label.cex=0.8, 
    exoVar = FALSE, 
    fade=FALSE, 
    esize = 3, 
    asize = 1.5, 
    edge.width = 1, 
    node.width = 1, 
    width = 10, 
    height = 9, 
    ThreshAtSide = TRUE, 
    thresholdSize = 3, 
    optimizeLatRes = TRUE, 
    centerLevels = TRUE, 
    layoutSplit = TRUE, 
    cardinal = TRUE, 
    edge.label.position=0.45
    )
