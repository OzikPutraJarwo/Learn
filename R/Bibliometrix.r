library(bibliometrix)
wos_data<-convert2df("R/assets/wos.txt")
Scopus_Data<-convert2df("R/assets/scopus.bib",dbsource = "scopus",format = "bibtex")
combined<-mergeDbSources(wos_data,Scopus_Data, remove.duplicated = T)

# library(xlsx)
# write.xlsx(combined,"combined.xlsx")

library(openxlsx)
write.xlsx(combined, file = "R/assets/Biblio Combined.xlsx")

biblioshiny()