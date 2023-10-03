# read the estimator code
source("../Wang2016_ABM_2.R")

# read the data files
carangidae <- read.delim("Carangidae.tsv", stringsAsFactors=FALSE)
centropomidae <- read.delim("Centropomidae.tsv", stringsAsFactors=FALSE)
istiophoridae <- read.delim("Istiophoridae.tsv", stringsAsFactors=FALSE)
latidae <- read.delim("Latidae.tsv", stringsAsFactors=FALSE)

carangidae$Mean.age <- apply(X=carangidae[, c("Age.min", "Age.max")], MARGIN=1, FUN=mean)
centropomidae$Mean.age <- apply(X=centropomidae[, c("Age.min", "Age.max")], MARGIN=1, FUN=mean)
istiophoridae$Mean.age <- apply(X=istiophoridae[, c("Age.min", "Age.max")], MARGIN=1, FUN=mean)
latidae$Mean.age <- apply(X=latidae[, c("Age.min", "Age.max")], MARGIN=1, FUN=mean)

carangidae.origin <- abm38.v2(x=carangidae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)
centropomidae.origin <- abm38.v2(x=centropomidae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)
istiophoridae.origin <- abm38.v2(x=istiophoridae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)
latidae.origin <- abm38.v2(x=latidae$Mean.age, distance=FALSE, ext=FALSE, base=0.0, conf=0.95,PLOT=FALSE, post_values=TRUE)

# plot the posteriors with centropomidae
plot(centropomidae.origin, xlim=c(0,150), type="l")
lines(carangidae.origin, col="green")
lines(istiophoridae.origin, col="red")
lines(latidae.origin, col="blue")
legend(x="topright", legend=c("Centropomidae", "Carangidae", "Istiophoridae", "Latidae"), lty=1, col=c("black", "green", "red", "blue"))

# plot the posteriors without centropomidae
plot(centropomidae.origin, xlim=c(50,150), ylim=c(0, 0.03),  type="l")
lines(carangidae.origin, col="green")
lines(istiophoridae.origin, col="red")
lines(latidae.origin, col="blue")
legend(x="topright", legend=c("Centropomidae", "Carangidae", "Istiophoridae", "Latidae"), lty=1, col=c("black", "green", "red", "blue"))
