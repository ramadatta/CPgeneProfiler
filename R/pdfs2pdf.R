#' Converts multiple pdf files with plots to single pdf for summary report
#'
#' Summarize all the plots from CPgeneProfiler output
#'
#' @export
#'

pdfs2pdf <- function(outdir = "CPgeneProfiler_Output", report="Summary")
{
  pdfFiles <- list.files(pattern = "^N...pdf")
#  pdftools::pdf_combine(pdfFiles, output = "N50_N90.pdf") # no need because already a PDF

#  pdfFiles <- list.files(pattern = "CPgeneProfile.pdf") # no need because already a single page PDF
#  pdftools::pdf_combine(pdfFiles, output = "CPgeneProfile.pdf")

  pdfFiles <-  list.files(pattern = ".*_Contig_Dist.pdf")
  pdftools::pdf_combine(pdfFiles, output = "Contig_Distribution.pdf")

  #pdfFiles <- list.files(pattern = "upset_plot.pdf") # no need because already a single page PDF
  #pdftools::pdf_combine(pdfFiles, output = "Contig_Distribution.pdf")

  # Combine them with the other one
  #pdftools::pdf_combine(c("N50_N90.pdf","CPgeneProfile.pdf","Contig_Distribution.pdf", "upset_plot.pdf"), output = paste0(report,".pdf"))

  ## Copying all the output files into specific folders inside the Main output folder
  files.to.move <- list.files(pattern = "^blastResults.*")
  files2move(files.to.move,outdir,subdir="1_CP_BLAST_Results")

  files.to.move <- list.files(pattern = "Co-carriage_Report|SameCP|DiffCP")
  files2move(files.to.move,outdir,subdir="2_Cocarriage_Results")

  files.to.move <- list.files(pattern = "CPgeneProfile\\.|cp_presence-absence_matrix")
  files2move(files.to.move,outdir,subdir="3_CP_Gene_Profile")

  files.to.move <- list.files(pattern = "Dist")
  files2move(files.to.move,outdir,subdir="4_CPGeneContig_LengthDistribution")

  files.to.move <- list.files(pattern = "N50|N90|assemblyStats")
  files2move(files.to.move,outdir,subdir="5_Assembly_Stats")

  files.to.move <- list.files(pattern = "upsetr_plot")
  files2move(files.to.move,outdir,subdir="6_UpsetR_Intersection_Plot")

  files.to.move <- list.files(pattern = "SummaryPlot")
  base::invisible(file.copy(files.to.move, outdir)) #invisible silently copies/removes files in R
  base::invisible(file.remove(files.to.move)) # delete

}
