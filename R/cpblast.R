#' Generate NCBI BLAST Results by aligning input genome assemblies against Carbapenamase (CP) gene database
#'
#' Prior to running this command, the `NCBI_BARRGD_CPG_DB.fasta` file is expected to be
#' downloaded and saved in the respective location on the local system. `cpblast()` helps
#' to generate the location of the CP genes in the genomes.
#'
#' @param fastalocation Location of the folder with only fasta files. The files
#' must end with either `.fasta` or `.fa` format
#' @param dblocation Location of the `NCBI_BARRGD_CPG_DB.fasta` (CP gene database)
#' @param num_threads Number of threads to run the blast (default=16)
#' @param evalue Cutoff e-value for blast hit (default="1e-6")
#'
#' @export
#' @examples
#'
#' cpblast("/home/user/CPgeneProfiler/testData/fasta","/home/user/CPgeneProfiler/testData/db")
#' cpblast(fastalocation = "/home/user/CPgeneProfiler/testData/fasta",dblocation = "/home/user/CPgeneProfiler/testData/db",num_threads = 8,evalue = "1e-6")

cpblast <- function(fastalocation,dblocation,num_threads="16",evalue="1e-6"){

  # Remove BLAST Results if already exists

  #Define the file name that will be deleted
  fn <- "blastResults.txt"
  #Check its existence
  if (file.exists(fn))
  #Delete file if it exists
  file.remove(fn)

  setwd(dblocation)
  getwd()

  # Create a BLAST database
  makeblastdb = "makeblastdb"
  system2(
    command = makeblastdb,
    args = c(
      "-in",
      #dblocation,
       'NCBI_BARRGD_CPG_DB.fasta',
      "-dbtype",
      "nucl",
      "-parse_seqids",
      "-out",
      'NCBI_BARRGD_CPG.DB',
      "-logfile",
      "log"
    ),
    wait = TRUE,
  )
  blast_db_location = getwd() # for later use

  ############--------GO TO ASSEMBLY FILES LOCATION------##########

  setwd(fastalocation)
  getwd()

  ############--------VARIABLES------##########

  blast_db = paste(blast_db_location, "NCBI_BARRGD_CPG.DB", sep = "/")
  blastn = "blastn"
  evalue = evalue
  format = "\'6 qseqid sseqid pident nident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen\'"
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



  ############--------CALCULATING TIME------##########
  old <- Sys.time()

  ############--------1) BLASTN ASSEMBLY ON ARG-ANNOT DATA------##########

  #List of all the fasta files
  files <- list.files(pattern = "*.fasta$|*.fa$", recursive = F)

  ## Read in all files using a for loop and perform BLASTN and save the results in a output

  datalist = list()
  for (i in 1:length(files)) {

    input = files[i]

    blast_out <- paste(input,
                       system2(
                         command = blastn,
                         args = c(
                           "-db",
                           blast_db,
                           "-query",
                           input,
                           "-outfmt",
                           format,
                           "-evalue",
                           evalue,
                           "-ungapped",
                           "-num_threads",
                           num_threads
                         ),
                         wait = TRUE,
                         stdout = TRUE
                       ),
                       sep = "\t")
    write.table(
      blast_out,
      "blastResults.txt",
      row.names = FALSE,
      col.names = FALSE,
      append = TRUE,
      quote = FALSE
    )

   }
  #Return blast_out
 # blast_out

}
