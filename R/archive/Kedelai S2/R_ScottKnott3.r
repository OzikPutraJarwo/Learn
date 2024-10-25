packages <- c("agricolae", "ScottKnott", "devtools")

for (pkg in packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
  }
}

library(devtools)

if (!require("cropid")) {
  install_github("OzikPutraJarwo/cropidr")
}

library(agricolae)
library(ScottKnott)
library(cropid)

avs(
  excel_j = "C:/Users/User/Downloads/Data Pengamatan Kedelai 2024 FIX.xlsx",
  excel_k = c("text", "numeric", "numeric"),
  sheet_n = "VolumeAkar1",
  sheet_k = "MST3",
  anova_r = "RAK",
  anova_p = "Galur",
  anova_u = "Ulangan",
  posthoc = ""
)

data <- data.frame(

  PerlakuanA = factor(c('G1K0','G1K0','G1K1','G1K1','G2K0','G2K0','G2K1','G2K1','G3K0','G3K0','G3K1','G3K1','G4K0','G4K0','G4K1','G4K1','G5K0','G5K0','G5K1','G5K1','G6K0','G6K0','G6K1','G6K1','G7K0','G7K0','G7K1','G7K1','G8K0','G8K0','G8K1','G8K1','G9K0','G9K0','G9K1','G9K1','G10K0','G10K0','G10K1','G10K1','G11K0','G11K0','G11K1','G11K1','G12K0','G12K0','G12K1','G12K1','G13K0','G13K0','G13K1','G13K1','G14K0','G14K0','G14K1','G14K1','G15K0','G15K0','G15K1','G15K1','G31K0','G31K0','G31K1','G31K1','G32K0','G32K0','G32K1','G32K1','G33K0','G33K0','G33K1','G33K1')),

  Ulangan = factor(c(1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2)),

  VolumeAkarA = c(18.5,18.7,12.9,13.1,15.5,16.5,12.9,12.2,14.4,14,7.6,8.1,20.1,22.5,13.3,15.3,20.8,23.2,13.5,12.4,19.4,21.2,14,15.2,21.4,19.5,11.3,12.3,20.3,22.4,2.9,3.3,25.2,22.2,8.8,9.5,22.5,21,12.2,14,13.4,15.2,13.6,13.4,18.4,17.4,12.5,13.4,23.5,22.9,14.1,12.5,19.9,17.7,15.1,15.4,18.5,17.3,11.6,13.2,16.2,17.5,12.4,11.4,12.8,13.6,8.6,7.9,18.5,19.5,17.3,15.9)

)

sk_result <- SK(aov(VolumeAkarA ~ PerlakuanA + Ulangan, data = data))
summary(sk_result)
View(sk_result)

print(sk_result$out$Result)
