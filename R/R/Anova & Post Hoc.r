library(readxl)
library(agricolae)
library(rstatix)
library(emmeans)

sheet_info <- list(
  list(sheet = "Tinggi Tanaman", col_name = "TT")
)

for (info in sheet_info) {
  sheet <- info$sheet
  col_name <- info$col_name
  
  RAK <- read_excel("./assets/Data Kedelai.xlsx", 
                    sheet = sheet,
                    col_types = c("text", "text", "numeric"))
  
  anova_formula <- as.formula(paste(col_name, "~ Perlakuan"))
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
|         Uji lanjut: BNJ           |
-------------------------------------
\n")
  bnj.test <- HSD.test(anova, 'Perlakuan', group=TRUE, console=FALSE)
  # Menampilkan struktur dari bnj.test$groups
  print(str(bnj.test$groups))
  
  # Mengurutkan hasil BNJ dari yang terkecil ke terbesar berdasarkan mean
  ordered_groups <- bnj.test$groups[order(bnj.test$groups$TT), ]
  
  # Menampilkan hasil yang telah diurutkan
  print(ordered_groups)
  
#   cat("\
# -------------------------------------
# |         Uji lanjut: DMRT          |
# -------------------------------------
# \n")
#   dmrt <- duncan.test(anova, "Perlakuan", group=TRUE, console=TRUE)

#   cat("\
# -------------------------------------
# |       Uji lanjut: TukeyHSD        |
# -------------------------------------
# \n")
#   TukeyHSD(anova, "Perlakuan")

#   cat("\
# -------------------------------------
# |       Uji lanjut: EMMEANS         |
# -------------------------------------
# \n")
#   emm <- emmeans(anova, "Perlakuan")
#   pairs(emm, adjust = "tukey")
}
