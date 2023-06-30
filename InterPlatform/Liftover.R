######MethyLiftover########
#
# Load packages
library(IlluminaHumanMethylation450kanno.ilmn12.hg19)
library(data.table)
#
#
#
##Gather Illumina annotation information and compile into a table
illumDataFrame <- IlluminaHumanMethylation450kanno.ilmn12.hg19::Locations
illumDataFrame <- cbind(illumDataFrame, 
                        IlluminaHumanMethylation450kanno.ilmn12.hg19::Islands.UCSC,
                        IlluminaHumanMethylation450kanno.ilmn12.hg19::Manifest$Type,
                        IlluminaHumanMethylation450kanno.ilmn12.hg19::Other$UCSC_RefGene_Name,
                        IlluminaHumanMethylation450kanno.ilmn12.hg19::Other$UCSC_RefGene_Accession)
illumDataFrame$probe <- rownames(illumDataFrame)
illumDataFrame <- as.data.frame(illumDataFrame)
#
#
#
#
#
# Load in BS-Seq data:
WGBS_BetaValues <- read.delim("WGBS_MB/data/RandomSubsetWGBS.txt") #Randomly subset WGBS dataset containing 100,000 CpGs - 1816 of which map to the 450k manifest.
# Make sure both matrices are data.frame objects
WGBS_BetaValues <- as.data.frame(WGBS_BetaValues)
#
#
#
#Merge WGBS matrix with the Array Probe Manifest - This keeps ONLY the sites that correspond to those on the 450k microarray
#
Liftover_BetaValues <- merge(x = illumDataFrame,
                             y = WGBS_BetaValues,
                             by.x = c('chr', 'pos'), #Corresponds to Chromosome and start
                             by.y = c('Chromosome', 'Start')) #Change this if your chromosome and start columns are named slightly differently
#
# Set Probe IDs as rows
rownames(Liftover_BetaValues) <- Liftover_BetaValues$probe
#
# Cleanup columns as needed, but now you have a BS-Seq beta value matrix containing CpG beta values that map to the 
# Illumina 450k manifest.
#
#
# End of Script.
