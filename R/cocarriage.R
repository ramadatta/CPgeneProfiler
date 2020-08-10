#' Find cocarriage of CP genes in the input genomes
#'
#' `cocarriage()` finds if 2 or more CP genes exists in same contig
#'  or multiple contigs. This function should be used after running
#'  `filt_blast()`.
#'
#' @param cpgcov CP gene coverage cutoff (default=100)
#' @param cpgpident CP gene percentage identity with genomic sequence (default=100)
#'
#' @export
#' @examples
#'
#' cocarriage()
#' cocarriage(cpgcov=100,cpgpident=100)

cocarriage <- function(cpgcov=100,cpgpident=100){

  blastResults_df <- cpcore()

  blastResults.filt <-
    blastResults_df[blastResults_df$cov >= cpgcov &
                      blastResults_df$pident >= cpgpident, c("assemblyName" , "qseqid", "sseqid", "qlen","slen", "qstart", "qend", "length","pident", "cov")] # subsets only the gene name with if CP gene has 100% cov

# # 3) Report how many Assemblies have co-carriage

dupAssemblies_logical <-
  duplicated(blastResults.filt[, c("assemblyName")]) |
  duplicated(blastResults.filt[, c("assemblyName")], fromLast = TRUE)
  dupAssemblies <- blastResults.filt[dupAssemblies_logical, ]

  #length(unique(dupAssemblies$assemblyName)) ## This many assemblies have multiple genes or same genes in various places
  #head(dupAssemblies)

##---SAMECP_SAMECONTIG

'%>%' <- purrr::`%>%`

SameCP_SameContig <- dupAssemblies %>%
  dplyr::group_by(assemblyName, qseqid, sseqid) %>%
  dplyr::filter(dplyr::n() > 1)
# print(n = Inf)

##---SAMECP_DIFFCONTIG
SameCP_DiffContig <- dupAssemblies %>%
  dplyr::group_by(assemblyName, sseqid) %>%
  dplyr::mutate(key = dplyr::n_distinct(qseqid)) %>%
  dplyr::filter(key > 1)  %>%
  dplyr::select(-key)
# %>% print(n = Inf)

##DIFFCP_SAMECONTIG

DiffCP_SameContig <- dupAssemblies %>%
  dplyr::mutate(key = paste0(sseqid)) %>%
  dplyr::group_by(assemblyName, qseqid) %>%
  dplyr::filter( dplyr::n_distinct(key) > 1) %>%
  dplyr::select(-key)
# %>% print(n = Inf)

##DIFFCP_DIFFCONTIG

DiffCP_DiffContig <- dupAssemblies %>%
  dplyr::mutate(key = paste0(qseqid)) %>%
  dplyr::group_by(assemblyName) %>%
  dplyr::filter(dplyr::n_distinct(key) > 1 | dplyr::n() == 1) %>%
  dplyr::select(-key) %>%
  dplyr::mutate(key2 = paste0(sseqid)) %>%
  dplyr::group_by(assemblyName) %>%
  dplyr::filter(dplyr::n_distinct(key2) > 1 | dplyr::n() == 1) %>%
  dplyr::select(-key2)
# %>% print(n = Inf)

# %>% print(n = Inf)

## Write to output files

write.table(
  DiffCP_DiffContig,
  "DiffCP_DiffContig.txt",
  row.names = FALSE,
  col.names = TRUE,
  quote = FALSE
) ## Save DiffCP_DiffContig output to txt file


write.table(
  DiffCP_SameContig,
  "DiffCP_SameContig.txt",
  row.names = FALSE,
  col.names = TRUE,
  quote = FALSE
) ## Save DiffCP_SameContig output to txt file


write.table(
  SameCP_DiffContig,
  "SameCP_DiffContig.txt",
  row.names = FALSE,
  col.names = TRUE,
  quote = FALSE
) # Output contains SameCP_DiffContig


write.table(
  SameCP_SameContig,
  "SameCP_SameContig.txt",
  row.names = FALSE,
  col.names = TRUE,
  quote = FALSE
) # Output contains SameCP_DiffContig

SameCP_SameContig_Count <- length(unique(SameCP_SameContig$assemblyName))
SameCP_DiffContig_Count <- length(unique(SameCP_DiffContig$assemblyName))
DiffCP_DiffContig_Count <- length(unique(DiffCP_DiffContig$assemblyName))
DiffCP_SameContig_Count <- length(unique(DiffCP_SameContig$assemblyName))

# SameCP_SameContig_Count
# SameCP_DiffContig_Count
# DiffCP_DiffContig_Count
# DiffCP_SameContig_Count

# Creating text file for the filtered co-carriage

cat(
  "Assemblies with SameCP_SameContig_Count are : ",
  SameCP_SameContig_Count,
  file = "Co-carriage_Report.txt",
  append = TRUE
)
cat(
  "\nAssemblies with SameCP_DiffContig_Count are : ",
  SameCP_DiffContig_Count,
  file = "Co-carriage_Report.txt",
  append = TRUE
)
cat(
  "\nAssemblies with DiffCP_DiffContig_Count are : ",
  DiffCP_DiffContig_Count,
  file = "Co-carriage_Report.txt",
  append = TRUE
)
cat(
  "\nAssemblies with DiffCP_SameContig_Count are : ",
  DiffCP_SameContig_Count,
  file = "Co-carriage_Report.txt",
  append = TRUE
)

}
