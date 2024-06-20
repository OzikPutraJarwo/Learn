library(readxl)
Excel_PATH_ANALYSIS <- read_excel("assets/Path Analysis.xlsx", col_types = c("numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

# Path analysis model
model <- "BSB ~ TT + JD + DB + JCA + JCT + JCB + JCL + CP + JR + JAR + JPT + BPT + BPL + PP + LP + TP + JBP + JBT + BBT + BBL + PB + LB + TB"

# BSB ~ TT + JD + DB + JCA + JCT + JCB + JCL + CP + JR + JAR + JPT + BPT + BPL + PP + LP + TP + JBP + JBT + BBT + BBL + PB + LB + TB

library(lavaan)
m1 <- sem(model, data = Excel_PATH_ANALYSIS, orthogonal = TRUE)
summary(m1, fit.measures = TRUE, standardized = TRUE)

# Visualisasi model
library(qgraph)
library(semPlot)
semPaths(m1, "std", mar = c(3,5,3,3), intercepts = TRUE, intStyle = "single", thresholds = TRUE, rotation = 2, layout = "tree", curvature = 8, title.cex = 0.1, nCharNodes = 4, nCharEdges = 4, nDigits = 2, sizeMan = 6, sizeInt = 2, sizeLat = 2, edge.label.cex = 0.8, exoVar = FALSE, fade = FALSE, esize = 3, asize = 1.5, edge.width = 1, node.width = 1, width = 8, height = 10, ThreshAtSide = TRUE, thresholdSize = 3, optimizeLatRes = TRUE, centerLevels = TRUE, layoutSplit = TRUE, cardinal = FALSE, edge.label.position = 0.45)