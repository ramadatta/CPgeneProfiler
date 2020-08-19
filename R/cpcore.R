#' CPgeneProfiler Core function
#'
#' This cpcore code function is used in the multiple R scripts 
#' @export
#'



cpcore <- function(){
    colnames <- c(
      "assemblyName",
      "qseqid",
      "sseqid",
      "pident",
      "nident",
      "length",
      "mismatch",
      "gapopen",
      "qstart",
      "qend",
      "sstart",
      "send",
      "evalue",
      "bitscore",
      "qlen",
      "slen"
    )
    
    #Filtering blast results
    blastResults_df <- utils::read.table("blastResults.txt", sep = "\t", fill = TRUE)
    #print(blastResults_df)
    blastResults_df <- blastResults_df[complete.cases(blastResults_df),]
    
    ############--------ADD COLNAMES TO BLASTN OUTPUT TO A TABLE ------##########
    names(blastResults_df) <- colnames
    
    ############--------FIND CP GENE CONTAINING CONTIGS WITH CPGENE MATCHING 100% ID AND COVERAGE ------##########
    blastResults_df$cov <- (blastResults_df$nident*100) / blastResults_df$slen
    #head(blastResults_df)
    
    #----TRIMMING STRINGS IN THE TABLE
    blastResults_df$sseqid <- gsub("bla", "", blastResults_df$sseqid)
   # print(blastResults_df)
    return(blastResults_df)
  }