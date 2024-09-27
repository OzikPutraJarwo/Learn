data <- data.frame(
  Galur = factor(c("G1K0","G1K1","G2K0","G2K1","G3K0","G3K1","G4K0","G4K1","G5K0","G5K1","G6K0","G6K1","G7K0","G7K1","G8K0","G8K1","G9K0","G9K1","G10K0","G10K1","G11K0","G11K1","G12K0","G12K1","G13K0","G13K1","G14K0","G14K1","G15K0","G15K1","G16K0","G16K1","G17K0","G17K1","G18K0","G18K1","G19K0","G19K1","G20K0","G20K1","G21K0","G21K1","G22K0","G22K1","G23K0","G23K1","G24K0","G24K0","G25K0","G25K1","G26K0","G26K1","G27K0","G27K1","G28K0","G28K1","G29K0","G29K1","G30K0","G30K1","G31K0","G31K1","G32K0","G32K1","G33K0","G33K1","G34K0","G34K1","G35K0","G35K1","G36K0","G36K1","G37K0","G37K1")),
  D3 = c(30,33,36,26,22,3,31,2,38,3,23,3,2,2,31,3,13,3,19,3,29,2,30,3,37,3,23,3,29,21,22,1,23,3,31,3,5,17,35,1,33,3,13,17,10,3,3,1,9,13,7,3,35,3,30,3,13,25,3,3,30,5,25,3,1,8,27,2,29,9,35,33,3,3),
  D5 = c(32,35,44,29,32,22,39,24,44,17,31,22,29,29,41,26,17,19,24,23,35,29,39,24,39,20,29,26,30,25,23,16,25,28,36,22,28,25,43,12,43,16,16,27,13,27,26,28,15,15,27,20,45,21,36,15,19,35,13,29,39,31,32,29,19,25,35,15,39,30,44,38,25,24),
  D15 = c(33,42,45,35,37,27,41,25,46,19,34,32,38,31,49,29,20,33,29,30,38,39,40,31,45,21,37,46,38,27,27,17,35,47,45,24,39,34,49,13,46,21,18,30,16,33,30,31,21,23,35,27,49,29,44,31,25,45,22,35,49,34,40,36,25,32,45,32,49,39,49,46,26,34)
)

###########################################

library(germinationmetrics)

germ.counts <- c(40, 4, 5)
intervals <- c(3,5,15)

CUG <- CUGerm(germ.counts = germ.counts, intervals = intervals, partial = TRUE)
print(CUG)

GI <- GermIndex(germ.counts = germ.counts, intervals = intervals, total.seeds = 50)
print(GI)

###########################################

library(GerminaR)

MGT <- ger_MGT(evalName = "D", data = data)
View(MGT)

###########################################

# Mengambil jumlah perkecambahan sebagai matriks
germ.counts <- as.matrix(data[, c("D3", "D5", "D15")])

# Mendefinisikan interval
intervals <- c(3, 5, 15)

GI_results <- apply(germ.counts, 1, function(counts) {
  GermIndex(germ.counts = counts, intervals = intervals, total.seeds = 50)
})

# Menghitung CUG untuk setiap galur
CUG_results <- apply(germ.counts, 1, function(counts) {
  CUGerm(germ.counts = counts, intervals = intervals, partial = TRUE)
})

# Menampilkan hasil dalam data frame
CUG_df <- data.frame(Galur = data$Galur, CUG = CUG_results)
print(CUG_df)

View(GI_results)
