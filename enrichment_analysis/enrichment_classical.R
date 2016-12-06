setwd("/home/kkdey/hackathonDec2016/enrichment_analysis/")
library(VGAM)
# load data
data(iris)
# fit model
input_vec <- rnorm(150, 2, 3);
fit <- vglm(Species ~ input_vec, family=multinomial, data=iris)

data <- get(load("data/exonic_intergenic_data.rda"))
levels <- droplevels(data$Func.refGene)
factor_values <- numeric();
factor_values[grep("exonic", levels)] = 1
factor_values[grep("intergenic", levels)] = 2

data_reduced <- cbind.data.frame(data$V4, factor_values)
colnames(data_reduced) <- c("categories", "levels")
data_reduced_1 <- data_reduced[c(1:5000, 16001:20000),]
fit <- vglm(categories ~ as.factor(levels), family=multinomial, data=data_reduced_1)

table_dist <- xtabs(~data_reduced$categories+ data_reduced$levels)
table_dist_prop <- t(apply(table_dist, 1, function(x) return(x/sum(x))))

original_prop <- (table(data_reduced$levels))/(sum(table(data_reduced$levels)))

expected_counts <- matrix(0, dim(table_dist)[1], dim(table_dist)[2])
for(m in 1:nrow(expected_counts)){
  expected_counts[m,] <- round(original_prop * rowSums(table_dist)[m],2)
}

chival <- sum((expected_counts - table_dist)^2/ expected_counts)
pchisq(chival, dim(expected_counts)[1]-1, lower=FALSE)

chisq.test(table_dist)

table_dist1 <- table_dist[which(rowSums(table_dist) > 5),];
table_dist1 <- table_dist[which(table_dist[,1] > 10 & table_dist[,2] > 10),];
chisq.test(table_dist1)

colnames(table_dist1) <- c("exonic", "intergenic")
