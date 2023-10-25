library(mcmc3r)

# change wd to dir with results from clock model selection

basepath <- getwd()

# number of bootstrap replicates
r <- 100

# categories to explode paths
clocks <- c("iln", "gbm")
caselength <- length(clocks)

clocks_v <- vector(mode="character", length=caselength)
logml_v <- vector(mode="character", length=caselength)
deltase_v <- vector(mode="character", length=caselength)
bootse_v <- vector(mode="character", length=caselength)
boot_l <- vector(mode="list", length=caselength)

iter <- 1

# iterate over combinations, calculate marginal lnL, and append to a df
for (cl in clocks){
    cat("Iteration ", iter, "\n", sep="")
    setwd(cl)
    cat(getwd(), "\n")
    # calculate marginal lnL and SE using the delta technique
    ststones <- mcmc3r::stepping.stones()
    clocks_v[iter] <- cl
    logml_v[iter] <- ststones$logml
    deltase_v[iter] <- ststones$se
    rm(ststones)
    # calculate the SE using the block bootstrap
    mcmc3r::block.boot(r)
    ststones.boot <- mcmc3r::stepping.stones.boot(r)
    bootse_v[iter] <- ststones.boot$se
    boot_l[iter] <- list(ststones.boot)
    print(warnings())
    rm(ststones.boot)
    # increase iterator
    iter <- iter+1
    setwd(basepath)
}

# save or load according to the needs, comment out the unneeded line
save(list=ls(), file="modsel_aa.Rda")

load("modsel_aa.Rda")

### correcting the vectors in character that should be numeric
logml_v <- as.numeric(logml_v)
bootse_v <- as.numeric(bootse_v)
deltase_v <- as.numeric(deltase_v)

# the results below are purely for inspection, not for writing to disk
results <- data.frame(clocks=clocks_v,
                      logml=logml_v,
		      deltase=deltase_v,
		      bootse=bootse_v)

# calculate posterior model probability and bayes factors, and create tables
modsel <- mcmc3r::bayes.factors(boot_l[[1]],
                                boot_l[[2]])

modsel_table <- data.frame(model=clocks,
                           logml=logml_v,
	                   se_delta=deltase_v,
			   se_boot=bootse_v,
			   bf=modsel$bf,
			   pr=modsel$pr,
			   pr.ci_lower=modsel$pr.ci[,1],
			   pr.ci_upper=modsel$pr.ci[,2])

# write tables to the disk
write.table(x=modsel_table, file="modesel.tsv", row.names=FALSE)