library(readxl)
library(metan)

Data <- read_excel("E:/Blog/Learn/R/archive/Kedelai/Data Total Lengkap.xlsx",
	sheet = "Sheet2",
  col_types = c("text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

mod<-gtb(Data, Genotipe)

# Which-won-where (polygon)
plot(mod,
     type = 3,
     col.gen = 'blue',
     col.env = 'red',
     size.text.gen = 4,
     size.text.env = 4,
     repel = TRUE
     )

# Ranking genotypes
plot(mod,
     type = 8,
     col.gen = 'blue',
     col.env = 'red',
     size.text.gen = 4,
     size.text.env = 4,
     repel = TRUE
     )