#' Converts jpeg images to pdf for summary report
#'
#' Summarize all the results from CPgeneProfiler output
#'
#' @export
#'

jpeg2pdf <- function(outdir = "CPgeneProfiler_Output", report="Summary")
{
  jpegFiles <- list.files(pattern = "^N...jpeg")
  jpeg_merge(pdfFile = paste0("N50_N90.pdf"), jpegFiles = jpegFiles)

  jpegFiles <- list.files(pattern = "CPgeneProfile.jpeg")
  jpeg_merge(pdfFile = paste0("CPgeneProfile.pdf"), jpegFiles = jpegFiles)

  jpegFiles <-  list.files(pattern = ".*_Contig_Dist.jpeg")
  jpeg_merge(pdfFile = paste0("Contig_Distribution.pdf"), jpegFiles = jpegFiles)

  jpegFiles <- list.files(pattern = "upset_plot.jpeg")
  jpeg_merge(pdfFile = paste0("upset_plot.pdf"), jpegFiles = jpegFiles)

  # Combine them with the other one
  pdftools::pdf_combine(c("N50_N90.pdf","CPgeneProfile.pdf","Contig_Distribution.pdf", "upset_plot.pdf"), output = paste0(report,".pdf"))

  ## Copying all the output files into specific folders inside the Main output folder
  files.to.move <- list.files(pattern = "^blastResults.*")
  files2move(files.to.move,outdir,subdir="1_CP_BLAST_Results")

  files.to.move <- list.files(pattern = "Cocarriage_|SameCP|DiffCP")
  files2move(files.to.move,outdir,subdir="2_Cocarriage_Results")

  files.to.move <- list.files(pattern = "CPgeneProfile\\.|cp_presence-absence_matrix")
  files2move(files.to.move,outdir,subdir="3_CP_Gene_Profile")

  files.to.move <- list.files(pattern = "Dist")
  files2move(files.to.move,outdir,subdir="4_CPGeneContig_LengthDistribution")

  files.to.move <- list.files(pattern = "N50|N90|assemblyStats")
  files2move(files.to.move,outdir,subdir="5_Assembly_Stats")

  files.to.move <- list.files(pattern = "upset_plot")
  files2move(files.to.move,outdir,subdir="6_UpsetR_Intersection_Plot")

  files.to.move <- list.files(pattern = "SummaryPlot")
  base::invisible(file.copy(files.to.move, outdir)) #invisible silently copies/removes files in R
  base::invisible(file.remove(files.to.move)) # delete
}
