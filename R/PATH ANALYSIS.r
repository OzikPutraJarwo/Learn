library(readxl)
Mencoba_Path_Analysis <- read_excel("./assets/PATH ANALYSIS 2.xlsx", 
                                    col_types = c("numeric", "numeric", "numeric", 
                                                  "numeric", "numeric", "numeric", 
                                                  "numeric", "numeric", "numeric",
                                                  "numeric", "numeric", "numeric",
                                                  "numeric", "numeric", "numeric",
                                                  "numeric", "numeric", "numeric",
                                                  "numeric", "numeric", "numeric",
                                                  "numeric", "numeric", "numeric"))

# # Model regresi linear
# model1 <- lm(BSB ~ TT + JD + DB + JCA + JCT + JCB + JCL + CP + JR + JAR + JPT + BPT + BPL + PP + LP + TP + JBP + JBT + BBT + BBL + PB + LB + TB, data = Mencoba_Path_Analysis)
# library(car)
# vif(model1)

# Path analysis model
specmod1 <- "BSB ~ TT + JD + DB + JCA + JCT + JCB + JCL + CP + JR + JAR + JPT + BPT + BPL + PP + LP + TP + JBP + JBT + BBT + BBL + PB + LB + TB
"
library(lavaan)
m1 <- sem(specmod1, data = Mencoba_Path_Analysis, orthogonal = TRUE)
summary(m1, fit.measures = TRUE, standardized = TRUE)

# Visualisasi model
library(qgraph)
library(semPlot)
semPaths(m1, "std", mar = c(3,5,3,3), intercepts = TRUE, intStyle = "single", thresholds = TRUE, 
         rotation = 2, layout = "tree3", curvature = 8, title.cex = 0.1, 
         nCharNodes = 4, nCharEdges = 4, nDigits = 2, sizeMan = 6, sizeInt = 2, 
         sizeLat = 2, edge.label.cex = 0.8, exoVar = FALSE, fade = FALSE, 
         esize = 3, asize = 1.5, edge.width = 1, node.width = 1, width = 8, 
         height = 10, ThreshAtSide = TRUE, thresholdSize = 3, 
         optimizeLatRes = TRUE, centerLevels = TRUE, layoutSplit = TRUE, 
         cardinal = FALSE, edge.label.position = 0.45)