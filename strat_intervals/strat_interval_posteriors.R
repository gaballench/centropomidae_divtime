# read the estimator code
source("../Wang2016_ABM_2.R")

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

carangidae.origin <- abm38.v2(x=carangidae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)
centropomidae.origin <- abm38.v2(x=centropomidae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)
centropomidae_uniques.origin <- abm38.v2(x=unique(centropomidae$Mean.age), distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)
istiophoridae.origin <- abm38.v2(x=istiophoridae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)
latidae.origin <- abm38.v2(x=latidae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)
sphyraenidae.origin <- abm38.v2(x=sphyraenidae$midpoint_ma, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)

# plot the posteriors to be used as calibration priors
plot(centropomidae_uniques.origin, xlim=c(0,150), ylim=c(0,0.18), type="l")
lines(carangidae.origin, col="green")
lines(istiophoridae.origin, col="red")
lines(latidae.origin, col="blue")
lines(sphyraenidae.origin, col="yellow")
legend(x="topright", legend=c("Centropomidae", "Carangidae", "Istiophoridae", "Latidae", "Sphyraenidae"), lty=1, col=c("black", "green", "red", "blue", "yellow"))
