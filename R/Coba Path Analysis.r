library(readxl)
Data_path_new <- read_excel("E:/Blog/Learn/R/assets/Data Total.xlsx", 
                           col_types = c("text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

library(lavaan)
var <- "BSB ~ TT + JD + DB"
m<-sem(var, data = Data_path_new,orthogonal=TRUE)
print(m)
library(semPlot)
semPaths(m,"std", intercepts = TRUE, intStyle = "single", thresholds = TRUE, rotation = 2, layout = "tree3", curvature = 8, title.cex = 0.1, nCharNodes = 4, nCharEdges = 4, nDigits = 2,sizeMan = 6, sizeInt = 2, sizeLat = 2, edge.label.cex=0.8, exoVar = FALSE, fade=FALSE, esize = 3, asize = 1.5, edge.width = 1, node.width = 1, width = 7, height = 10, ThreshAtSide = TRUE, thresholdSize = 3, optimizeLatRes = TRUE, centerLevels = TRUE, layoutSplit = TRUE, cardinal = FALSE, edge.label.position=0.45)