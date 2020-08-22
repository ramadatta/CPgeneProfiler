---
output:
  html_document: default
  pdf_document: default
---
# CPgeneProfiler
Generate a profile of carbapenamase genes from the genome assemblies

## Author
[Prakki Sai Rama Sridatta](https://twitter.com/prakki_rama)

##### **Synopsis**

1) **CPgeneProfiler** package checks for a list of CarbaPenamase (CP) genes from a list of
 genome assemblies provided in FASTA file format. The CP genes are derived from NCBI 
 Bacterial Antimicrobial Resistance Reference Gene Database.
 
2) It reports the profile of all the CP genes available in the genome assemblies
 in the form of simple heatmap.
 
3) Apart from this, it also reports the presence of cocarriage of CP genes within
 an assembly. 
 
4) Other assembly statistics such as N50, N90, Assembly Size from the
 assembly are calculated and plots of length distribution of CP gene contigs from
 the list of assemblies are reported.  
 
 Currently the package works only on Unix systems.
 
 
##### **Input Requirements**
* Path of a directory with multiple FASTA files (can be in multiple contigs) 
* Path of Carbapenamase Gene Database file (FASTA) directory

 
##### **Requirements**

- **R packages (REQUIRED):**
	 tidyverse,
	 UpSetR,
	 scales,
	 ape,
	 BiocManager,
	 Biostrings,
	 reshape2,
	 gridExtra
	 png, 
	 tiff,
	 jpeg,
	 pdftools,
	 grid
	 
Install these packages using R (>=3.5):
	
``` r
install.packages(c("BiocManager", "tidyverse", "UpSetR", "scales", "ape", 
                    "reshape2", "gridExtra","png", "tiff", "jpeg", "pdftools", "grid"))

BiocManager::install("Biostrings")
```	 

- **External software (REQUIRED):** [NCBI BLAST 2.9.0+](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download)
   
	- Go to page: https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.9.0/

	- Save `ncbi-blast-2.9.0+-x64-linux.tar.gz` in the local directory

	- To install, simply extract the downloaded package using the following command

	```
	tar zxvpf ncbi-blast-2.9.0+-x64-linux.tar.gz
	```

	- Configure of NCBI BLAST+ executables using the following command. This would append the path to the new BLAST bin directory to the existing PATH setting.


	```
	export PATH=$PATH:$HOME/ncbi-blast-2.9.0+/bin
	```
	
	- Refer [here](https://www.ncbi.nlm.nih.gov/books/NBK52640/) for source documentation

	  Note 1: R package assumes `blastn` and `makeblastdb` files are in path
    
 	  Note 2: BLAST version 2.9.0+ was used for the present program although other BLAST+ similar to version 2.9.0+ parameters might also run without problems
    
- **CP gene Database Download (REQUIRED)**

	- Go to the UNIX/Linux command line terminal and download the `db` folder with SVN

	```
	svn export https://github.com/ramadatta/CPgeneProfiler/trunk/testData/db
	```
	
	- else simply [Click](https://downgit.github.io/#/home?url=https://github.com/ramadatta/CPgeneProfiler/tree/master/testData/db) to save database folder and uncompress the `db.zip` folder.    
    
#### **Installation**

##### **From Github**

The R package is available through github repository can be installed using devtools.

``` r 
install.packages("devtools")
devtools::install_github("ramadatta/CPgeneProfiler")
```

##### **Check installation**
Ensure you have installed the package properly:

``` r
library("CPgeneProfiler")
?CPgeneProfiler
```

### **Example Usage**
 
`CPgeneProfiler` package can be run using the following functions: `cpblast()`, `filt_blast()`, `cocarriage()`, `cpprofile()`, `upsetR_plot()`, `plot_conlen()`,`assemblystat()`, `cp_summarize()`, `db_summary()`. Below are the examples of `CPgeneProfiler` commands usage. 


- Generates NCBI BLAST Results by aligning input genome assemblies against Carbapenamase (CP) gene database

``` r
cpblast(fastalocation = "/home/user/CPgeneProfiler/testData/fasta", dblocation = "/home/user/CPgeneProfiler/testData/db")

```
- Filtering NCBI BLAST Results based on CP gene coverage and percent identity. By default, alignment coverage of CP gene (`cpgcov`) and percentage identity (`cpgpident`) are set to 100%.

``` r
filt_blast(cpgcov = 100, cpgpident = 100)
```

- Report cocarriage of CP genes across all the input genome assemblies (Default:`cpgcov = 100` and `cpgpident = 100`)

``` r
cocarriage(cpgcov = 100, cpgpident = 100)
```

- Generate CP gene Profile across all the input genome assemblies (Default:`cpgcov = 100` and `cpgpident = 100`)

``` r
cpprofile(xlab = "Carbapenamase Genes", ylab = "Assembly", title = "Carbapenamase Gene Profile Heatmap")
```

- Plot CP gene contig length distributions across all the input genome assemblies (Default:`cpgcov = 100` and `cpgpident = 100`)

``` r
plot_conlen(outputType = "png", xlab = "Contig Length", ylab = "Number of Contigs", title = " Contig Length Distribution", colorfill = "#F99245")
```

- Generate basic assembly statistics such N50, N90 and Assembly Size and plots comparing Assembly Size with N50, N90 stats

``` r
assemblystat(fastalocation = "/home/user/CPgeneProfiler/testData/fasta")
```

- Summarize the plots and organize all the output files in specific folders

``` r
cp_summarize(outdir_loc = "/home/user/Desktop", outdir = "CPgeneProfiler_Output")
```

- Database information

``` r
db_summary()
```

### **Working with `testData`**

#### **Test Data Download**

To test the package with test input data, Go to the UNIX/Linux command line terminal and download the `fasta` folder with SVN

```
svn export https://github.com/ramadatta/CPgeneProfiler/trunk/testData/fasta
```
else simply [Click](https://downgit.github.io/#/home?url=https://github.com/ramadatta/CPgeneProfiler/tree/master/testData/fasta) to save fasta folder and uncompress the `fasta.zip` folder.


##### **Step 1: A simple NCBI BLAST using `cpblast()` command**

As a first step, CPgeneProfiler generates NCBI BLAST Results by aligning input genome assemblies against Carbapenamase (CP) gene database. Now that you already have a directory with fasta files (should have extensions `.fasta` or `.fa`) in `fasta` folder and cp gene database sequence in `db` folder, you can specify the path of both directories as an input and run the package with `cpblast()` command.

``` r
cpblast(fastalocation = "/home/user/CPgeneProfiler/testData/fasta", dblocation = "/home/user/CPgeneProfiler/testData/db", num_threads = 4, evalue = "1e-3")
```
The users can adjust BLAST parameters `num_threads`, `evalue`, `word_size` and `max_target_seqs` accordingly. If not adjusted and command is simply executed with the file locations for `fasta` and `db`, then default parameters are used for the analysis.


##### **Step 2: Filtering BLAST results using `filt_blast()` command**

`filt_blast()` then filters the output BLAST results obtained from `cpblast()` command. This filtering is to find the presence of CP genes given a particular CP gene coverage and Percentage Identity. Therefore, the BLAST hits are filtered based on CP gene coverage and Percentage Identity. By default, CP Gene Coverage and Percentage Identity are set at a threshold of 100% (cpgcov=100, cpgpident=100). This means that a CP gene should have 100% alignment length and 100% identity, without even a single mismatch with the input genome sequence. The default parameters can be adjusted.

``` r
filt_blast(cpgcov = 100, cpgpident = 100)
```

This should generate the following table:

| assemblyName     | qseqid                                    | sseqid  | qlen   | slen | qstart | qend   | length | pident | cov |
|------------------|-------------------------------------------|---------|--------|------|--------|--------|--------|--------|-----|
| genome_001.fasta | 4_length=71861_depth=1.95x_circular=true  | KPC-2   | 71861  | 918  | 3810   | 4727   | 918  | 100 | 100 |
| genome_001.fasta | 5_length=71851_depth=1.95x_circular=true  | KPC-2   | 71851  | 918  | 3810   | 4727   | 918  | 100 | 100 |
| genome_002.fasta | 5_length=51479_depth=1.31x_circular=true  | OXA-181 | 51479  | 998  | 31280  | 32277  | 998  | 100 | 100 |
| genome_003.fasta | 2_length=316292_depth=2.71x_circular=true | NDM-1   | 316292 | 1013 | 149582 | 150594 | 1013 | 100 | 100 |
| genome_003.fasta | 2_length=316292_depth=2.71x_circular=true | OXA-181 | 316292 | 998  | 49123  | 50120  | 998  | 100 | 100 |
| genome_004.fasta | 3_length=66727_depth=0.76x                | OXA-181 | 66727  | 998  | 49850  | 50847  | 998  | 100 | 100 |
| genome_004.fasta | 3_length=66727_depth=0.76x                | OXA-181 | 66727  | 998  | 43441  | 44438  | 998  | 100 | 100 |
| genome_004.fasta | 3_length=66727_depth=0.76x                | OXA-181 | 66727  | 998  | 37032  | 38029  | 998  | 100 | 100 |
| genome_005.fasta | 2_length=79441_depth=2.21x_circular=true  | KPC-2   | 79441  | 918  | 11390  | 12307  | 918  | 100 | 100 |
| genome_005.fasta | 2_length=79441_depth=2.21x_circular=true  | KPC-2   | 79441  | 918  | 3810   | 4727   | 918  | 100 | 100 |
| genome_007.fasta | 2_length=246497_depth=2.06x_circular=true | KPC-2   | 246497 | 918  | 178390 | 179307 | 918  | 100 | 100 |
| genome_007.fasta | 2_length=246497_depth=2.06x_circular=true | IMP-26  | 246497 | 861  | 145325 | 146185 | 861  | 100 | 100 |
| genome_008.fasta | 3_length=41186_depth=4.61x_circular=true  | NDM-1   | 41186  | 1013 | 23027  | 24039  | 1013 | 100 | 100 |
| genome_009.fasta | 4_length=41182_depth=4.10x_circular=true  | NDM-1   | 41182  | 1013 | 23023  | 24035  | 1013 | 100 | 100 |
| genome_010.fasta | 5_length=51479_depth=1.31x_circular=true  | OXA-181 | 51479  | 998  | 31280  | 32277  | 998  | 100 | 100 |
| genome_010.fasta | 3_length=41186_depth=4.61x_circular=true  | NDM-1   | 41186  | 1013 | 23027  | 24039  | 1013 | 100 | 100 |
| genome_012.fasta | 2_length=79441_depth=2.21x_circular=true  | KPC-2   | 79441  | 918  | 11390  | 12307  | 918  | 100 | 100 |
| genome_012.fasta | 2_length=79441_depth=2.21x_circular=true  | KPC-2   | 79441  | 918  | 3810   | 4727   | 918  | 100 | 100 |
| genome_013.fasta | 3_length=41186_depth=4.61x_circular=true  | NDM-1   | 41186  | 1013 | 23027  | 24039  | 1013 | 100 | 100 |
| genome_014.fasta | 4_length=41182_depth=4.10x_circular=true  | NDM-1   | 41182  | 1013 | 23023  | 24035  | 1013 | 100 | 100 |
| genome_015.fasta | 3_length=66727_depth=0.76x                | OXA-181 | 66727  | 998  | 49850  | 50847  | 998  | 100 | 100 |
| genome_015.fasta | 3_length=66727_depth=0.76x                | OXA-181 | 66727  | 998  | 43441  | 44438  | 998  | 100 | 100 |
| genome_015.fasta | 3_length=66727_depth=0.76x                | OXA-181 | 66727  | 998  | 37032  | 38029  | 998  | 100 | 100 |

##### **Step 3c: Finding cocarriage genes using `cocarriage()` command**

`cocarriage()` command finds if two or more CP genes exists in same contig or multiple contigs across all the input genome assemblies. This function can be used only after running `filt_blast()`. By default parameters, CP Gene Coverage and Percentage Identity are set to 100% (cpgcov=100, cpgpident=100) and can be adjusted.

``` r
cocarriage(cpgcov = 100, cpgpident = 100)
```

##### **Step 3d: Finding CP gene profile using `cpprofile()` command**

`cpprofile()` creates a heatmap of CP gene profile across the input genome assemblies. By default, the command generates `png` image but user play with other output formats (jpeg/tiff/pdf) and parameters such as width, height of image, label, titles and colors of the heatmap.

``` r
cpprofile(outputType="png", width = 2000, height = 2000, res = 250, xlab="Carbapenamase Genes", ylab="Assembly", title="Carbapenamase Gene Profile Heatmap", titlesize=15, labelsize=12, colorcode_low = "#143D59", colorcode_high = "#F4B41A", cpgcov=100, cpgpident=100)
```
<p align="center">
<img src="https://user-images.githubusercontent.com/3212461/90124487-10cca700-dd93-11ea-9572-dfc44a190dd6.png" width="45%"></img> 
</p>

##### **Step 3e: Plot CP gene contig length distribution using `plot_conlen()` command**

`plot_conlen()` generates length distribution for all the CP gene contigs present across all the input genome assemblies.By default, the command generates `png` image but user play with other output formats (jpeg/tiff/pdf) and parameters such as width, height of image, label, titles and colors.

``` r
plot_conlen(outputType="tiff", width = 700, height = 700, res = 150, xlab="Contig Length", ylab="Number of Contigs", title=" Contig Length Distribution",element_text_angle=90,unit="KB", breaks=15, colorfill = "#F99245",cpgcov=100, cpgpident=100)
```
<p align="center">
<img src="https://user-images.githubusercontent.com/3212461/90124507-17f3b500-dd93-11ea-9f37-6167ec79b8a1.png" width="45%"></img> 
<img src="https://user-images.githubusercontent.com/3212461/90124510-188c4b80-dd93-11ea-8609-1d3fbfc3ef43.png" width="45%"></img>
</p>

##### **Step 3f: Generate assembly statistics using `assemblystat()` command**

`assemblystat()` generates basic assembly stats which includes N50 size, N90 size and Genome assembly size. This function also generates Assembly Size vs N50 plot and Assembly Size vs N90 plot. This function requires the location of fasta file directory. By default, the command generates `png` image plots.

``` r
assemblystat("/home/user/CPgeneProfiler/testData/fasta", outputType="png", width = 700, height = 700, res = 150, geom_point_size=3, n50colorfill = "#0072B2", n90colorfill = "#D55E00")
```
<p align="center">
<img src="https://user-images.githubusercontent.com/3212461/90954281-a825ae80-e4a5-11ea-863d-47678a00aba1.png" width="45%"></img> 
<img src="https://user-images.githubusercontent.com/3212461/90954280-a6f48180-e4a5-11ea-93ad-908e0e339674.png" width="45%"></img>
</p>

##### **Step 3g: Generate Set Intersection of CP genes using `upsetR_plot()` command**

`upsetR_plot()` generates set intersection plot of CP genes across all the input genome assemblies. By default, the command generates `png` image but user can change the output image type, width and height of image, label, titles and colors.

``` r
upsetR_plot(outputType="png", width = 2000, height = 2000, res = 250, xlab="Carbapenamase Gene Set Size", ylab="Number of genome assemblies",cpgcov=100, cpgpident=100, order.by = "degree",nsets = 40, number.angles = 0,point.size = 1.5, line.size = 1,sets.bar.color = "red")
```
<p align="center">
<img src="https://user-images.githubusercontent.com/3212461/90124536-1f1ac300-dd93-11ea-9acc-9435b79a7f1c.png" width="45%"></img> 
</p>

##### **Step 3h: Summarize all the results using `cp_summarize()` command**

`cp_summarize()` arranges all the output files generated from above commands into respective folders. This also creates a summary of all the plots from CPgeneProfiler output into a single PDF file. Users can specify the output directory name and summary pdf name and also can provide the location of where the output folder to be generated. Note: All the output image plots need to be in the same format i.e, either png/tiff/jpeg.

``` r
cp_summarize(outdir = "CPgeneProfiler_Output", report="Summary" , image = "png")
```

##### **Step 3i: Find Database summary details using `db_summary()` command**

`db_summary()` command displays the details of Database, which includes Database Name, Database Version, Total sequences in Databases, Date on which database was created, Database Reference location from where sequences are downloaded.

``` r
db_summary()
```

##### **Output Files**

* A folder "CPgeneProfiler_Output" with the following files in respective directories

Command | File | Description
--------|------|--------------
cpblast() | blastResults.txt | Blast Results of contigs against the CP genes
filt_blast() | blastResults.filt.txt | Filtered blast results with contains contigs matching CP genes (default: 100% identity and 100% coverage)
cocarriage() | Cocarriage_Report.txt | Information of Number of assemblies with the co-carriage broken down to category
cocarriage() | Cocarriage_combinedResults.txt | Combined cocarriage details across all the assemblies
cocarriage() | DiffCP_DiffContig.txt | Information of assemblies with different CP genes present in different contigs
cocarriage() | DiffCP_SameContig.txt | Information of assemblies with different CP genes present in same contigs 
cocarriage() | SameCP_DiffContig.txt | Information of assemblies with same CP genes present in different contigs
cocarriage() | SameCP_SameContig.txt | Information of assemblies with same CP genes present in same contigs
cpprofile() | CPgeneProfile.png | Carbapenamase Gene Profile (default:png)
plot_conlen() | CPContigSizeDist.txt | Contig Size distribution
plot_conlen() | "CPGene"_Contig_Dist.png | CP gene contig length distribution (for each CP gene a separate distribution plot is generated. Default image format: png)
upsetR_plot() | cp_presence-absence_matrix.csv | Presence-absence matrix of CP genes across assemblies
upsetR_plot() | upset_plot.pdf | Set intersection plot of CP genes across all the input genome assemblies
assemblystat() | N50_N90.pdf | Assembly Size vs N50, N90 plots
assemblystat() | assemblyStats.txt | A simple text file with N50, N90, Assembly Size for each assembly
cp_summarize() | SummaryPlots.pdf | All the plots in a single pdf file

## A few example plots 

# `CP Gene Profile HeatMap`
<img src="https://user-images.githubusercontent.com/3212461/90596495-a946a980-e221-11ea-9904-88d5b5c66cc7.png" width="45%"></img>
<img src="https://user-images.githubusercontent.com/3212461/90596501-aba90380-e221-11ea-9cbb-062031eb8618.png" width="45%"></img> 
<img src="https://user-images.githubusercontent.com/3212461/90596505-ad72c700-e221-11ea-8340-db09e1061353.png" width="45%"></img> 
<img src="https://user-images.githubusercontent.com/3212461/90596508-aea3f400-e221-11ea-89a2-562aa408cbdf.png" width="45%"></img> 

# `Assembly Size vs N50 and N90 plots`

<img src="https://user-images.githubusercontent.com/3212461/90954281-a825ae80-e4a5-11ea-863d-47678a00aba1.png" width="45%"></img> 
<img src="https://user-images.githubusercontent.com/3212461/90954280-a6f48180-e4a5-11ea-93ad-908e0e339674.png" width="45%"></img> 
<img src="https://user-images.githubusercontent.com/3212461/90953985-dce43680-e4a2-11ea-91ba-750b72e731dd.png" width="45%"></img> 
<img src="https://user-images.githubusercontent.com/3212461/90953986-de156380-e4a2-11ea-8755-337b95ec4662.png" width="45%"></img> 

# `UpsetR plot` (orderby: freq vs degree)
<img src="https://user-images.githubusercontent.com/3212461/90954026-52500700-e4a3-11ea-9b1c-ad87b04c845b.png" width="45%"></img> 
<img src="https://user-images.githubusercontent.com/3212461/90124536-1f1ac300-dd93-11ea-9acc-9435b79a7f1c.png" width="45%"></img>

# `Contig Length Distribution Plots`
<img src="https://user-images.githubusercontent.com/3212461/90124507-17f3b500-dd93-11ea-9f37-6167ec79b8a1.png" width="30%"></img> 
<img src="https://user-images.githubusercontent.com/3212461/90124510-188c4b80-dd93-11ea-8609-1d3fbfc3ef43.png" width="30%"></img> 
<img src="https://user-images.githubusercontent.com/3212461/90954140-69dbbf80-e4a4-11ea-95ec-03c398269f3a.png" width="30%"></img> 
<img src="https://user-images.githubusercontent.com/3212461/90953981-d6ee5580-e4a2-11ea-97a4-fe30ddabbd77.png" width="30%"></img> 
<img src="https://user-images.githubusercontent.com/3212461/90953983-d81f8280-e4a2-11ea-81af-84668ff530a5.png" width="30%"></img>
<img src="https://user-images.githubusercontent.com/3212461/90953984-d8b81900-e4a2-11ea-9793-0e0026e7ba38.png" width="30%"></img> 

##### **Version**
version 2.1.0

### Contributing and Contact Information

We are open to suggestions for improvements in ``CPgeneProfiler``. Therefore, we invite all users to post a question or to provide us with (either positive or negative) feedback on the functions available in ``CPgeneProfiler``. When filing an issue, the most important thing is to include a minimal reproducible example so that we can quickly verify the problem, and then figure out how to fix it. There are two things you may need to include to make your example reproducible: data and code. If you are using additional packages, we would need that information as well. 

In addition, we welcome users who would like to contribute to the ``CPgeneProfiler`` package by adding new functions or co-developing some functions with us. You can let us know which function(s) you want to develop or which of the existing function(s) you want to improve. Please note that ``CPgeneProfiler`` is released with a [Contributor Code of Conduct](https://github.com/ramadatta/CPgeneProfiler/blob/master/Code_of_Conduct.md). By contributing to this project, you agree to abide by its terms.


To get further help regarding the functions available in ``CPgeneProfiler`` or inquries regarding contributions, please email us:

  - Prakki Sai Rama Sridatta (<ramadatta.88@gmail.com>)

