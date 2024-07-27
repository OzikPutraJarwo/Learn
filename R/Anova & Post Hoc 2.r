library(readxl)
library(emmeans)
library(multcomp)
library(multcompView)

sheet_info <- list(
  list(sheet = "TT", col_name = "MST5")
)

for (info in sheet_info) {
  sheet <- info$sheet
  col_name <- info$col_name
  
  RAK <- read_excel("E:/Kuliah/Skripsi/Olah Data Ozik.xlsx", 
                    sheet = sheet,
                    col_types = c("text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
  
  anova_formula <- as.formula(paste(col_name, "~ Ulangan + Perlakuan"))
  anova <- aov(anova_formula, data = RAK)

  cat("\n", sheet, " ", col_name, "\n\n")
  
  print(summary(anova))

  emmeans_result <- emmeans(anova, ~ Perlakuan)
  tukey_result <- multcomp::cld(emmeans_result, Letters = letters)
  ordered_results <- tukey_result[order(tukey_result$emmean), ]
  print(ordered_results)
  
  # Menghitung nilai Tukey (BNJ)
  df_error <- df.residual(anova)
  MSE <- sum(anova$residuals^2) / df_error
  n_groups <- length(unique(RAK$Perlakuan))
  tukey_value <- qtukey(0.95, n_groups, df_error) * sqrt(MSE / n_groups)
  cat("\nBNJ: ", tukey_value, "\n\n")
}
