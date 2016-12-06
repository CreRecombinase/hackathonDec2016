setwd("/home/kkdey/hackathonDec2016/enrichment_analysis/")
library(VGAM)
# load data
data(iris)
# fit model
input_vec <- rnorm(150, 2, 3);
fit <- vglm(Species ~ input_vec, family=multinomial, data=iris)
