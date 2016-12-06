
####
setwd("/project/jnovembre/data/external_public/geodist/anno/")
tab <- read.csv("testsnps.annotations.csv")
table(tab[,5])

tab[which(tab[,4]==""),]

exonic_data <- tab[grep("exonic", tab[,4]),]
intergenic_data <- tab[grep("intergenic", tab[,4]),]

pooled_data <- rbind(exonic_data, intergenic_data);
save(pooled_data, file="/home/kkdey/hackathonDec2016/enrichment_analysis/data/exonic_intergenic_data.rda")

setwd("/project/jnovembre/data/external_public/geodist/anno/")
tab <- read.csv("testsnps.annotations.csv")
snp_ids <- tab[,3];

####  This file contains results only for Chr 22  #############

###  We extract the SNP records from the category file #########################

category_tab <- read.table("../1kg_phase3_snps.geodist5d4l.22.assign.tsv.gz");
snp_ids_category <- category_tab[,3]

matched_indices <- match(snp_ids, snp_ids_category)

combined_data <- cbind.data.frame(tab, category_tab[matched_indices,4:9])

exonic_data <- combined_data[grep("exonic", combined_data[,4]),]
intergenic_data <- combined_data[grep("intergenic", combined_data[,4]),]

pooled_data <- rbind(exonic_data, intergenic_data);

save(pooled_data, file="/home/kkdey/hackathonDec2016/enrichment_analysis/data/exonic_intergenic_data.rda")
