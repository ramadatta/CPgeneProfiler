#' Generate assembly statistics from input genomes assemblies (FASTA)
#'
#' `assemblystat()` generates basic assembly stats which includes
#' N50 size, N90 size and Genome assembly size. This function also
#' generates Assembly Size vs N50 plot and Assembly Size vs N50 plot
#'
#' @param fastalocation Location of the folder with only fasta files. The files
#' must have extensions with either `.fasta` or `.fa` format
#' @param outputType Output result file in pdf/tiff/jpeg/png format (default="tiff")
#' @param width width of the device (default=2000)
#' @param height height of the device (default=2000)
#' @param res Nominal resolution in ppi (default=250)
#' @param geom_point_size point size (default=3)
#' @param n50colorfill Hex color code of N50 plot (default= "#0072B2")
#' @param n90colorfill Hex color code of N90 plot (default= "#D55E00")
#'
#' @export
#' @examples
#'
#' assemblystat()
#' assemblystat("/home/user/CPgeneProfiler/testData/fasta", outputType="png", width = 700, height = 700, res = 150, geom_point_size=3, n50colorfill = "#0072B2", n90colorfill = "#D55E00")

assemblystat <- function(fastalocation, outputType="png", width = 700, height = 700, res = 150,
                         geom_point_size=3, n50colorfill = "#0072B2", n90colorfill = "#D55E00"){

  setwd(fastalocation)

  files <- list.files(pattern = "*.fasta$|*.fa$", recursive = F)

## Read in all files using a for loop and perform BLASTN and save the results in a output

datalist = list()
for (i in 1:length(files))
  {
  tmpInput <- files[i]
  min.length <- 0
  seqs <- Biostrings::readDNAStringSet(tmpInput)
  names(seqs)

  # calculate assembly statistics from contig lengths
  lengths.table <- sort(Biostrings::width(seqs))
  lengths <-  data.frame(ctg_number = 1:length(seqs),
               acc = cumsum(lengths.table))

  tot.length <- lengths[dim(lengths)[1], 2]
  # tot.length

  n50.idx <- which(lengths[, 2] >= tot.length * .50)[1]
  n50 <- lengths.table[n50.idx]
  # n50

  n90.idx <- which(lengths[, 2] >= tot.length * .10)[1]
  n90 <- lengths.table[n90.idx]
  #  n90

  datalist[[i]] <- cbind(files[i], n50, n90, tot.length)

 }

#Formatting assembly stats results
big_data  <- do.call(rbind.data.frame, datalist)
#big_data

big_data$V1 <- as.character(big_data$V1)
big_data$n50 <- as.numeric(as.character(big_data$n50))
big_data$n90 <- as.numeric(as.character(big_data$n90))
big_data$tot.length <- as.numeric(as.character(big_data$tot.length))

# Assigning column names
names(big_data) <- c("assemblyName", "N50", "N90", "assemblySize")
#head(big_data)

# Assembly Stats output
suppressWarnings(
  write.table(
    big_data,
    "assemblyStats.txt",
    row.names = FALSE,
    col.names = TRUE,
    append = TRUE,
    quote = FALSE
  ) ##OUTPUT2
)

# Assembly stat plots

if(outputType=="tiff")
{
  tiff("N50.tiff", width = width, height = height, units = 'px',res = res)
  print(
    ggplot2::ggplot(big_data, mapping = ggplot2::aes(x = assemblySize, y = N50)) +
      ggplot2::geom_point(size = geom_point_size, colour = n50colorfill) +
      ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                  breaks = scales::pretty_breaks(n = 10)) +
      ggplot2::scale_y_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                  breaks = scales::pretty_breaks(n = 10)) +
      ggplot2::ggtitle("Assembly Size vs N50 plot") +
      ggplot2::theme_bw() +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90)) +
      ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")))
  dev.off()

  tiff("N90.tiff", width = width, height = height, units = 'px',res = res)
  print(
    ggplot2::ggplot(big_data, mapping = ggplot2::aes(x = assemblySize, y = N90)) +
      ggplot2::geom_point(size = geom_point_size, colour = n90colorfill) +
      ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                  breaks = scales::pretty_breaks(n = 10)) +
      ggplot2::scale_y_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                  breaks = scales::pretty_breaks(n = 10)) +
      ggplot2::ggtitle("Assembly Size vs N90 plot") +
      ggplot2::theme_bw() +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90)) +
      ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")))

  dev.off()
}
else if(outputType=="jpeg")
{
  jpeg("N50.jpeg", width = width, height = height, units = 'px',res = res)
  print(
    ggplot2::ggplot(big_data, mapping = ggplot2::aes(x = assemblySize, y = N50)) +
      ggplot2::geom_point(size = geom_point_size, colour = n50colorfill) +
      ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                  breaks = scales::pretty_breaks(n = 10)) +
      ggplot2::scale_y_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                  breaks = scales::pretty_breaks(n = 10)) +
      ggplot2::ggtitle("Assembly Size vs N50 plot") +
      ggplot2::theme_bw() +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90)) +
      ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")))
  dev.off()

  jpeg("N90.jpeg", width = width, height = height, units = 'px',res = res)
  print(
    ggplot2::ggplot(big_data, mapping = ggplot2::aes(x = assemblySize, y = N90)) +
      ggplot2::geom_point(size = geom_point_size, colour = n90colorfill) +
      ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                  breaks = scales::pretty_breaks(n = 10)) +
      ggplot2::scale_y_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                  breaks = scales::pretty_breaks(n = 10)) +
      ggplot2::ggtitle("Assembly Size vs N90 plot") +
      ggplot2::theme_bw() +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90)) +
      ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")))

  dev.off()
}
else if(outputType=="png")
{
  png("N50.png", width = width, height = height, units = 'px',res = res)
  print(
    ggplot2::ggplot(big_data, mapping = ggplot2::aes(x = assemblySize, y = N50)) +
      ggplot2::geom_point(size = geom_point_size, colour = n50colorfill) +
      ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                  breaks = scales::pretty_breaks(n = 10)) +
      ggplot2::scale_y_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                  breaks = scales::pretty_breaks(n = 10)) +
      ggplot2::ggtitle("Assembly Size vs N50 plot") +
      ggplot2::theme_bw() +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90)) +
      ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")))
  dev.off()

  png("N90.png", width = width, height = height, units = 'px',res = res)
  print(
    ggplot2::ggplot(big_data, mapping = ggplot2::aes(x = assemblySize, y = N90)) +
      ggplot2::geom_point(size = geom_point_size, colour = n90colorfill) +
      ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                  breaks = scales::pretty_breaks(n = 10)) +
      ggplot2::scale_y_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                  breaks = scales::pretty_breaks(n = 10)) +
      ggplot2::ggtitle("Assembly Size vs N90 plot") +
      ggplot2::theme_bw() +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90)) +
      ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")))

  dev.off()
}
else if(outputType=="pdf")
{
pdf("N50_N90.pdf", width = 8, height = 10)

print(
        ggplot2::ggplot(big_data, mapping = ggplot2::aes(x = assemblySize, y = N50)) +
        ggplot2::geom_point(size = geom_point_size, colour = n50colorfill) +
        ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                    breaks = scales::pretty_breaks(n = 10)) +
        ggplot2::scale_y_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                    breaks = scales::pretty_breaks(n = 10)) +
        ggplot2::ggtitle("Assembly Size vs N50 plot") +
        ggplot2::theme_bw() +
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90)) +
        ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")))


print(
  ggplot2::ggplot(big_data, mapping = ggplot2::aes(x = assemblySize, y = N90)) +
    ggplot2::geom_point(size = geom_point_size, colour = n90colorfill) +
    ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                breaks = scales::pretty_breaks(n = 10)) +
    ggplot2::scale_y_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                breaks = scales::pretty_breaks(n = 10)) +
    ggplot2::ggtitle("Assembly Size vs N90 plot") +
    ggplot2::theme_bw() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90)) +
    ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")))


dev.off()
}
} #Function end
