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
 genome assemblies provided in fasta file format. The CP genes are derived from ARG-annot
 database.
 
2) It reports the profile of all the CP genes available in the genome assemblies
 in the format of simple heatmap.
 
3) Apart from this, it also reports the presence of cocarriage of CP genes within
 an assembly. 
 
4) Other assembly statistics such as N50, N90, Assembly Size from the
 assembly are calculated and plots of length distribution of CP gene contigs from
 the list of assemblies are reported.  
 
 Currently the package works only on Unix systems.
 
 
##### **Input Requirements**
* Path of a directory with multiple FASTA files (can be in multiple contigs) 
* Path of Carbapenamase Gene Database directory

 
##### **Requirements**

- **R packages:**
	 tidyverse,
	 UpSetR,
	 scales,
	 ape,
	 Biostrings,
	 reshape2,
	 gridExtra
	 
- **External software:** NCBI BLAST+ 

    Note 1: R package assumes `blastn` and `makeblastdb` files are in path
    
    Note 2: BLAST version 2.9.0+ was used for the present program although other BLAST+ similar to version 2.9.0+ parameters might also run without problems
    
#### **Installation**

##### **From Github**

The R package is available through github repository can be installed using devtools.

``` r 
install.packages("devtools")
devtools::install_github("ramadatta/CPgeneProfiler")
library("CPgeneProfiler")
```

##### **External software (REQUIRED)** 

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


##### **Check installation**
Ensure you have installed the package properly:

``` r
?CPgeneProfiler
```

### **Example Usage**
 
`CPgeneProfiler` package can be run using the following functions: `cpblast()`, `filt_blast()`, `cocarriage()`, `cpprofile()`, `upsetR_plot()`, `plot_conlen()`,`assemblystat()`, `cp_summarize()`, `db_summary()`. Below are the examples of `CPgeneProfiler` commands usage. 


- Generates NCBI BLAST Results by aligning input genome assemblies against Carbapenamase (CP) gene database

``` r
cpblast(fastalocation = "/home/user/CPgeneProfiler/testData/fasta", dblocation = "/home/user/CPgeneProfiler/testData/db")

```
- Filtering NCBI BLAST Results based on CP gene coverage and percent identity

``` r
filt_blast(cpgcov = 100, cpgpident = 100)
```

- Report cocarriage genes across all the input genome assemblies

``` r
cocarriage(cpgcov = 100, cpgpident = 100)
```

- Generate CP gene Profile

``` r
cpprofile()
```

- Plot CP gene contig length distributions across all the input genome assemblies

``` r
plot_conlen()
```

- Generate Basic assembly statistics

``` r
assemblystat("/home/user/CPgeneProfiler/testData/fasta")
```

- Summarize the plots and organize all the output files

``` r
cp_summarize()
```

- Database information

``` r
db_summary()
```

### **Working with `testData`**

#### **CP gene Database Download (REQUIRED)**

Go to the UNIX/Linux command line terminal and download the `db` folder with SVN

```
svn export https://github.com/ramadatta/CPgeneProfiler/trunk/testData/db
```
else simply [Click](https://downgit.github.io/#/home?url=https://github.com/ramadatta/CPgeneProfiler/tree/master/testData/db) to save database folder and uncompress the `db.zip` folder.

#### **Test Data Download (OPTIONAL)**

To test the package with test input data, Go to the UNIX/Linux command line terminal and download the `fasta` folder with SVN

```
svn export https://github.com/ramadatta/CPgeneProfiler/trunk/testData/fasta
```
else simply [Click](https://downgit.github.io/#/home?url=https://github.com/ramadatta/CPgeneProfiler/tree/master/testData/fasta) to save fasta folder and uncompress the `fasta.zip` folder.


##### **Step 3a: A simple NCBI BLAST using `cpblast()` command**

As a first step, CPgeneProfiler generates NCBI BLAST Results by aligning input genome assemblies against Carbapenamase (CP) gene database. Now that you already have a directory with fasta files (should have extensions `.fasta` or `.fa`) in `fasta` folder and cp gene database sequence in `db` folder, you can specify the path of both directories as an input and run the package with `cpblast()` command.

``` r
cpblast(fastalocation = "/home/user/CPgeneProfiler/testData/fasta",dblocation = "/home/user/CPgeneProfiler/testData/db",num_threads = 4,evalue = "1e-3")
```
The users can adjust BLAST parameters `num_threads` and `evalue` accordingly. If not adjusted, the package runs with default parameters (`num_threads` = 8, `evalue` = "1e-6")


##### **Step 3b: Filtering BLAST results using `filt_blast()` command**

`filt_blast()` then filters the output BLAST results obtained from `cpblast()` command. The BLAST hits are filtered based on CP gene coverage and Percentage Identity. By default parameters, CP Gene Coverage and Percentage Identity are set to 100% (cpgcov=100, cpgpident=100). This means that a CP gene should have 100% alignment length and 100% identity, without even a single mismatch. 

If the users find the default cutoff stringent to pick up the genes in the assemblies, then the parameters can be adjusted to desired parameters. 

``` r
filt_blast(cpgcov = 100,cpgpident = 100)
```

This would generate following table:

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

`cocarriage()` commands finds if two or more CP genes exists in same contig or multiple contigs across all the input genome assemblies. This function can be used only after running `filt_blast()`. By default parameters, CP Gene Coverage and Percentage Identity are set to 100% (cpgcov=100, cpgpident=100) and can be adjusted.

``` r
cocarriage(cpgcov = 100, cpgpident = 100)
```

##### **Step 3d: Finding CP gene profile using `cpprofile()` command**

`cpprofile()` creates a heatmap of carbapenamase gene profile from the input genome assemblies. By default, the command generates `png` image but user can change the output image type, width and height of image, label, titles and colors of the heatmap.

``` r
cpprofile(outputType="png", width = 2000, height = 2000, res = 250, xlab="Carbapenamase Genes", ylab="Assembly", title="Carbapenamase Gene Profile Heatmap", titlesize=15, labelsize=12,colorcode_low = "#143D59", colorcode_high = "#F4B41A", cpgcov=100, cpgpident=100)
```

##### **Step 3e: Plot CP gene contig length distribution using `plot_conlen()` command**

`plot_conlen()` generates length distribution for all the CP gene contigs present across all the input genome assemblies. By default, the command generates `png` image but user can change the output image type, width and height of image, label, titles and colors.

``` r
plot_conlen(outputType="tiff", width = 700, height = 700, res = 150, xlab="Contig Length", ylab="Number of Contigs", title=" Contig Length Distribution",element_text_angle=90,unit="KB", breaks=15, colorfill = "#F99245",cpgcov=100, cpgpident=100)
```
##### **Step 3f: Generate assembly statistics using `assemblystat()` command**

`assemblystat()` generates basic assembly stats which includes N50 size, N90 size and Genome assembly size. This function also generates Assembly Size vs N50 plot and Assembly Size vs N50 plot. This function requires the location of fasta file directory. By default, the command generates `png` image but user can change the output image type, width and height of image, label, titles and colors.

``` r
assemblystat("/home/user/CPgeneProfiler/testData/fasta", outputType="png", width = 700, height = 700, res = 150, geom_point_size=3, n50colorfill = "#0072B2", n90colorfill = "#D55E00")
```
##### **Step 3g: Generate Set Intersection of CP genes using `upsetR_plot()` command**

`upsetR_plot()` generates set intersection plot of CP genes across all the input genome assemblies. By default, the command generates `png` image but user can change the output image type, width and height of image, label, titles and colors.

``` r
upsetR_plot(outputType="png", width = 2000, height = 2000, res = 250, xlab="Carbapenamase Gene Set Size", ylab="Number of genome assemblies",cpgcov=100, cpgpident=100, order.by = "degree",nsets = 40, number.angles = 0,point.size = 1.5, line.size = 1,sets.bar.color = "red")
```
##### **Step 3h: Summarize all the results using `cp_summarize()` command**

`cp_summarize()` arranges all the output files generated from above commands into respective folders. This also creates a summary of all the plots from CPgeneProfiler output into a single PDF file. Users can specify the output directory name and summary pdf name. To summarize, this commands reqiures all the output image plots to have same format i.e, either png/tiff/jpeg.

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
filt_blast() | blastResults.filt.txt | Filtered blast results with contains contigs matching CPgenes (default: 100% identity and 100% coverage)
cocarriage() | Co-carriage_Report.txt | Information of Number of assemblies with the co-carriage broken down to category
cocarriage() | DiffCP_DiffContig.txt | Information of assemblies with different CP genes present in different contigs
cocarriage() | DiffCP_SameContig.txt | Information of assemblies with different CP genes present in same contigs 
cocarriage() | SameCP_DiffContig.txt | Information of assemblies with same CP genes present in different contigs
cocarriage() | SameCP_SameContig.txt | Information of assemblies with same CP genes present in same contigs
cpprofile() | CPgeneProfile.png | Carbapenamase Gene Profile (default:png)
plot_conlen() | CPContigSizeDist.txt | Contig Size distribution
plot_conlen() | "CPGene"_Contig_Dist.png | CP gene contig length distribution (for each CP gene a seperate disribution plot is generated. Default image format: png)
upsetR_plot() | cp_presence-absence_matrix.csv | Presence-absence matrix of CP genes across assemblies
upsetR_plot() | upset_plot.pdf | Set intersection plot of CP genes across all the input genome assemblies
assemblystat() | N50_N90.pdf | N50, N90 vs Assembly Size plot
assemblystat() | assemblyStats.txt | A simple text file with N50, N90, Assembly Size for each assembly
cp_summarize() | SummaryPlots.pdf | All the plots in a single pdf file

## A few example plots created with `CPgeneProfiler`
<img src="https://user-images.githubusercontent.com/3212461/90124520-1c1fd280-dd93-11ea-9ce3-f55ccf583b45.png" width="45%"></img> <img src="https://user-images.githubusercontent.com/3212461/90124524-1cb86900-dd93-11ea-8960-53fa7a19aac9.png" width="45%"></img> <img src="https://user-images.githubusercontent.com/3212461/90124487-10cca700-dd93-11ea-9572-dfc44a190dd6.png" width="45%"></img> <img src="https://user-images.githubusercontent.com/3212461/90124536-1f1ac300-dd93-11ea-9acc-9435b79a7f1c.png" width="45%"></img> <img src="https://user-images.githubusercontent.com/3212461/90124507-17f3b500-dd93-11ea-9f37-6167ec79b8a1.png" width="45%"></img> <img src="https://user-images.githubusercontent.com/3212461/90124510-188c4b80-dd93-11ea-8609-1d3fbfc3ef43.png" width="45%"></img> 

Figures: 1) Assembly Size vs N50 plot (Top left) 2) Assembly Size vs N90 plot (Top Right) 3) Carbapenamase Gene Profile CP gene-containing contig length plots KPC (Middle left) 4) Set intersection plot of CP genes across all the input genome assemblies (Middle right) 5-6) CP gene contig length distribution (Bottom right)

##### **Version**
version 2.1.0
