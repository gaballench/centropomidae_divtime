library(mcmc3r)

b <- mcmc3r::make.beta(n=64, a=5, method="step-stones")

mcmc3r::make.bfctlf(b, ctlf="mcmctree.ctl", betaf="beta.txt")

q()
