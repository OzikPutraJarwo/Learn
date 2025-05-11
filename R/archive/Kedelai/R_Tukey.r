# Membuat data frame dengan 3 replikasi untuk setiap genotipe
set.seed(123) # Untuk reproduktibilitas

data_ph <- data.frame(
  Genotipe = rep(c("UBASK16", "UBASK13", "UBASK14", "UBASK12", "UBASK15", 
                  "UBASK61", "UBASK63", "UBASK64", "UBASK62", "UBASK65",
                  "UBASK31", "UBASK36", "UBASK34", "UBASK32", "UBASK35",
                  "UBASK41", "UBASK46", "UBASK43", "UBASK42", "UBASK45",
                  "UBASK21", "UBASK26", "UBASK23", "UBASK24", "UBASK25",
                  "UBASK51", "UBASK56", "UBASK53", "UBASK54", "UBASK52",
                  "AJM", "AGP", "GBG", "TGM", "UB1", "UB2"), each = 3),
  PH = c(
    # UBASK16
    rnorm(3, mean = 87.63, sd = 2),
    # UBASK13
    rnorm(3, mean = 76.29, sd = 2),
    # UBASK14
    rnorm(3, mean = 75.79, sd = 2),
    # UBASK12
    rnorm(3, mean = 72.46, sd = 2),
    # UBASK15
    rnorm(3, mean = 83.17, sd = 2),
    # UBASK61
    rnorm(3, mean = 82.13, sd = 2),
    # UBASK63
    rnorm(3, mean = 78.50, sd = 2),
    # UBASK64
    rnorm(3, mean = 82.25, sd = 2),
    # UBASK62
    rnorm(3, mean = 90.38, sd = 2),
    # UBASK65
    rnorm(3, mean = 56.00, sd = 2),
    # UBASK31
    rnorm(3, mean = 88.67, sd = 2),
    # UBASK36
    rnorm(3, mean = 77.83, sd = 2),
    # UBASK34
    rnorm(3, mean = 60.75, sd = 2),
    # UBASK32
    rnorm(3, mean = 89.08, sd = 2),
    # UBASK35
    rnorm(3, mean = 68.58, sd = 2),
    # UBASK41
    rnorm(3, mean = 65.92, sd = 2),
    # UBASK46
    rnorm(3, mean = 74.00, sd = 2),
    # UBASK43
    rnorm(3, mean = 81.42, sd = 2),
    # UBASK42
    rnorm(3, mean = 75.33, sd = 2),
    # UBASK45
    rnorm(3, mean = 76.58, sd = 2),
    # UBASK21
    rnorm(3, mean = 90.25, sd = 2),
    # UBASK26
    rnorm(3, mean = 91.00, sd = 2),
    # UBASK23
    rnorm(3, mean = 88.33, sd = 2),
    # UBASK24
    rnorm(3, mean = 82.75, sd = 2),
    # UBASK25
    rnorm(3, mean = 90.75, sd = 2),
    # UBASK51
    rnorm(3, mean = 87.17, sd = 2),
    # UBASK56
    rnorm(3, mean = 93.08, sd = 2),
    # UBASK53
    rnorm(3, mean = 97.92, sd = 2),
    # UBASK54
    rnorm(3, mean = 85.33, sd = 2),
    # UBASK52
    rnorm(3, mean = 95.17, sd = 2),
    # AJM
    rnorm(3, mean = 75.00, sd = 2),
    # AGP
    rnorm(3, mean = 74.08, sd = 2),
    # GBG
    rnorm(3, mean = 57.83, sd = 2),
    # TGM
    rnorm(3, mean = 92.17, sd = 2),
    # UB1
    rnorm(3, mean = 85.75, sd = 2),
    # UB2
    rnorm(3, mean = 78.08, sd = 2)
  )
)

# Melihat struktur data
head(data_ph)
str(data_ph)

# Mengubah Genotipe menjadi faktor
data_ph$Genotipe <- as.factor(data_ph$Genotipe)

# Analisis ANOVA
anova_result <- aov(PH ~ Genotipe, data = data_ph)
summary(anova_result)

# Uji Post-Hoc Tukey HSD
tukey_result <- TukeyHSD(anova_result)
tukey_result

# Visualisasi hasil Tukey
par(mar = c(5, 12, 4, 2)) # Menyesuaikan margin
plot(tukey_result, las = 2, cex.axis = 0.6)

# Menampilkan perbedaan signifikan
library(multcompView)
tukey.cld <- multcompLetters4(anova_result, tukey_result)
print(tukey.cld)

# Atau dalam bentuk yang lebih mudah dibaca
cld <- as.data.frame.list(tukey.cld$Genotipe)
data_ph$cld <- cld$Letters

# Rata-rata dan pengelompokan
library(dplyr)
mean_ph <- data_ph %>%
  group_by(Genotipe) %>%
  summarise(mean_PH = mean(PH),
            grouping = first(cld)) %>%
  arrange(desc(mean_PH))

print(mean_ph)