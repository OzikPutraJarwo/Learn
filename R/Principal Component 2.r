library(readxl)
library(metan)

Data <- read_excel("./assets/Data Total No R.xlsx", 
  col_types = c("text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

mod<-gtb(Data, Genotipe)

# Basic / GT Biplot
plot(mod,
     type = 1, 
     col.gen = 'blue',
     col.env = 'red',
     size.text.gen = 4
     )

# Average Tester Coordination
plot(mod,
     type = 2,
     col.gen = 'blue',
     col.env = 'red',
     size.text.gen = 3,
     repel=TRUE
     )

# Which-won-where (polygon) :)
plot(mod,
     type = 3,
     col.gen = 'blue',
     col.env = 'red',
     size.text.gen = 4,
     size.text.env = 4,
     repel = TRUE
     )

# Discriminativeness vs. representativeness
plot(mod,
     type = 4,
     col.gen = 'blue',
     col.env = 'red',
     size.text.gen = 4
     )

# Ranking traits
plot(mod,
     type = 6,
     col.gen = 'blue',
     col.env = 'red',
     size.text.gen = 4
     )

# Ranking genotypes :)
plot(mod,
     type = 8,
     col.gen = 'blue',
     col.env = 'red',
     size.text.gen = 4
     )

# Relationship among traits
plot(mod,
     type = 10,
     col.gen = 'blue',
     col.env = 'red',
     size.text.gen = 4
     )