
####
setwd("/project/jnovembre/data/external_public/geodist/anno/")
tab <- read.csv("testsnps.annotations.csv")
table(tab[,5])

tab[which(tab[,4]==""),]

exonic_data <- tab[grep("exonic", tab[,4]),]
intergenic_data <- tab[grep("intergenic", tab[,4]),]

pooled_data <- rbind(exonic_data, intergenic_data);
save(pooled_data, file="/home/kkdey/hackathonDec2016/enrichment_analysis/data/exonic_intergenic_data.rda")
