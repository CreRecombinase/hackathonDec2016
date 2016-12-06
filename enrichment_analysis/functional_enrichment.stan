/* Stan Model : Full Bayes SNP Functional Enrichment Model
* Author: Kushal Kumar Dey
* -------------------------------------------------------
  * Date: 16th August, 2015
*/

/* epsilon[j] ~  N(0, sigma^2) 
 * theta[j] = mu + \sum_{k=1}^{K} beta [k] f[k,j]  + epsilon[j]
 * z[j] ~ mult (theta[j])
 */
 
 data {
         int<lower=1> N; //...  the sample size 
         int<lower=1> K; //... the number of mixing components 
         int<lower=0> z[N, K];  //... category labels (presence/absence)
         real f[N,K];
    }
    
 parameters{
        real<lower=0.1> sigma;
        vector[K] beta;
        real mu;
 }
 
 transformed parameters{
       vector[N] e;
       for(n in 1:N){
         e[n]=normal_rng(0, sigma);
       }
 }

 model{
    matrix[N,K] theta;
    
     for(n in 1:N){
         target += -0.5*(e[n]-0) / square(sigma);
          for(k in 1:K){
              theta[n, k] = inv_logit(mu + beta[k]*f[n,k] + e[n]);
        //      if(theta[n,k] < 0.00001){
        //          theta[n,k] = 0.00001;
        //     }
          }
       theta[n] = theta[n]/sum(theta[n]);
      // z[n] ~ multinomial(to_vector(theta[n]));
      //target += multinomial_log(z[n], to_vector(theta[n]));
      target += sum(- (to_vector(z[n]))*log(theta[n]));
     }
 }

         
          