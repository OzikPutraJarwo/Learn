library(readxl)
library(metan)

Data <- read_excel("R/assets/Data Total No R.xlsx", 
  col_types = c("text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

mod<-gtb(Data, Genotipe)

# Basic / GT Biplot
plot(mod,
  type = 1, 
  col.gen = 'blue',
  col.env = 'red',
  size.text.gen = 4
  )