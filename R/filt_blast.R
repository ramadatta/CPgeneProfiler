#' Filter BLAST results
#'
#' `filt_blast` filters the output results obtained from `cpblast()`.
#'  The filter is based on CP gene coverage and Percentage Identity
#' @param cpgcov CP gene coverage cutoff (default=100)
#' @param cpgpident CP gene percentage identity with genomic sequence (default=100)
#'
#' @export
#' @examples
#'
#' filt_blast()
#' filt_blast(cpgcov=100, cpgpident=100)


filt_blast <- function(cpgcov=100, cpgpident=100){

    blastResults_df <- cpcore()

## 1) Create a table with AssemblyName | CP contig | Length | CPgene- coordinates from BLAST

blastResults.filt <-
  blastResults_df[blastResults_df$cov >= cpgcov &
                    blastResults_df$pident >= cpgpident, c("assemblyName" , "qseqid", "sseqid", "qlen","slen", "qstart", "qend", "length","pident", "cov")] # subsets only the gene name with if CP gene has 100% cov

write.table(
  blastResults.filt,
  "blastResults.filt.txt",
  row.names = FALSE,
  col.names = FALSE,
  append = TRUE,
  quote = FALSE
)

#Return filtered blast results
#blastResults.filt

}
