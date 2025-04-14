# library(ScottKnott)
# library(readxl)

# data <- read_excel("archive/Kedelai S1 2021/Data Pengamatan Kedelai 2024 (8).xlsx", sheet = "Tinggi Tanaman")

# model <- aov(MST3 ~ Ulangan + Galur, data = data)
# sk_result1 <- SK(model, which = "Galur")
# summary(sk_result1)

# sk_result2 <- SK(model, which = "Kemasaman") 
# summary(sk_result2)

# sk_result_interaction <- SK(model, which = "Galur:Kemasaman")
# summary(sk_result_interaction)

# summary(model)
# names(model)

# demo(package='ScottKnott')

# sk_result_interaction <- SK(model, which = "Galur:Kemasaman", fl1=1)
# summary(sk_result_interaction)

# ####################

# sk_result_interaction <- SK(model, which = "Galur:Kemasaman")
# summary(sk_result_interaction)


####################


# library(AgroR)

#=============================
# Example laranja
#=============================
data(laranja)
attach(laranja)
View(laranja)
DBC(trat, bloco, resp, mcomp = "sk", angle=45, ylab = "Number of fruits/plants")