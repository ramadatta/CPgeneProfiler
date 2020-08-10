#' CPgeneProfiler Results Summary
#'
#' Summarize all the results from CPgeneProfiler output
#' @param outdir output directory (default: CPgeneProfiler_Output)
#' @param report PDF Summary of all the plots (default: Summary)
#' @param image  format of all the output image plots. (default:png) Note: All the image plots should be in same format (png/tiff/jpeg) to form a summary report plot file in PDF
#'
#' @export
#' @examples
#'
#' cp_summarize()
#' cp_summarize(outdir = "CPgeneProfiler_Output", report="Summary" , image = "png")

cp_summarize <- function(outdir = "CPgeneProfiler_Output", report="SummaryPlots" , image = "png")
{
  if (image=="tiff")
  {
    tiff2pdf(outdir,report)
  }
  else if(image=="jpeg")
  {
    jpeg2pdf(outdir,report)
  }
  else if(image=="png")
  {
    png2pdf(outdir,report)
  }
  #Not fully functional yet; issue merging different sizes of PDF; will work on future versions
  else if(image=="pdf")
  {
    pdfs2pdf(outdir,report)
  }

}
