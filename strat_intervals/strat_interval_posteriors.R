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

### fit the root calibration to a normal as the one from
### the literature was roughly centered between 60--72Ma
root_params <- tbea::findParams(
                               q=c(60, mean(c(60, 72)), 72),
                               p=c(0.025, 0.5, 0.975),
                               pdfunction="pnorm",
                               params=c("mean", "sd"),
                               initVals=c(65,5))
root_params$par # mean and sd

# plot the specified calibrations using findParams
# they all represent the desired densities
plot(lognormalBeast(M=carangidae_params$par[1], S=carangidae_params$par[2], offset=carangidae.origin[2], meanInRealSpace=FALSE, from=0, to=150))

plot(lognormalBeast(M=centropomidae_params$par[1], S=centropomidae_params$par[2], offset=centropomidae_uniques.origin[2], meanInRealSpace=FALSE, from=0, to=20))

plot(lognormalBeast(M=istiophoridae_params$par[1], S=istiophoridae_params$par[2], offset=istiophoridae.origin[2], meanInRealSpace=FALSE, from=0, to=150))

plot(lognormalBeast(M=latidae_params$par[1], S=latidae_params$par[2], offset=latidae.origin[2], meanInRealSpace=FALSE, from=0, to=150))

plot(lognormalBeast(M=sphyraenidae_params$par[1], S=sphyraenidae_params$par[2], offset=sphyraenidae.origin[2], meanInRealSpace=FALSE, from=0, to=150))

##### plot the strat series plus the posterior on the origin

carangidae.origin.post <- abm38.v2(x=carangidae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)
centropomidae.origin.post <- abm38.v2(x=centropomidae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)
centropomidae_uniques.origin.post <- abm38.v2(x=unique(centropomidae$Mean.age), distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)
istiophoridae.origin.post <- abm38.v2(x=istiophoridae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)
latidae.origin.post <- abm38.v2(x=latidae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)
sphyraenidae.origin.post <- abm38.v2(x=sphyraenidae$midpoint_ma, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)

# plot the posteriors to be used as calibration priors
# NOTE: these require post_values=TRUE in the preceding block
# further manipulations to be done by hand using inkscape
pdf(file="strat_series.pdf", width=7, height=3.5*5)
par(mfrow=c(5,1))
plot(centropomidae_uniques.origin.post, xlim=c(0,150), type="l", lwd=1.5)
points(y=rep(0, length(unique(centropomidae$Mean.age))), x=unique(centropomidae$Mean.age), pch=21, bg="gray", cex=1.5)
plot(carangidae.origin.post, xlim=c(0,150), type="l", lwd=1.5)
points(y=rep(0, length(carangidae$Mean.age)), x=carangidae$Mean.age, pch=21, bg="gray", cex=1.5)
plot(istiophoridae.origin.post, xlim=c(0,150), type="l", lwd=1.5)
points(y=rep(0, length(istiophoridae$Mean.age)), x=istiophoridae$Mean.age, pch=21, bg="gray", cex=1.5)
plot(latidae.origin.post, xlim=c(0,150), type="l", lwd=1.5)
points(y=rep(0, length(latidae$Mean.age)), x=latidae$Mean.age, pch=21, bg="gray", cex=1.5)
plot(sphyraenidae.origin.post, xlim=c(0,150), type="l", lwd=1.5)
points(y=rep(0, length(sphyraenidae$midpoint_ma)), x=sphyraenidae$midpoint_ma, pch=21, bg="gray", cex=1.5)
dev.off()
