#' Move the output files for summarizing CPgeneProfiler Results
#'
#' Used for summarizing all the results from CPgeneProfiler output folder
#' @param files.to.move files to move to specific directory
#' @param outdir Main output folder directory (default: CPgeneProfiler_Output)
#' @param subdir Subfolder in the `CPgeneProfiler_Output` directory for which files has to move
#'
#' @export
#' @examples
#'

files2move <- function(files.to.move,outdir,subdir){

  #If CpgeneProfiler_Output does not exist, create one
  if (!dir.exists(outdir)){
    dir.create(outdir)
    dest.dir <- paste(outdir,subdir, sep = "/")
    dir.create(dest.dir)
    base::invisible(file.copy(files.to.move, dest.dir)) #invisible silently copies/removes files in R
    base::invisible(file.remove(files.to.move)) # delete
  }
else { #If CpgeneProfiler_Output exist, Just copy the files into specific directories
  #print("Dir already exists!")
  #dir.create(outdir)
  dest.dir <- paste(outdir,subdir, sep = "/")
  dir.create(dest.dir)
  base::invisible(file.copy(files.to.move, dest.dir)) #invisible silently copies/removes files in R
  base::invisible(file.remove(files.to.move)) # delete
  }
}
