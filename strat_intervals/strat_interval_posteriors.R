# read the estimator code
source("../Wang2016_ABM_2.R")
library(tbea)

# read the data files
carangidae <- read.delim("Carangidae.tsv", stringsAsFactors=FALSE)

centropomidae <- read.delim("Centropomidae.tsv", stringsAsFactors=FALSE)
# subsample centropomidae in order to avoid using duplicate occurrences
rm_centro_codes <- c("C004", "C026", "C001", "C023", "C025", "C022", "C024", "C020", "C015")
rm_centro_idx <- centropomidae$Index %in% rm_centro_codes
centropomidae <- centropomidae[!(rm_centro_idx), ]

istiophoridae <- read.delim("Istiophoridae.tsv", stringsAsFactors=FALSE)

latidae <- read.delim("Latidae.tsv", stringsAsFactors=FALSE)

sphyraenidae <- read.csv("Sphyraenidae.csv", stringsAsFactors=FALSE)

carangidae$Mean.age <- apply(X=carangidae[, c("Age.min", "Age.max")], MARGIN=1, FUN=mean)
centropomidae$Mean.age <- apply(X=centropomidae[, c("Age.min", "Age.max")], MARGIN=1, FUN=mean)
istiophoridae$Mean.age <- apply(X=istiophoridae[, c("Age.min", "Age.max")], MARGIN=1, FUN=mean)
latidae$Mean.age <- apply(X=latidae[, c("Age.min", "Age.max")], MARGIN=1, FUN=mean)
# sphyraenidae midages are already calculated from the python data cleaning

carangidae.origin <- abm38.v2(x=carangidae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=FALSE)
centropomidae.origin <- abm38.v2(x=centropomidae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=FALSE)
centropomidae_uniques.origin <- abm38.v2(x=unique(centropomidae$Mean.age), distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=FALSE)
istiophoridae.origin <- abm38.v2(x=istiophoridae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=FALSE)
latidae.origin <- abm38.v2(x=latidae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=FALSE)
sphyraenidae.origin <- abm38.v2(x=sphyraenidae$midpoint_ma, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=FALSE)

# find the params mu and sigma of the lognormal transposed to the origin rather than the max occurrence
carangidae_params <- tbea::findParams(
                               q=(carangidae.origin[c(2, 1, 3)] - carangidae.origin[2]),
                               p=c(0.0, 0.5, 0.95),
                               pdfunction="plnorm",
                               params=c("meanlog", "sdlog"),
                               initVals=c(0.5,0.5))
carangidae_params$par # meanlog and sdlog
carangidae.origin[2] # offset
carangidae.origin[c(2,3)] # min-max for init tree

centropomidae_params <- tbea::findParams(
                               q=(centropomidae_uniques.origin[c(2, 1, 3)] - centropomidae_uniques.origin[2]),
                               p=c(0.0, 0.5, 0.95),
                               pdfunction="plnorm",
                               params=c("meanlog", "sdlog"),
                               initVals=c(0.5,0.5))
centropomidae_params$par # meanlog and sdlog
centropomidae_uniques.origin[2] # offset
centropomidae_uniques.origin[c(2,3)] # min-max for init tree

istiophoridae_params <- tbea::findParams(
                               q=(istiophoridae.origin[c(2, 1, 3)] - istiophoridae.origin[2]),
                               p=c(0.0, 0.5, 0.95),
                               pdfunction="plnorm",
                               params=c("meanlog", "sdlog"),
                               initVals=c(0.5,0.5))
istiophoridae_params$par # meanlog and sdlog
istiophoridae.origin[2] # offset
istiophoridae.origin[c(2,3)] # min-max for init tree

latidae_params <- tbea::findParams(
                               q=(latidae.origin[c(2, 1, 3)] - latidae.origin[2]),
                               p=c(0.0, 0.5, 0.95),
                               pdfunction="plnorm",
                               params=c("meanlog", "sdlog"),
                               initVals=c(0.5,0.5))
latidae_params$par # meanlog and sdlog
latidae.origin[2] # offset
latidae.origin[c(2,3)] # min-max for init tree

sphyraenidae_params <- tbea::findParams(
                               q=(sphyraenidae.origin[c(2, 1, 3)] - sphyraenidae.origin[2]),
                               p=c(0.0, 0.5, 0.95),
                               pdfunction="plnorm",
                               params=c("meanlog", "sdlog"),
                               initVals=c(0.5,0.5))
sphyraenidae_params$par # meanlog and sdlog
sphyraenidae.origin[2] # offset
sphyraenidae.origin[c(2,3)] # min-max for init tree

# plot the specified calibrations using findParams
# they all represent the desired densities
plot(lognormalBeast(M=carangidae_params$par[1], S=carangidae_params$par[2], offset=carangidae.origin[2], meanInRealSpace=FALSE, from=0, to=150))

plot(lognormalBeast(M=centropomidae_params$par[1], S=centropomidae_params$par[2], offset=centropomidae_uniques.origin[2], meanInRealSpace=FALSE, from=0, to=20))

plot(lognormalBeast(M=istiophoridae_params$par[1], S=istiophoridae_params$par[2], offset=istiophoridae.origin[2], meanInRealSpace=FALSE, from=0, to=150))

plot(lognormalBeast(M=latidae_params$par[1], S=latidae_params$par[2], offset=latidae.origin[2], meanInRealSpace=FALSE, from=0, to=150))

plot(lognormalBeast(M=sphyraenidae_params$par[1], S=sphyraenidae_params$par[2], offset=sphyraenidae.origin[2], meanInRealSpace=FALSE, from=0, to=150))

# plot the posteriors to be used as calibration priors
# NOTE: these require post_values=TRUE in the preceding block
#plot(centropomidae_uniques.origin, xlim=c(0,150), ylim=c(0,0.18), type="l")
#lines(carangidae.origin, col="green")
#lines(istiophoridae.origin, col="red")
#lines(latidae.origin, col="blue")
#lines(sphyraenidae.origin, col="yellow")
#legend(x="topright", legend=c("Centropomidae", "Carangidae", "Istiophoridae", "Latidae", "Sphyraenidae"), lty=1, col=c("black", "green", "red", "blue", "yellow"))
