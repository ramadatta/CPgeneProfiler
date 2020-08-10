#' Plot CP gene contig length distribution
#'
#' `plot_conlen` generates length distribution for all the CP gene
#' contigs across the input genome assemblies.
#' @param outputType Output result file in pdf/tiff/jpeg/png format (default="tiff")
#' @param width width of the device (default=700)
#' @param height height of the device (default=700)
#' @param res Nominal resolution in ppi (default=150)
#' @param xlab Label on x-axis (default="Contig Length")
#' @param ylab Label on y-axis (default="Number of Contigs")
#' @param title Title of the plot (default=" Contig Length Distribution")
#' @param element_text_angle Angle of element text(default=90),
#' @param unit x-axis units KB/MB (default="KB")
#' @param breaks Number of breaks (default=15)
#' @param colorfill bar color (default= "#F99245")
#' @param cpgcov CP gene coverage cutoff (default=100)
#' @param cpgpident CP gene percentage identity with genomic sequence (default=100)
#'
#' @export
#' @examples
#'
#' plot_conlen()
#' plot_conlen(outputType="tiff", width = 700, height = 700, res = 150, xlab="Contig Length", ylab="Number of Contigs", title=" Contig Length Distribution",element_text_angle=90,unit="KB", breaks=15, colorfill = "#F99245",cpgcov=100, cpgpident=100)


plot_conlen <- function(outputType="png", width = 700, height = 700, res = 150,
                        xlab="Contig Length", ylab="Number of Contigs",
                        title=" Contig Length Distribution",element_text_angle=90,
                        unit="KB", breaks=15,
                        colorfill = "#F99245",
                        cpgcov=100, cpgpident=100)

{
  blastResults_df <- cpcore()

  uniq_cp <- unique(subset(blastResults_df, blastResults_df$cov == cpgcov & blastResults_df$pident == cpgpident)[,"sseqid", drop = FALSE])

  for (cpgene in uniq_cp$sseqid){
    CPqlen <-
    subset(blastResults_df,blastResults_df$cov == cpgcov & blastResults_df$pident == cpgpident &
        grepl(cpgene, sseqid))[, "qlen", drop = FALSE]

    #print(cpgene)
   names(CPqlen) <- c(cpgene)
  #  print(CPqlen)

  #Passing the values to the function "CPcontlen" above
  #Pass the values only if NDMqlen dataframe is not null. Because if df is null,it will throw error
  # print(nrow(CPqlen))
  # print(length(unique(CPqlen[,cpgene])))
  if (nrow(CPqlen) != 0 ) {
    CP_Hist <- CPcontlen(CPqlen[[cpgene]]) # https://stackoverflow.com/a/19730864 $ check CPcontlen.R for function
    names(CP_Hist) <- c("ContigSize_Range", "CPContig_Number")
    #CP_Hist

      # Creating Histogram tables for NDM genes contig sizes
      line = paste0("\n\n========++++++++",cpgene," Contig Size Distribution+++++++++++============\n")
    write(line, file = "CPContigSizeDist.txt", append = TRUE)
    suppressWarnings(
      write.table(
        CP_Hist,
        file = "CPContigSizeDist.txt",
        row.names = FALSE,
        quote = FALSE,
        append = TRUE)
    )
  #  class(as.numeric(CPqlen[,cpgene]))
   # print(CPqlen[,cpgene])
   # print(length(unique(CPqlen)))

    if (outputType=="tiff" & length(unique(CPqlen[,cpgene])) >= 2 ) {
     tiff(paste0(cpgene,"_Contig_Dist.tiff"), width = 700, height = 700,units = 'px', res = 150)
      print(

              ggplot2::ggplot() +
              ggplot2::geom_histogram(ggplot2::aes(CPqlen[[cpgene]]), fill = colorfill, color ='white') +
              ggplot2::xlab(xlab) + ggplot2::ylab(ylab) +
              ggplot2::ggtitle(paste0(cpgene,title)) + ggplot2::theme_bw() +
              ggplot2:: theme(axis.text.x = ggplot2::element_text(angle = element_text_angle)) +
              ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")) +
              ggplot2::scale_x_continuous(labels = scales::unit_format(unit = unit, scale = 1e-3), breaks = scales::pretty_breaks(n = 15))
      )
    dev.off()
    }
   else if(outputType=="pdf" & length(unique(CPqlen[,cpgene])) >= 2)
  {
    pdf(paste0(cpgene,"_Contig_Dist.pdf"), paper="a4")
    print(

      ggplot2::ggplot() +
        ggplot2::geom_histogram(ggplot2::aes(CPqlen[[cpgene]]), fill = colorfill, color ='white') +
        ggplot2::xlab(xlab) + ggplot2::ylab(ylab) +
        ggplot2::ggtitle(paste0(cpgene,title)) + ggplot2::theme_bw() +
        ggplot2:: theme(axis.text.x = ggplot2::element_text(angle = element_text_angle)) +
        ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")) +
        ggplot2::scale_x_continuous(labels = scales::unit_format(unit = unit, scale = 1e-3), breaks = scales::pretty_breaks(n = 15))
    )
    dev.off()
  }
else if(outputType=="jpeg"  & length(unique(CPqlen[,cpgene])) >= 2)
{
  jpeg(paste0(cpgene,"_Contig_Dist.jpeg"), width = 700, height = 700,units = 'px', res = 150)
  print(
      ggplot2::ggplot() +
      ggplot2::geom_histogram(ggplot2::aes(CPqlen[[cpgene]]), fill = colorfill, color ='white') +
      ggplot2::xlab(xlab) + ggplot2::ylab(ylab) +
      ggplot2::ggtitle(paste0(cpgene,title)) + ggplot2::theme_bw()+
      ggplot2:: theme(axis.text.x = ggplot2::element_text(angle = element_text_angle)) +
      ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")) +
      ggplot2::scale_x_continuous(labels = scales::unit_format(unit = unit, scale = 1e-3), breaks = scales::pretty_breaks(n = 15))
  )
  dev.off()
}
else if(outputType=="png" & length(unique(CPqlen[,cpgene])) >= 2)
{
  png(paste0(cpgene,"_Contig_Dist.png"), width = 700, height = 700,units = 'px', res = 150)
  print(
    ggplot2::ggplot() +
      ggplot2::geom_histogram(ggplot2::aes(CPqlen[[cpgene]]), fill = colorfill, color ='white') +
      ggplot2::xlab(xlab) + ggplot2::ylab(ylab) +
      ggplot2::ggtitle(paste0(cpgene,title)) + ggplot2::theme_bw() +
      ggplot2:: theme(axis.text.x = ggplot2::element_text(angle = element_text_angle)) +
      ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")) +
      ggplot2::scale_x_continuous(labels = scales::unit_format(unit = unit, scale = 1e-3), breaks = scales::pretty_breaks(n = 15))
  )
  dev.off()
}

  } #if loop end
} #for loop end
} # function end


