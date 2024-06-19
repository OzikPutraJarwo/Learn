# Instal dan muat paket yang diperlukan
# install.packages("ggplot2")
# install.packages("ggbeeswarm")
library(ggplot2)
library(ggbeeswarm)

# Siapkan data
set.seed(123)
data <- data.frame(
    group = rep(c("A", "B"), each = 20),
    value = c(rnorm(20, mean = 5), rnorm(20, mean = 7))
)

# Boxplot standar
ggplot(data, aes(x = group, y = value)) +
    geom_boxplot()

# Boxplot dengan jittered points
ggplot(data, aes(x = group, y = value)) +
    geom_boxplot() +
    geom_jitter(width = 0.2, color = "blue", alpha = 0.5)

# Violin plot
ggplot(data, aes(x = group, y = value)) +
    geom_violin() +
    geom_boxplot(width = 0.1)

# Dot plot
ggplot(data, aes(x = group, y = value)) +
    geom_dotplot(binaxis = 'y', stackdir = 'center', dotsize = 1)

# Beeswarm plot
ggplot(data, aes(x = group, y = value)) +
    geom_boxplot() +
    geom_beeswarm(size = 2)

# Boxplot dengan mean point
ggplot(data, aes(x = group, y = value)) +
    geom_boxplot() +
    stat_summary(fun = mean, geom = "point", shape = 20, size = 3, color = "red")

# Boxplot dengan garis error
ggplot(data, aes(x = group, y = value)) +
    geom_boxplot() +
    stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0.2)

# Boxplot dengan outliers tertentu yang disorot
highlighted <- subset(data, value > 8)

ggplot(data, aes(x = group, y = value)) +
    geom_boxplot() +
    geom_point(data = highlighted, aes(x = group, y = value), color = "red", size = 3)
