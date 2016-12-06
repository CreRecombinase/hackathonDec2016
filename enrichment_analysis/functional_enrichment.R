

########  MCMC runs on the functional enrichment data ######################

N <- 1000
K <- 10;
fmat <- matrix(rnorm(N*K, 0, 1), nrow=N);
Z <- matrix(0, N, K);
e <- matrix(0, N, K);

mu = 0;
beta = rep(3,K);
library(boot)

for(n in 1:N){
  e[n,] <- rnorm(K,0,1)
  Z[n,] <-  rmultinom(1, 1, prob=inv.logit(mu + beta*fmat[n,] + e[n,]))
}

######## Fit the model into STAN

test.funcenrich <- list(N=N,
                 K=K,
                 z = Z,
                 f = fmat);

fit1 <- stan(file="functional_enrichment.stan", 
             data=test.funcenrich, 
             chains=2,
             iter = 5000,
             init = "random",
             cores = parallel::detectCores());






