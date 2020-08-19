#' Carbapenamase Gene Profile
#'
#' `cpprofile()` creates a heatmap of carbapenamase gene profile from the input genome assemblies
#' @param outputType Output result file in pdf/tiff/jpeg/png format (default="tiff")
#' @param width width of the device (default=2000)
#' @param height height of the device (default=2000)
#' @param res Nominal resolution in ppi (default=250)
#' @param xlab Label on x-axis (default="Carbapenamase Genes")
#' @param ylab Label on y-axis (default="Assembly")
#' @param title Title of the plot (default="Carbapenamase Gene Profile Heatmap")
#' @param titlesize Title size (default=15)
#' @param labelsize Label size (default=12)
#' @param colorcode_low Hex color code for low values (default="#143D59")
#' @param colorcode_high Hex color code for high values (default="#F4B41A")
#' @param cpgcov CP gene coverage cutoff (default=100)
#' @param cpgpident CP gene percentage identity with genomic sequence (default=100)
#'
#' @export
#' @examples
#'
#' cpprofile()
#' cpprofile(outputType="png", width = 2000, height = 2000, res = 250, xlab="Carbapenamase Genes", ylab="Assembly", title="Carbapenamase Gene Profile Heatmap", titlesize=15, labelsize=12,colorcode_low = "#143D59", colorcode_high = "#F4B41A", cpgcov=100, cpgpident=100)

cpprofile <- function(outputType="png", width = 2000, height = 2000, res = 250,
                      xlab="Carbapenamase Genes", ylab="Assembly",
                      title="Carbapenamase Gene Profile Heatmap",titlesize=15,labelsize=12,
                      colorcode_low = "#143D59", colorcode_high = "#F4B41A",
                      cpgcov=100, cpgpident=100)
  {

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

#print(blastResults_BinaryMatrix)

blastResults_MatrixLong <- reshape2::melt(blastResults_Matrix) ##long format
#print(blastResults_MatrixLong)

# Heatmap of CPgene presence-absence matrix profile

if(outputType=="tiff")
{
  tiff("CPgeneProfile.tiff", width = width, height = height, units = 'px',res = res)
 p <- ggplot2::ggplot(blastResults_MatrixLong, ggplot2::aes(sseqid, assemblyName)) +
        ggplot2::geom_tile(ggplot2::aes(fill = value), colour = "white") +
        ggplot2::scale_fill_gradient(low = colorcode_low, high = colorcode_high) +
        ggplot2::xlab(xlab) + ggplot2::ylab(ylab) +
        ggplot2::ggtitle(title) +
        ggplot2::labs(fill='Gene Count')  +
        ggplot2::theme(axis.text=ggplot2::element_text(size=labelsize),
        axis.title=ggplot2::element_text(size=labelsize,face="bold"),
        axis.text.x=ggplot2::element_text(angle=90,hjust=1),
        plot.title = ggplot2::element_text(size=titlesize))
        print(p)

        dev.off()
}

else if(outputType=="pdf")
 {
   pdf("CPgeneProfile.pdf", paper="a4")
            p <- ggplot2::ggplot(blastResults_MatrixLong, ggplot2::aes(sseqid, assemblyName)) +
                ggplot2::geom_tile(ggplot2::aes(fill = value), colour = "white") +
                ggplot2::scale_fill_gradient(low = colorcode_low, high = colorcode_high) +
                ggplot2::xlab(xlab) + ggplot2::ylab(ylab) +
                ggplot2::ggtitle(title) +
                ggplot2::labs(fill='Gene Count') +
                ggplot2::theme(axis.text=ggplot2::element_text(size=labelsize),
                axis.title=ggplot2::element_text(size=labelsize,face="bold"),
                axis.text.x=ggplot2::element_text(angle=90,hjust=1),
                plot.title = ggplot2::element_text(size=titlesize))
                print(p)
                dev.off()
}
else if(outputType=="jpeg")
{
  jpeg("CPgeneProfile.jpeg", width = width, height = height, units = 'px',res = res)
  p <- ggplot2::ggplot(blastResults_MatrixLong, ggplot2::aes(sseqid, assemblyName)) +
    ggplot2::geom_tile(ggplot2::aes(fill = value), colour = "white") +
    ggplot2::scale_fill_gradient(low = colorcode_low, high = colorcode_high) +
    ggplot2::xlab(xlab) + ggplot2::ylab(ylab) +
    ggplot2::ggtitle(title) +
    ggplot2::labs(fill='Gene Count')  +
    ggplot2::theme(axis.text=ggplot2::element_text(size=labelsize),
    axis.title=ggplot2::element_text(size=labelsize,face="bold"),
    axis.text.x=ggplot2::element_text(angle=90,hjust=1),
    plot.title = ggplot2::element_text(size=titlesize))
    print(p)
    dev.off()
}
else
{
  png("CPgeneProfile.png", width = width, height = height, units = 'px',res = res)
  p <- ggplot2::ggplot(blastResults_MatrixLong, ggplot2::aes(sseqid, assemblyName)) +
    ggplot2::geom_tile(ggplot2::aes(fill = value), colour = "white") +
    ggplot2::scale_fill_gradient(low = colorcode_low, high = colorcode_high) +
    ggplot2::xlab(xlab) + ggplot2::ylab(ylab) +
    ggplot2::ggtitle(title) +  ##https://www.tailorbrands.com/blog/logo-color-combinations
    ggplot2::labs(fill='Gene Count')  +
    ggplot2::theme(axis.text=ggplot2::element_text(size=labelsize),
    axis.title=ggplot2::element_text(size=labelsize,face="bold"),
    axis.text.x=ggplot2::element_text(angle=90,hjust=1),
    plot.title = ggplot2::element_text(size=titlesize))
    print(p)
    dev.off()
}

}
