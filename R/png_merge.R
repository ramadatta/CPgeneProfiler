#' Merge png images to pdf for summary report
#'
#' Function used for summarizing all the results from CPgeneProfiler output
#'
#' @export
#'

png_merge <- function(pdfFile, pngFiles) {

  pdf(pdfFile)

  n <- length(pngFiles)

  for( i in 1:n) {

    pngFile <- pngFiles[i]

    pngRaster <- png::readPNG(pngFile)

    grid::grid.raster(pngRaster, width=grid::unit(0.8, "npc"), height= grid::unit(0.8, "npc"))

    if (i < n) plot.new()

  }

  dev.off()
}
