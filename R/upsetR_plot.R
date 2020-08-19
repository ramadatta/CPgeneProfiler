#' UpsetR - Set intersection plot visualization
#'
#' `upsetR_plot()` generates set intersection plot of CP genes across all the input
#' genome assemblies.
#' @param outputType Output result file in pdf/tiff/jpeg/png format (default="tiff")
#' @param width width of the device (default=2000)
#' @param height height of the device (default=2000)
#' @param res Nominal resolution in ppi (default=250)
#' @param xlab Label on x-axis (default="Carbapenamase Genes")
#' @param ylab Label on y-axis (default="Assembly")
#' @param cpgcov CP gene coverage cutoff (default=100)
#' @param cpgpident CP gene percentage identity with genomic sequence (default=100)
#' @param order.by How the intersections in the matrix should be ordered by (default="degree")
#' @param nsets Number of sets to look at (default=40)
#' @param number.angles The angle of the numbers atop the intersection size bars (default = 0)
#' @param point.size Size of points in matrix plot (default=1.5)
#' @param line.size Width of lines in matrix plot (default = 1)
#' @param sets.bar.color Color of set size bar plot (default= "red")
#' @export
#' @examples
#'
#' upsetR_plot()
#' upsetR_plot(outputType="png", width = 2000, height = 2000, res = 250, xlab="Carbapenamase Gene Set Size", ylab="Number of genome assemblies",cpgcov=100, cpgpident=100, order.by = "degree",nsets = 40, number.angles = 0,point.size = 1.5, line.size = 1,sets.bar.color = "red")

upsetR_plot <- function(outputType="png", width = 2000, height = 2000, res = 250,
                        xlab="Carbapenamase Gene Set Size", ylab="Number of genome assemblies",
                        cpgcov=100, cpgpident=100,
                        order.by = "degree",nsets = 40, number.angles = 0,point.size = 1.5, line.size = 1,sets.bar.color = "red"){

  # Check core.R function
  blastResults_df <- cpcore()

#----CREATE A MATRIX
blastResults_Matrix <-
  table(blastResults_df[blastResults_df$cov >= cpgcov &
                          blastResults_df$pident >= cpgpident, c("assemblyName" , "sseqid")]) # subsets only the gene name with if CP gene has 100% cov
#print(blastResults_Matrix)

# remove the columns with all "0"
blastResults_Matrix <- blastResults_Matrix[, colSums(blastResults_Matrix != 0) > 0]
#print(blastResults_Matrix)
#----CREATE A PRESENCE/ABSENCE MATRIX

blastResults_BinaryMatrix <-
  as.matrix((blastResults_Matrix > 0) + 0) ## Convert to binary matrix


  ############--------3) FIND INTERSECTIONS OF CPGENES IN VARIOUS ASSEMBLIES USING UPSETR------##########
  write.csv(
    blastResults_BinaryMatrix,
    file = "cp_presence-absence_matrix.csv",
    row.names = TRUE,
    quote = FALSE
  ) ##OUTPUT9

  upsetdf <-
    utils::read.csv(file = "cp_presence-absence_matrix.csv", check.names = FALSE)

  if(outputType=="tiff")
  {
    tiff("upset_plot.tiff", width = width, height = height, units = 'px',res = res)
    print(UpSetR::upset(upsetdf,order.by = order.by,nsets = nsets, number.angles = number.angles,point.size = point.size, line.size = line.size,
                        mainbar.y.label = ylab,
                        sets.x.label = xlab,
                        sets.bar.color = sets.bar.color,
                        text.scale = c(1.2, 1.3, 1, 1, 1.2, 1.6)))
    dev.off()
  }
  else if(outputType=="pdf")
  {
  pdf("upsetr_plot.pdf", paper="a4")
    print(UpSetR::upset(upsetdf,order.by = order.by,nsets = nsets, number.angles = number.angles,point.size = point.size, line.size = line.size,
                        mainbar.y.label = ylab,
                        sets.x.label = xlab,
                        sets.bar.color = sets.bar.color,
                        text.scale = c(1.2, 1.3, 1, 1, 1.2, 1.6)))
    dev.off()
  }
  else if(outputType=="jpeg")
  {
    jpeg("upset_plot.jpeg", width = width, height = height, units = 'px',res = res)
    print(UpSetR::upset(upsetdf,order.by = order.by,nsets = nsets, number.angles = number.angles,point.size = point.size, line.size = line.size,
                        mainbar.y.label = ylab,
                        sets.x.label = xlab,
                        sets.bar.color = sets.bar.color,
                        text.scale = c(1.2, 1.3, 1, 1, 1.2, 1.6)))
    dev.off()
  }
  else
  {
    png("upset_plot.png", width = width, height = height, units = 'px',res = res)
    print(UpSetR::upset(upsetdf,order.by = order.by,nsets = nsets, number.angles = number.angles,point.size = point.size, line.size = line.size,
                        mainbar.y.label = ylab,
                        sets.x.label = xlab,
                        sets.bar.color = sets.bar.color,
                        text.scale = c(1.2, 1.3, 1, 1, 1.2, 1.6)))
    dev.off()
  }
}
