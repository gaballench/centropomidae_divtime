seed = -1
seqfile = ../../../phylips/concatenated.phylip
treefile = ../../../startingTree.phylip
outfile = out

ndata = 5      * number of partitions
usedata = 2    * 0: no data; 1:seq like; 2:use in.BV; 3: out.BV
clock = 2      * 1: global clock; 2: independent rates; 3: correlated rates
RootAge = '<1.1'  * safe constraint on root age, used if no fossil for root.

model = 4    * 0:JC69, 1:K80, 2:F81, 3:F84, 4:HKY85
alpha = .5   * alpha for gamma rates at sites
ncatG = 5    * No. categories in discrete gamma

cleandata = 0    * remove sites with ambiguity data (1:yes, 0:no)?

BDparas = 1 1 0.1      * birth, death, sampling
kappa_gamma = 2 .2   * gamma prior for kappa
alpha_gamma = 2 4    * gamma prior for alpha

rgene_gamma = 2 20   * gamma prior for mean rates for genes
sigma2_gamma = 1 10  * gamma prior for sigma^2 (for clock=2 or 3)

print = 1
burnin = 4000
sampfreq = 2
nsample = 10000
BayesFactorBeta = 1e-300
