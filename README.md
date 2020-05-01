# CPgeneProfiler
Generate a profile of carbapenamase genes from the genome assemblies

## Author
[Prakki Sai Rama Sridatta](https://twitter.com/prakki_rama)

## DOI
[![DOI](https://zenodo.org/badge/257832752.svg)](https://zenodo.org/record/3767556)

## Synopsis

1) CPgeneProfiler package checks for a list of CarbaPenamase (CP) genes from a list of
 genome assemblies provided in fasta file format. The CP genes are derived from ARG-annot
 database.
 
2) It reports the profile of all the CP genes available in the genome assemblies
 in the format of simple heatmap.
 
3) Apart from this, it also reports the presence of co-carriage of CP genes within
 an assembly. 
 
4) Other assembly statistics such as N50, N90, Assembly Size from the
 assembly are calculated and plots of length distribution of CP gene contigs from
 the list of assemblies are reported.  
 
 Currently the package works only on Unix system.

![Example of graphics created using the CPgeneProfiler](CPgeneProfiler_Output.png)

  ## Quick Start
```
% CPgeneProfiler("/path/Folder_with_Fasta/")
```

# Installation

## 
Install devtools first, and then need to load them:
```
install.packages(devtools)
library(devtools)
```

Then install the CPgeneProfiler package using devtools. While installing, switching off to upgrade dependencies
```
devtools::install_github("ramadatta/CPgeneProfiler",dependencies = FALSE)
```


## Source
```
https://github.com/ramadatta/CPgeneProfiler
```

# Check installation
Ensure you have installed the package properly:
```
?CPgeneProfiler
```
# Carbapenamase Gene Profiling

## Input Requirements
* a folder with multiple FASTA files (can be in multiple contigs)

## Output Files

* a folder "CPgene-profiler_Output" with the following files

File | Description
----------|--------------
assemblyStats.txt | A simple text file with N50, N90, Assembly Size for each assembly
blastResults.filt.txt | Filtered blast results with contains contigs matching CPgenes with 100% identity and 100% coverage
blastResults.txt | Blast Results of contigs against the CP genes
Co-carriage_Report.txt | Information of Number of assemblies with the co-carriage broken down to category
CPContigSizeDist.txt | Contig Size distribution
CPgeneProfile.tiff | Carbapenamase Gene Profile in .tiff format
cp_presence-abence_matrix.csv | Presence-absence matrix of CP genes across assemblies
N50_N90.pdf | N50, N90 vs Assembly Size plot
NDM_Contig_Dist.tiff | NDM gene contig length distribution
KPC_Contig_Dist.tiff | KPC gene contig length distribution
OXA_Contig_Dist.tiff | OXA gene contig length distribution
upSetR.pdf | intersection plot of samples based on Carbapenamase genes
DiffCP_DiffContig.txt | Information of assemblies with different CP genes present in different contigs
DiffCP_SameContig.txt | Information of assemblies with different CP genes present in same contigs 
SameCP_DiffContig.txt | Information of assemblies with same CP genes present in different contigs
SameCP_SameContig.txt | Information of assemblies with same CP genes present in same contigs

## Requirements (R-packages)
   dplyr,
	 tidyverse,
	 UpSetR,
	 scales,
	 ape,
	 Biostrings,
	 reshape2,
	 gridExtra
	 
## Requirements (To be installed in Linux)
Command line NCBI blast+ (program assumes blastn and makeblastdb commands are in /usr/bin/)

## Version history

version 0.2.0

## References

Jake R Conway, Alexander Lex, Nils Gehlenborg, UpSetR: an R package for the visualization of intersecting sets and their properties, Bioinformatics, Volume 33, Issue 18, 15 September 2017, Pages 2938–2940, https://doi.org/10.1093/bioinformatics/btx364

Gupta, Sushim Kumar, et al. "ARG-ANNOT, a new bioinformatic tool to discover antibiotic resistance genes in bacterial genomes." Antimicrobial agents and chemotherapy 58.1 (2014): 212-220.
