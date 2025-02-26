library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)

# File path
file_path <- "archive/Kedelai/Data Boxplot Lengkap.xlsx"

# Sheet details
sheets <- list(
  list(Sheet = "PP", xTitle = "Genotypes", yTitle = "Pod Length (mm)"),
  list(Sheet = "LP", xTitle = "Genotypes", yTitle = "Pod Width (mm)"),
  list(Sheet = "TP", xTitle = "Genotypes", yTitle = "Pod Thickness (mm)"),
  list(Sheet = "PB", xTitle = "Genotypes", yTitle = "Seed Length (mm)"),
  list(Sheet = "LB", xTitle = "Genotypes", yTitle = "Seed Width (mm)"),
  list(Sheet = "TB", xTitle = "Genotypes", yTitle = "Seed Thickness (mm)")
  list(Sheet = "PP", xTitle = "Genotypes", yTitle = "Pod Length (mm)"),
  list(Sheet = "LP", xTitle = "Genotypes", yTitle = "Pod Width (mm)"),
  list(Sheet = "TP", xTitle = "Genotypes", yTitle = "Pod Thickness (mm)"),
  list(Sheet = "PB", xTitle = "Genotypes", yTitle = "Seed Length (mm)"),
  list(Sheet = "LB", xTitle = "Genotypes", yTitle = "Seed Width (mm)"),
  list(Sheet = "TB", xTitle = "Genotypes", yTitle = "Seed Thickness (mm)")
)

# Process
process_and_plot <- function(sheet, xTitle, yTitle) {
  # Read xl
  data <- read_excel(file_path, sheet = sheet, col_names = TRUE)
  
  # Numerical columns
  data <- data %>%
    mutate(across(everything(), as.numeric))
  
  # Wide -> long
  data_long <- pivot_longer(data, cols = everything(), names_to = "Galur", values_to = "Data")
  
  # Calculations
  data_summary <- data_long %>%
    group_by(Galur) %>%
    summarise(
      Min = min(Data, na.rm = TRUE),
      Q1 = quantile(Data, 0.25, na.rm = TRUE),
      Median = median(Data, na.rm = TRUE),
      Q3 = quantile(Data, 0.75, na.rm = TRUE),
      Max = max(Data, na.rm = TRUE),
      Mean = mean(Data, na.rm = TRUE)
    )
  
  # Factorization
  data_summary$Galur <- factor(data_summary$Galur, levels = unique(data_long$Galur))
  data_long$Galur <- factor(data_long$Galur, levels = unique(data_long$Galur))
  
  # Boxplot
  ggplot(data_long, aes(x = Galur, y = Data, fill = Galur)) +
    # Outlier
    geom_boxplot(outlier.shape = 1, colour = "#1a1a1a") +
    # Garis mean
    stat_summary(fun = mean, geom = "point", shape = 23, size = 3, fill = "#1a1a1a") +
    # Min
    geom_segment(data = data_summary, aes(x = as.numeric(Galur) - 0.25, xend = as.numeric(Galur) + 0.25, y = Min, yend = Min), color = "#1a1a1a") + 
    # Max
    geom_segment(data = data_summary, aes(x = as.numeric(Galur) - 0.25, xend = as.numeric(Galur) + 0.25, y = Max, yend = Max), color = "#1a1a1a") +  
    # Axes label
    labs(title = "", x = xTitle, y = yTitle) +  
    # Scale y axis with more breaks
    scale_y_continuous(breaks = pretty(data_long$Data, n = 10)) + 
    # Theme
    theme_linedraw() + 
    # Legends
    theme(legend.position = "none",
        axis.text.x = element_text(angle = 90, hjust = 1))
}

# Loop
plots <- lapply(sheets, function(sheet_info) {
  process_and_plot(sheet_info$Sheet, sheet_info$xTitle, sheet_info$yTitle)
})

# Display
for (plot in plots) {
  print(plot)
}