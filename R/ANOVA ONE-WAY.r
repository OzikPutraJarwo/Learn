if (!require("readxl")) install.packages("readxl")
if (!require("dplyr")) install.packages("dplyr")
if (!require("tibble")) install.packages("tibble")
if (!require("crayon")) install.packages("crayon")

library(readxl)
library(dplyr)
library(tibble)
library(crayon)

excel_path <- "./assets/Data ANOVA ONE-WAY.xlsx"
excel_cols <- c("text", "text", "numeric", "numeric")
anova_form <- "~ Ulangan + Perlakuan"
sheet_info <- list(
  list(sheet = "Sheet1", col_name = "TT"),
  list(sheet = "Sheet1", col_name = "JD")
)

for (info in sheet_info) {
  sheet <- info$sheet
  col_name <- info$col_name
  data <- read_excel(excel_path, sheet = sheet, col_types = excel_cols)
  anova_formula <- as.formula(paste(col_name, anova_form))
  anova <- aov(anova_formula, data = data)
  
  anova_summary <- summary(anova)
  
  anova_df <- as.data.frame(anova_summary[[1]])
  anova_df <- rownames_to_column(anova_df, var = "Term")
  anova_df$Term <- gsub("Residuals", "Galat", anova_df$Term)
  colnames(anova_df)[colnames(anova_df) == "Df"] <- "db"
  colnames(anova_df)[colnames(anova_df) == "Sum Sq"] <- "JK"
  colnames(anova_df)[colnames(anova_df) == "Mean Sq"] <- "KT"
  colnames(anova_df)[colnames(anova_df) == "F value"] <- "F-hit"
  
  f_table <- qf(0.95, anova_df$db[1:2], anova_df$db[3])
  anova_df$`F-tab` <- c(f_table, NA)
  
  colnames(anova_df)[colnames(anova_df) == "Pr(>F)"] <- "P-val"
  anova_df <- anova_df %>% relocate(`F-tab`, .before = `P-val`)
  anova_df <- column_to_rownames(anova_df, var = "Term")
  
  db_Total <- (anova_df$db[1] + 1) * (anova_df$db[2] + 1) - 1
  db_JK <- (anova_df$JK[1]) + (anova_df$JK[2]) + (anova_df$JK[3])
  total_row <- setNames(data.frame(
    db = db_Total,
    JK = db_JK,
    KT = NA,
    `F-hit` = NA,
    `F-tab` = NA,
    `P-val` = NA
  ), names(anova_df))
  anova_df <- rbind(anova_df, total_row)
  rownames(anova_df)[nrow(anova_df)] <- "Total"

  sigma_KTG <- anova_df$KT[3]
  mu_KTG <- mean(data[[col_name]], na.rm = TRUE)
  cv <- sqrt(sigma_KTG) / mu_KTG * 100

  signif <- ifelse(
    anova_df$`P-val` <= 0.01, green("**"),
    ifelse(anova_df$`P-val` <= 0.05, yellow("*"), red("tn"))
  )
  signif[is.na(anova_df$`P-val`)] <- NA

  cat("\n➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖\n")
  cat(bold(blue(sheet, "—", col_name)))
  cat("\n")
  print(anova_df)
  cat("KK :", cv, "%\n")
  cat("Signifikansi:\n")
  cat("   Ulangan: ", signif[1], "\n")
  cat("   Perlakuan: ", signif[2])
  cat("\n➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖\n")
}