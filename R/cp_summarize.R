#' CPgeneProfiler Results Summary
#'
#' Summarize all the results from CPgeneProfiler output
#' @param outdir_loc output directory location (By default, output directory will be created in the input folder)
#' @param outdir output directory (default: CPgeneProfiler_Output)
#' @param report PDF Summary of all the plots (default: Summary)
#' @param image  format of all the output image plots. (default:png) Note: All the image plots should be in same format (png/tiff/jpeg) to form a summary report plot file in PDF
#'
#' @export
#' @examples
#'
#' cp_summarize()
#' cp_summarize(outdir = "/home/user/Desktop", report="Summary" , image = "png")

cp_summarize <- function(outdir_loc = "CPgeneProfiler_Output", outdir = "CPgeneProfiler_Output", report="SummaryPlots" , image = "png")
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
  else 
  {
    if(image=="pdf")
    {
    pdfs2pdf(outdir,report)
    }  
  }
  
if(outdir_loc == outdir)
  {
   # print "No location provided! So keeping the outdir in the input folder"
  }
  else
  {
  dest.dir <- paste(outdir_loc,outdir, sep = "/")
  dir.create(dest.dir)
  file.rename(outdir,dest.dir)
  }  
}
