#' Merge tiff images to pdf for summary report
#'
#' Function used for summarizing all the results from CPgeneProfiler output
#'
#' @export
#'

tiff_merge <- function(pdfFile, tiffFiles) {

  pdf(pdfFile)

  n <- length(tiffFiles)

  for( i in 1:n) {

    tiffFile <- tiffFiles[i]

    tiffRaster <- tiff::readTIFF(tiffFile)

        grid::grid.raster(tiffRaster, width=grid::unit(0.8, "npc"), height= grid::unit(0.8, "npc"))

    if (i < n) plot.new()

  }

  dev.off()

}
