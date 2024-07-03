library(readxl)
library(emmeans)
library(multcomp)
library(multcompView)

sheet_info <- list(
  list(sheet = "Tinggi Tanaman", col_name = "TT")
)

for (info in sheet_info) {
  sheet <- info$sheet
  col_name <- info$col_name
  
  RAK <- read_excel("./assets/Data Kedelai.xlsx", 
                    sheet = sheet,
                    col_types = c("text", "text", "numeric"))
  
  anova_formula <- as.formula(paste(col_name, "~ Ulangan + Perlakuan"))
  anova <- aov(anova_formula, data = RAK)

  cat("\
====================================
\n")
  cat(sheet)
  cat("\n\
====================================
\n")
  
  cat("\
-------------------------------------
|              ANOVA                |
-------------------------------------
\n")
  print(summary(anova))
  
  cat("\
-------------------------------------
|         Uji lanjut: Tukey         |
-------------------------------------
\n")
  emmeans_result <- emmeans(anova, ~ Perlakuan)
  tukey_result <- multcomp::cld(emmeans_result, Letters = letters)
  ordered_results <- tukey_result[order(tukey_result$emmean), ]
  print(ordered_results)
}
