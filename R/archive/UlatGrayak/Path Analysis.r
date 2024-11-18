library(readxl)
library(olsrr)
library(lavaan)
library(semPlot)

# Mengambil excel

Excel_Data_Total <- read_excel(
  "C:/Users/HP/Downloads/Data Path - Ulat Grayak.xlsx", 
  col_types = c(
    "text", "numeric", 
    "numeric", "numeric", "numeric", 
    "numeric", "numeric", "numeric", 
    "numeric", "numeric", "numeric", 
    "numeric"
  )
)

# Input data

model <- lm( # Hasil : BPT, BPL, BBT, BBL, BSB
  NP ~ 
  LTD + LA4DAP + LA6DAP	+ PH	+ NL	+ TF	+ HA	+ NPB	+ NFN + NFP,
  data = Excel_Data_Total
  ) 

# Mengecek VIF

ols_vif_tol(model)

# Data grafik

modelHasilVIF <- "NP ~ LTD + LA4DAP + LA6DAP	+ PH	+ NL	+ TF	+ HA	+ NPB	+ NFN + NFP"
modelOrtogonal <- sem(modelHasilVIF, data = Excel_Data_Total, orthogonal=TRUE)
print(modelOrtogonal)

# Format & print grafik

semPaths(
    modelOrtogonal,
    "std", 
    intercepts = TRUE, 
    mar = c(2,16,1,4), 
    intStyle = "single", 
    thresholds = TRUE, 
    rotation = 2, 
    layout = "tree3", 
    curvature = 10, 
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
    width = 6, 
    height = 9, 
    ThreshAtSide = TRUE, 
    thresholdSize = 3, 
    optimizeLatRes = TRUE, 
    centerLevels = TRUE, 
    layoutSplit = TRUE, 
    cardinal = TRUE, 
    edge.label.position=0.45
    )

    install.packages("devtools")

library(devtools)

install_github("OzikPutraJarwo/cropidr")
