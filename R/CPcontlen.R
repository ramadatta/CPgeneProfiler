#' Contig length function
#'
#' This CPcontlen code function is used to generate cp gene contig
#' stats.
#'
#' @export
#'

CPcontlen <- function(cl) #cl is contiglength variable
  {
    min1 <- min(cl)
    #min1
    max1 <- max(cl) + 10000
    #max1
    br <- seq(min1, max1, by = 10000)
    #br
    ranges = paste(head(br, -1), br[-1], sep = "-")
    #ranges

    #range(NDMqlen$NDMqlen)

    freq   = hist(cl,
                  breaks = br,
                  include.lowest = TRUE,
                  plot = FALSE)
    #hist(cl, breaks=br, labels = TRUE, include.lowest=TRUE, plot=TRUE)
    data.frame(range = ranges, frequency = freq$counts)

    subset(
      data.frame(range = ranges, frequency = freq$counts),
      data.frame(range = ranges, frequency = freq$counts)$frequency > 0
    )
  }
