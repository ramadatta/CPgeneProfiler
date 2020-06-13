---
# Example from https://joss.readthedocs.io/en/latest/submitting.html
title: 'CPgeneProfiler: A lightweight R package to profile the Carbapenamase genes
  from genome assemblies'
tags:
  - R
  - Carbapenamase gene profile
  - cocarriage
  - Beta-lactamases
  - Antimicrobial resistance (AMR)
authors:
  - name: Prakki Sai Rama Sridatta
    orcid: 0000-0002-9254-2557
    affiliation: 1 
  - name: Natascha May Thevasagayam
    orcid: 0000-0000-0000-0000
    affiliation: 1
  - name: Weizhen Xu
    orcid: 0000-0000-0000-0000
    affiliation: 1
  - name: Ng Oon Tek
    orcid: 0000-0000-0000-0000
    affiliation: 1    
affiliations:
 - name: National Centre for Infectious Diseases, Singapore
   index: 1
citation_author: Prakki et. al.
date: 13 June 2020
year: 2020
bibliography: paper.bib
output: rticles::joss_article
csl: apa.csl
journal: JOSS
---

# Abstract 

Carbapenems, a certain category of beta-lactam antibiotics, are considered to have greater impact on the bacterial infections. This class of antiobiotics are known as “last-line” agents when the patients harbour resistant bacteria [@papp2011carbapenems]. But, the emergence and rapid spread of carbapenemase genes (CP genes), especially in the Gram-negative bacteria is considered a major healthcare problem of grave importance [@nordmann2019epidemiology]. Further, it is understood that the co-carriage of genes encoding different classes of carbapenemases are highly resistant to carbapenem antibiotics, which may promote further spread of the disease [@wang2019cocarriage].

Here we describe CPgeneProfiler, an R package that examines the presence of CP genes in the genome sequences of bacteria using R framework. In addition to profiling the CP genes, the package finds the co-carriage of CP genes in genome assemblies, their frequency of occurrence and also the respective locations of the genes. Lastly, CPgeneProfiler also generates simple N50 and N90 statistics, carbapenamase gene-containing contig length distributions and summary plots to get an overview of the presence of CP genes across multiple genome assemblies. CPgeneProfiler is a freely available package released under GNU General Public License v2.0, at: ``https://github.com/ramadatta/CPgeneProfiler``

# Introduction

Of the variety of antimicrobial resistant genes in the Gram-positive and Gram-negative bacteria, a specific subset of beta-lactams called “carbapenems” is considered to possess a higher spectrum of antimicrobial activity and also have a very highly resistance to variety of beta-lactamases [@papp2011carbapenems]. Thorough studies provide evidence that those cases infected by carbapenem-resistant pathogens are considered to have an higher morbidity and mortality rate compared with those who are infected by non carbapenem-resistant pathogens [@van2013carbapenem; @cai2017prevalence]. Therefore, early discerning of the carbapenamase genes (CP genes) and their resistance mechanisms are considered crucial to lessen the likelihood of mortality rate, duration of hospitalization stay, and related medical costs [@van2013carbapenem; @nordmann2019epidemiology]. Further, it is understood that the co-carriage of genes encoding different classes of carbapenemases are highly resistant to carbapenem antibiotics, which may promote further spead of the disease [@wang2019cocarriage].


The detection of the resistance genes from various bacterial strains using techniques such as Polymerase Chain Reaction and Microarrays in real time, is very time consuming and costly due to the nature of methodogy of the specific techniques. With the advancement in Next Generation Sequencing (NGS) technologies, recently the costs of whole-genome sequencing has been found to decline and it is understood from the recent studies that WGS can identify the sources of infection and plays a very important role in the field of clinical practice and public healthcare system [@spencer2019whole].

To this end, around 50 freely available bioinformatics resources were identified to find the antimicrobial resistance genes in nucleotide as well as amino acid sequence data [@hendriksen2019using]. Some of these resources include, but not limited to are ARIBA [@hunt2017ariba], ARG-ANNOT [@gupta2014arg], CARD database [@jia2016card], MEGARes [@lakin2017megares], NCBI-AMRFinder (https://www.ncbi.nlm.nih.gov/pathogens/antimicrobial-resistance/AMRFinder/), KmerResistance (https://cge.cbs.dtu.dk/services/KmerResistance/), SRST2 [@inouye2014srst2] and ResFinder [@zankari2012identification].

All the abve mentioned tools can detect the genes from either genome assemblies or sequencing reads but do not exclusively report a genetic profile for the presence of CP genes across all multiple genome assemblies and segregate the co-carriage information of CP genes and their frequency of occurrence. Therefore, we describe here, CPgeneProfiler, a lightweight R package that scans bacterial genome sequences to detect the presence of CP genes using R framework. In addition to profiling the CP genes, the package finds the co-carriage of CP genes in genome assemblies, their frequency of occurrence and also the respective locations of the genes. Lastly, CPgeneProfiler also generates simple N50 and N90 stats, CP gene-containing contig length distributions and summary plots to get an overview of the presence of CP genes across multiple genome assemblies.

# Methods

CPgeneProfiler can be downloaded and installed from the GitHub repository https://github.com/ramadatta/CPgeneProfiler and operates as follows:

1. **Creation of CP gene database:** A multi-fasta file with CP gene sequences was generated from ARG-annot (Antibiotic Resistance Gene-ANNOTation database (v3) available at: 
http://backup.mediterranee-infection.com/article.php?laref=282&titre=arg-annot) 
[@gupta2014arg]. 
During runtime, the user needs to download carbapenamase gene fasta file (also available at: https://raw.githubusercontent.com/ramadatta/CPgene-profiler/master/ARG-annot_CPGene_DB.fasta) into a local folder on the Unix system and compiled by ‘makeblastdb’ to generate a database in the respective location when CPgeneProfiler package is executed. The database includes the following CP gene families: IMI, IMP, KPC, NDM, OXA, VIM.

2. **Generating basic assembly statistics:** Genome assemblies in fasta format, irrespective of the assembler can be supplied as an input for the package. Multiple genome assemblies in the “fasta” format can be provided in the same run. The package then generates the basic assembly statistics such as N50, N90, assembly size and related plots accordingly using the ggplot2 package [@ggplot].

3. **Scan for CP genes:** Each fasta file is then searched against the CP gene database using BLAST+ [@camacho2009blast] (version 2.9.0+) which is pre-installed in the local system as a dependency. By default, BLAST uses all the threads available. The presence of a CP gene in an assembled genome is confirmed if the identity and coverage of the gene is exactly 100% within the genome. The sequence matches which meet the thresholds are extracted from the BLAST results.

4. **CP gene profiling & intersection plots:** The filtered BLAST results  are then used to profile the CP genes in the assemblies and the following two plots are generated: 

      **(1)** A tile heatmap plot using ggplot [@ggplot] - showing presence-absence of all the carbapenamase genes in all the assemblies \autoref{fig:Figure 1}. 
      
      **(2)** A static UpSet plots using UpSetR package [@conway2017upsetr] - which visualizes set intersections of CP genes across all the input genome assemblies in a matrix layout \autoref{fig:Figure 2}.
      
5. **CP gene-containing contig length distribution plots:** By plotting the CP gene-containing contig distribution, at a snapshot one can understand if the majority of carbapenamase genes are present in the chromosomal contig or plasmid contigs. CpgeneProfiler creates CP gene-containing contig length histogram plots using ggplot2 package [@ggplot]. If the assembly is not highly fragmented, this feature is helpful to understand if the CP gene is present in chromosomes or plasmids.

6. **Co-carriage detection from genome assemblies:** Further, from the filtered BLAST results, details on the co-carriage of CP genes in the genome assemblies are extracted. The assemblies which contain co-carriages are flagged and the location of co-carried CP genes is segregated into 4 different output files. Thus, the 4 output text files will include information of assemblies 1) with different CP genes present on different contigs, 2) different CP genes present on same contigs, 3) same CP genes present on different contigs, 4) same CP genes present on same contigs.

# CPgeneProfiler R Package

The R package ``CPgeneProfiler`` can be installed by typing the following in R:

```r
devtools::install_github("ramadatta/CPgeneProfiler")
```
The R package ``CPgeneProfiler``, currently in version 0.2.0 on the github, checks for a list of Carbapenamase (CP) genes from a list of genome assemblies provided in fasta file format. 

After the installation, the package can be used as follows:

```r
> CPgeneProfiler("/path/Folder_with_Fasta/")
```
## Output Files

* A folder "CPgene-profiler_Output" is generated with the following files

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

# Figures

![ CP gene profile \label{fig:Figure 1}](CPgeneProfile.jpg){width=350px height=300px}
![ Intersection of CP gene sample count \label{fig:Figure 2}](UpSetR.png){width=350px height=300px}


![ KPC gene contig length distribution](KPC.jpg){width=350px height=300px}
![ OXA gene contig length distribution](OXA.jpg){width=350px height=300px}

# 3. Conclusion

``CPgeneProfiler`` is useful to understand the overall CP gene profile in the assembled genomes of bacteria. It generates a simple heatmap for visualization of the CP gene profile. Apart from this, it also reports details of the co-carriage of CP genes within the genomes. The identification and visualization of the presence of CP genes within outbreak samples are of much significance and the CPgeneProfiler could aid researchers in obtaining an overview of the samples and their CP gene carriage. .


# Acknowledgement
The authors would like to thank Victor Ong and Wang Liang De for generating the sequence data that was used for developing and testing the tool.

# Funding
This work is supported by the Singapore Ministry of Health’s National Medical Research Council under its NMRC Collaborative Grant: Collaborative Solutions Targeting Antimicrobial Resistance Threats in Health Systems (CoSTAR-HS) (NMRC CGAug16C005) and NMRC Clinician Scientist Award (MOH-000276).  Any opinions, findings and conclusions or recommendations expressed in this material are those of the author(s) and do not reflect the views of MOH/NMRC.

# References  
