library(ape)
library(tbea)

tree <- read.nexus("../mrbayes/posterior_maxcred.tre")

tree <- root(phy=tree, outgroup="Nematistius_pectoralis", resolve.root=TRUE)

# determine the node IDs to calibrate
carangidae_id <- mrca(tree)["Gnathanodon_speciosus", "Caranx_caninus"]
centropomidae_id <- mrca(tree)["Centropomus_mexicanus", "Centropomus_armatus"]
istiophoridae_id <- mrca(tree)["Xiphias_gladius", "Istiophorus_platypterus"]
latidae_id <- mrca(tree)["Lates_japonicus", "Hypopterus_macropterus"]
sphyraenidae_id <- mrca(tree)["Sphyraena_jello", "Sphyraena_helleri"]
root_id <- mrca(tree)["Nematistius_pectoralis", "Sphyraena_waitii"]

### the calibrations need to be consistent with the following min-max intervals, from ../strat_intervals/strat_interval_posteriors.R
#> carangidae.origin[c(2,3)] # min-max for init tree
#[1]  51.9000 126.5846
#> centropomidae_uniques.origin[c(2,3)] # min-max for init tree
#[1]  8.48000 27.31171
#> istiophoridae.origin[c(2,3)] # min-max for init tree
#[1] 57.60000 92.31767
#> latidae.origin[c(2,3)] # min-max for init tree
#[1]  51.900 145.626
#> sphyraenidae.origin[c(2,3)] # min-max for init tree
#[1] 53.05000 56.72119
calibs <- data.frame(node=c(carangidae_id, centropomidae_id, istiophoridae_id, latidae_id, sphyraenidae_id, root_id),
                     age.min=c(51.9000, 8.48000, 57.60000, 51.900, 53.05000, ROOTMIN),
                     age.max=c(126.5846, 27.31171, 92.31767, 145.626, 56.72119, ROOTMAX),
                     stringsAsFactors=FALSE)

calibrated <- ape::chronos(phy = tree, calibration = calibs)
# write the starting tree
write.tree(phy = calibrated, file = "startingTree.newick")

### the calibrations for beast2: lognormal values, from ../strat_intervals/strat_interval_posteriors.R:
# all as mean in real space = false
#> carangidae_params$par # meanlog and sdlog
#[1] 3.5759607 0.4483266
#> carangidae.origin[2] # offset
#[1] 51.9
#> centropomidae_params$par # meanlog and sdlog
#[1] 0.5441571 1.4538764
#> centropomidae_uniques.origin[2] # offset
#[1] 8.48
#> istiophoridae_params$par # meanlog and sdlog
#[1] 1.775708 1.077184
#> istiophoridae.origin[2] # offset
#[1] 57.6
#> latidae_params$par # meanlog and sdlog
#[1] 2.9310483 0.9782168
#> latidae.origin[2] # offset
#[1] 51.9
#> sphyraenidae_params$par # meanlog and sdlog
#[1] -0.4341425  1.0547216
#> sphyraenidae.origin[2] # offset
#[1] 53.05
