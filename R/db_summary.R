#' CPgeneProfiler Database Summary
#'
#' Display the details of Database, which includes Database Name, Database Version,
#' Total sequences in Databases, Date on which database was created, Database Reference location
#' from where sequences are downloaded
#'
#' @export
#' @examples

#' db_summary()

db_summary <- function()
{
  print("DATABASE: NCBI Bacterial Antimicrobial Resistance Reference Gene Database")
  print("VERSION: 2020-06-11.1")
  print("SEQUENCES: 1062")
  print("DBTYPE: nucl")
  print("DATE: 2020-Aug-04")
  print("Reference Gene Catalog: https://www.ncbi.nlm.nih.gov/pathogens/isolates#/refgene/")
}



