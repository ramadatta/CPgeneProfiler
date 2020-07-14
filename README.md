# CPgeneProfiler
Generate a profile of carbapenamase genes from the genome assemblies

## Author
[Prakki Sai Rama Sridatta](https://twitter.com/prakki_rama)

## Synopsis

1) **CPgeneProfiler** package checks for a list of CarbaPenamase (CP) genes from a list of
 genome assemblies provided in FASTA file format. The CP genes are derived from ARG-ANNOT
 database.
 
2) It reports the profile of all the CP genes available in the genome assemblies
 in the format of simple heatmap.
 
3) Apart from this, it also reports the presence of cocarriage of CP genes within
 an assembly. 
 
4) Other assembly statistics such as N50, N90, Assembly Size from the
 assembly are calculated and plots of length distribution of CP gene contigs from
 the list of assemblies are reported.  
 
 Currently the package works only on Unix systems.

  ## Quick Start
  
  A detailed step-by-step guide for the installation of dependencies and `CPgeneProfiler` is available in this [wiki page](https://github.com/ramadatta/CPgeneProfiler/wiki/Step-by-Step-Guide). 

### Step 1: Download CP gene database using R
```
# Specify CP gene database URL 
url <- "https://raw.githubusercontent.com/ramadatta/CPgene-profiler
/master/ARG-ANNOT_CPGene_DB.fasta"

# Specify destination where CP gene database file should be saved 
path <- "/home/user/db" # Can change to prefarable location
setwd(path)
destfile <- "ARG-ANNOT_CPGene_DB.fasta"

# Download the CP gene database file to the folder set in "path"
download.file(url, destfile)
```
### Step 2: Run the package
```
# Arguments: folder containing your reads, folder containing the CP gene database
% CPgeneProfiler("/path/Multiple_FastaFiles_Location/","/home/user/db/")
```

## Prior to CPgeneProfiler installation

- The following packages are supposed to be installed in R (>=3.5):

	 tidyverse,
	 UpSetR,
	 scales,
	 ape,
     BiocManager,
	 Biostrings,
	 reshape2,
	 gridExtra

```
install.packages(c("BiocManager", "tidyverse", "UpSetR", "scales", "ape", 
                    "reshape2", "gridExtra"))
BiocManager::install("Biostrings")

```

	 
- [NCBI BLAST+](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download) must be installed:

    Command line NCBI blast+ (program assumes blastn and makeblastdb commands are in path)
    
    Note: BLAST version 2.9.0+ was used for the present program although other BLAST+ similar to version 2.9.0+ parameters might also run without problems

## CPgeneProfiler Installation

Install devtools first, and then need to load them:
```
install.packages("devtools")
library(devtools)
```

Then install the CPgeneProfiler package using devtools. While installing, switching off to upgrade dependencies
```
devtools::install_github("ramadatta/CPgeneProfiler")
```

## Source
```
https://github.com/ramadatta/CPgeneProfiler
```

# Check installation
Ensure you have installed the package properly:
```
library(CPgeneProfiler)
?CPgeneProfiler
```
# Carbapenamase Gene Profiling

## Input Requirements
* A folder with multiple FASTA files (can be in multiple contigs)

## Output Files

* A folder "CPgeneProfiler_Output" with the following files

File | Description
----------|--------------
assemblyStats.txt | A simple text file with N50, N90, Assembly Size for each assembly
blastResults.filt.txt | Filtered blast results with contains contigs matching CPgenes with 100% identity and 100% coverage
blastResults.txt | Blast Results of contigs against the CP genes
Co-carriage_Report.txt | Information of Number of assemblies with the co-carriage broken down to category
CPContigSizeDist.txt | Contig Size distribution
CPgeneProfile.tiff | Carbapenamase Gene Profile in .tiff format
cp_presence-absence_matrix.csv | Presence-absence matrix of CP genes across assemblies
N50_N90.pdf | N50, N90 vs Assembly Size plot
NDM_Contig_Dist.tiff | NDM gene contig length distribution
KPC_Contig_Dist.tiff | KPC gene contig length distribution
OXA_Contig_Dist.tiff | OXA gene contig length distribution
upSetR.pdf | Set intersection plot of CP genes across all the input genome assemblies
DiffCP_DiffContig.txt | Information of assemblies with different CP genes present in different contigs
DiffCP_SameContig.txt | Information of assemblies with different CP genes present in same contigs 
SameCP_DiffContig.txt | Information of assemblies with same CP genes present in different contigs
SameCP_SameContig.txt | Information of assemblies with same CP genes present in same contigs

## Figures
<img src="https://user-images.githubusercontent.com/3212461/84586791-e28f2180-ae4c-11ea-9701-78f1983145ed.jpg" width="45%"></img> <img src="https://user-images.githubusercontent.com/3212461/84586928-c93aa500-ae4d-11ea-8f24-ff11f20a5cfe.jpg" width="45%"></img> <img src="https://user-images.githubusercontent.com/3212461/84586793-e622a880-ae4c-11ea-9037-0b245fb9d681.jpg" width="45%"></img> <img src="https://user-images.githubusercontent.com/3212461/84586795-e7ec6c00-ae4c-11ea-9d52-3d55abac4f7f.jpg" width="45%"></img> <img src="https://user-images.githubusercontent.com/3212461/84586923-c5a71e00-ae4d-11ea-9613-e8a3a7ddc921.jpg" width="45%"></img> <img src="https://user-images.githubusercontent.com/3212461/84586925-c8097800-ae4d-11ea-9ecc-687aa00c70da.jpg" width="45%"></img> 

Figures: 1) Carbapenamase Gene Profile (Top left) 2) Set intersection plot of CP genes across all the input genome assemblies (Top Right) 3-4) CP gene-containing contig length plots KPC (Middle left), OXA gene (Middle right) 5) Assembly Size vs N50 plot (Bottom left) 6) Assembly Size vs N90 plot (Bottom right)

## Version 
version 2.1.0

## References

Jake R Conway, Alexander Lex, Nils Gehlenborg, UpSetR: an R package for the visualization of intersecting sets and their properties, Bioinformatics, Volume 33, Issue 18, 15 September 2017, Pages 2938–2940, https://doi.org/10.1093/bioinformatics/btx364

Gupta, Sushim Kumar, et al. "ARG-ANNOT, a new bioinformatic tool to discover antibiotic resistance genes in bacterial genomes." Antimicrobial agents and chemotherapy 58.1 (2014): 212-220.

Bai Y, Müller DB, Srinivas G, Garrido-Oter R, Potthoff E, Rott M, Dombrowski N, Münch PC, Spaepen S, Remus-Emsermann M, Hüttel B, McHardy AC, Vorholt JA, Schulze-Lefert P. Functional overlap of the Arabidopsis leaf and root microbiota. Nature. 2015 Dec 2. doi: 10.1038/nature16192.
