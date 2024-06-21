library(lavaan)
specmod51 <- "
BB~DT+PT+PB+DB+LBL+LBD+WBJ+WB+DRB+WP
"
library(lavaan)
m51<-sem(specmod51, data = Data_hasil_melon_Lawang ,orthogonal=TRUE)
print(m51)
library(semPlot)
semPaths(m51,"std", intercepts = TRUE, intStyle = "single", thresholds = TRUE, rotation = 2, layout = "tree3", curvature = 8, title.cex = 0.3, nCharNodes = 4, nCharEdges = 4, nDigits = 2,sizeMan = 6, sizeInt = 2, sizeLat = 2, edge.label.cex=0.8, exoVar = FALSE, fade=FALSE, esize = 3, asize = 1.5, edge.width = 1, node.width = 1, width = 7, height = 10, ThreshAtSide = TRUE, thresholdSize = 3, optimizeLatRes = TRUE, centerLevels = TRUE, layoutSplit = TRUE, cardinal = TRUE, edge.label.position=0.45)
semPaths(m51,"std", intercepts = TRUE, intStyle = "single", thresholds = TRUE, rotation = 2, layout = "tree3", curvature = 5, title.cex = 0.5, nCharNodes = 3, nCharEdges = 3, nDigits = 2,sizeMan = 7, sizeInt = 2, sizeLat = 3, edge.label.cex=0.85, exoVar = FALSE, fade=FALSE, esize = 5, asize = 3, edge.width = 1, node.width = 1, width = 5, height = 10, ThreshAtSide = TRUE, thresholdSize = 4, optimizeLatRes = FALSE, centerLevels = TRUE, layoutSplit = TRUE, cardinal = FALSE, edge.label.position=0.45)