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
  print("VERSION: 2020-07-16.2")
  print("SEQUENCES: 875")
  print("DBTYPE: nucl")
  print("DATE UPLOADED: 2020-Aug-23")
  print("Reference Gene Catalog: ftp://ftp.ncbi.nlm.nih.gov/pathogen/Antimicrobial_resistance/AMRFinderPlus/database/3.8/")
}



