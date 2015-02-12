data {
    int<lower=0> N;
    int<lower=0> M;
    int<lower=0> L;
    int<lower=0> K;
    int<lower=0, upper=1> y[N];
    matrix[N, M] x;
    int<lower=0> d[N];
    int<lower=0> t[N];
}
parameters {
    real alpha;
    vector[M] beta;
    real sigma_s;
    real sigma_q;
    real rs[L];
    real rq[K];
}
model {
//  alpha ~ normal(0, 1.0e+2);
//  beta ~ normal(0, 1.0e+2);
//  sigma ~ uniform(0, 1.0e+4);
  rs ~ normal(0, sigma_s);
  rq ~ normal(0, sigma_q);
  for (i in 1:N)
    y[i] ~ bernoulli(inv_logit(alpha + dot_product(x[i], beta) + rs[d[i]] + rq[t[i]]));
}
