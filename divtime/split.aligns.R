taxa <- read.csv("taxa.tsv", header=FALSE)
seqs <- read.csv("concatenated.tsv", header=FALSE)

ch_12S <- c(1,832)
ch_16S <- c(833,1401)
ch_COI <- c(1402,2015)
ch_CYTB <- c(2016,2797)
ch_TMO <- c(2798,3234)

phylip_12S <- data.frame(taxa, "  ", seqs[,ch_12S[1]:ch_12S[2]])
phylip_16S <- data.frame(taxa, "  ", seqs[,ch_16S[1]:ch_16S[2]])
phylip_COI <- data.frame(taxa, "  ", seqs[,ch_COI[1]:ch_COI[2]])
phylip_CYTB <- data.frame(taxa, "  ", seqs[,ch_CYTB[1]:ch_CYTB[2]])
phylip_TMO <- data.frame(taxa, "  ", seqs[,ch_TMO[1]:ch_TMO[2]])

writeLines(c(paste("  ", nrow(taxa), "  ", length(ch_12S[1]:ch_12S[2])),
             apply(X=phylip_12S, MARGIN=1, FUN=paste, collapse="")),
           "phylips/12S.phylip")

writeLines(c(paste("  ", nrow(taxa), "  ", length(ch_16S[1]:ch_16S[2])),
             apply(X=phylip_16S, MARGIN=1, FUN=paste, collapse="")),
           "phylips/16S.phylip")

writeLines(c(paste("  ", nrow(taxa), "  ", length(ch_COI[1]:ch_COI[2])),
             apply(X=phylip_COI, MARGIN=1, FUN=paste, collapse="")),
           "phylips/COI.phylip")

writeLines(c(paste("  ", nrow(taxa), "  ", length(ch_CYTB[1]:ch_CYTB[2])),
             apply(X=phylip_CYTB, MARGIN=1, FUN=paste, collapse="")),
           "phylips/CYTB.phylip")

writeLines(c(paste("  ", nrow(taxa), "  ", length(ch_TMO[1]:ch_TMO[2])),
             apply(X=phylip_TMO, MARGIN=1, FUN=paste, collapse="")),
           "phylips/TMO.phylip")
