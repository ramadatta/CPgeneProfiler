#' Merge jpeg images to pdf for summary report
#'
#' Function used for summarizing all the results from CPgeneProfiler output
#'
#' @export
#'

jpeg_merge <- function(pdfFile, jpegFiles) {

  pdf(pdfFile)

  n <- length(jpegFiles)

  for( i in 1:n) {

    jpegFile <- jpegFiles[i]

    jpegRaster <- jpeg::readJPEG(jpegFile)

    grid::grid.raster(jpegRaster, width=grid::unit(0.8, "npc"), height= grid::unit(0.8, "npc"))

    if (i < n) plot.new()

  }

  dev.off()

}
