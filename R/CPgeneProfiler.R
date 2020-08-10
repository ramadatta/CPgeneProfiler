#' Generate a profile of carbapenamase genes from the genome assemblies
#'
<<<<<<< HEAD
<<<<<<< HEAD
#' `CPgeneProfiler` checks for a list of CarbaPenamase (CP) genes from a list of
#' input genome assemblies provided in fasta file format. It reports the profile of all
#' the CP genes available in the genome assemblies in the format of simple heatmap.
#' Apart from this, it also reports the presence of cocarriage of CP genes across the
#' input genome assemblies. Other assembly statistics such as N50, N90, Assembly Size from the
#' assembly are calculated and plots of length distribution of CP gene contigs from
#' the list of assemblies are reported. The following functions are used to run
#' CPgeneProfiler: `cpblast()`,`filt_blast`,`cocarriage()`,`cpprofile()`,`upsetR_plot()`,
#' `plot_conlen()`,`assemblystat()`, `db_summary()`, `cp_summarize()`
#'
#' @docType package
#' @name CPgeneProfiler
NULL



=======
=======
>>>>>>> 8b4803c980595a95edd1ca1e46a9633c509f109b
#' CPgene-profiler checks for a list of CarbaPenamase (CP) genes from a list of
#' genome assemblies provided in fasta file format. It reports the profile of all
#' the CP genes available in the genome assemblies in the format of simple heatmap.
#' Apart from this, it also reports the presence of co-carriage of CP genes within
#' an assembly. Other assembly statistics such as N50, N90, Assembly Size from the
#' assembly are calculated and plots of length distribution of CP gene contigs from
#' the list of assemblies are reported.
#'
#' @param fastafiles_location Need folder location with all the fasta files to check for CP genes
#' @param db_location Need folder location of the downloaded ARG-annot_CPGene_DB.fasta file
#' @export

CPgeneProfiler <- function(fastafiles_location,db_location){
  
  fastalocation <- fastafiles_location
  dblocation <- db_location
  
  setwd(dblocation)
  getwd()
  
  # Create a BLAST database
  makeblastdb = "makeblastdb"
  system2(
    command = makeblastdb,
    args = c(
      "-in",
      'ARG-annot_CPGene_DB.fasta',
      "-dbtype",
      "nucl",
      "-parse_seqids",
      "-out",
      'ARG-annot_CPGene.DB',
      "-logfile",
      "log"
    ),
    wait = TRUE,
  )
  blast_db_location = getwd() # for later use
  
  ############--------GO TO ASSEMBLY FILES LOCATION------##########
  
  setwd(fastalocation)
  getwd()
  
  ############--------CLEANING IF PREVIOUS OUTPUT FOLDER EXISTS------##########
  
  if (dir.exists("CPgeneProfiler_Output")) {
    unlink("CPgeneProfiler_Output", recursive = TRUE)
  } else {
    #print("Dir already exists!")
  }
  
  ############--------VARIABLES------##########
  
  blast_db = paste(blast_db_location, "ARG-annot_CPGene.DB", sep = "/")
  blastn = "blastn"
  evalue = 1e-6
  format = "\'6 qseqid sseqid pident nident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen\'"
  num_threads <-
    system2(
      command = "nproc",
      args =  c("--all"),
      wait = TRUE,
      stdout = TRUE
    )
  
  colnames <- c(
    "assemblyName",
    "qseqid",
    "sseqid",
    "pident",
    "nident",
    "length",
    "mismatch",
    "gapopen",
    "qstart",
    "qend",
    "sstart",
    "send",
    "evalue",
    "bitscore",
    "qlen",
    "slen"
  )
  
  
  
  ############--------CALCULATING TIME------##########
  old <- Sys.time()
  
  ############--------1) BLASTN ASSEMBLY ON ARG-ANNOT DATA------##########
  
  #List of all the fasta files
  files <- list.files(pattern = "*.fasta$|*.fa$", recursive = F)
  
  ## Read in all files using a for loop and perform BLASTN and save the results in a output
  
  datalist = list()
  for (i in 1:length(files)) {
    tmpInput <- files[i]
    #  filepath1 <- system.file("extdata", tmpInput, package="Biostrings")
    #  Biostrings::fasta.seqlengths(filepath1, seqtype="DNA")
    #  seqs <- readDNAStringSet(filepath1)
    min.length <- 0
    seqs <- Biostrings::readDNAStringSet(tmpInput)
    #seqs <- seqs[width(seqs) >= min.length] #no need to cut off
    #names(seqs) <- gsub("^", "contig_", 1:length(seqs)) #no need to change names
    names(seqs)
    
    # calculate assembly statistics from contig lengths
    
    lengths.table <- sort(Biostrings::width(seqs))
    lengths <-
      data.frame(ctg_number = 1:length(seqs),
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
    
    input = files[i]
    
    blast_out <- paste(input,
                       system2(
                         command = blastn,
                         args = c(
                           "-db",
                           blast_db,
                           "-query",
                           input,
                           "-outfmt",
                           format,
                           "-evalue",
                           evalue,
                           "-ungapped",
                           "-num_threads",
                           num_threads
                         ),
                         wait = TRUE,
                         stdout = TRUE
                       ),
                       sep = "\t")
    write.table(
      blast_out,
      "blastResults.txt",
      row.names = FALSE,
      col.names = FALSE,
      append = TRUE,
      quote = FALSE
    ) ##OUTPUT1
    
  }
  
  #Formatting BLAST results
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
  #detach("package:tidyr", unload=TRUE)
  pdf("N50_N90.pdf", width = 8, height = 10)
  print(ggplot2::ggplot(big_data, mapping = ggplot2::aes(x = assemblySize, y = N50)) + ggplot2::geom_point(size =
                                                                                                             3, colour = "#0072B2") +
          ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                      breaks = scales::pretty_breaks(n = 10)) +
          ggplot2::scale_y_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                      breaks = scales::pretty_breaks(n = 10)) +
          ggplot2::ggtitle("Assembly Size vs N50 plot") +
          ggplot2::theme_bw() + ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90)) +
          ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")))
  
  
  print( 
    ggplot2::ggplot(big_data, mapping = ggplot2::aes(x = assemblySize, y = N90)) + ggplot2::geom_point(size =
                                                                                                         3, colour = "#D55E00") +
      ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                  breaks = scales::pretty_breaks(n = 10)) +
      ggplot2::scale_y_continuous(labels = scales::unit_format(unit = "MB", scale = 1e-6),
                                  breaks = scales::pretty_breaks(n = 10)) +
      ggplot2::ggtitle("Assembly Size vs N90 plot") +
      ggplot2::theme_bw() + ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90)) +
      ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")))
  
  
  #N50_plot
  #N90_plot
  dev.off()
  
  #Filtering blast results
  
  blastResults_df <-
    utils::read.table("blastResults.txt", sep = "\t", fill = TRUE)
  #blastResults_df
  blastResults_df <-
    blastResults_df[complete.cases(blastResults_df),]
  
  
  ############--------ADD COLNAMES TO BLASTN OUTPUT TO A TABLE ------##########
  names(blastResults_df) <- colnames
  
  ############--------FIND CP GENE CONTAINING CONTIGS WITH CPGENE MATCHING 100% ID AND COVERAGE ------##########
  blastResults_df$cov <- blastResults_df$nident / blastResults_df$slen
  #head(blastResults_df)
  
  #----TRIMMING STRINGS IN THE TABLE
  blastResults_df$sseqid <- gsub("\\(Bla\\)", "", blastResults_df$sseqid)
  blastResults_df$sseqid <- gsub("[:_].*", "", blastResults_df$sseqid)
  #head(blastResults_df)
  
  ## 1) Can create a table with AssemblyName | CP contig | Length | CPgene- coordinates from BLAST
  
  blastResults.filt <-
    blastResults_df[blastResults_df$cov == 1 &
                      blastResults_df$pident == 100, c("assemblyName" , "qseqid", "sseqid", "qlen", "qstart", "qend")] # subsets only the gene name with if CP gene has 100% cov
  write.table(
    blastResults.filt,
    "blastResults.filt.txt",
    row.names = FALSE,
    col.names = FALSE,
    append = TRUE,
    quote = FALSE
  ) # ##OUTPUT3 contains AssemblyName | CP contig | Length | CPgene- coordinates from BLAST | Circular/Linear Contig
  #blastResults.filt
  
  ## 2)  Plot length in chart for each CPgene - Save all the plot in single PDF - DONE!
  
  NDMqlen <-
    subset(
      blastResults_df,
      blastResults_df$cov == 1 &
        blastResults_df$pident == 100 &
        grepl("NDM", sseqid)
    )[, "qlen", drop = FALSE]
  
  names(NDMqlen) <- c("NDMqlen")
  #NDMqlen
  
  KPCqlen <-
    subset(
      blastResults_df,
      blastResults_df$cov == 1 &
        blastResults_df$pident == 100 &
        grepl("KPC", sseqid)
    )[, "qlen", drop = FALSE]
  names(KPCqlen) <- c("KPCqlen")
  #KPCqlen
  #class(KPCqlen)
  
  OXAqlen <-
    subset(
      blastResults_df,
      blastResults_df$cov == 1 &
        blastResults_df$pident == 100 &
        grepl("OXA", sseqid)
    )[, "qlen", drop = FALSE]
  names(OXAqlen) <- c("OXAqlen")
  
  IMIqlen <-
    subset(
      blastResults_df,
      blastResults_df$cov == 1 &
        blastResults_df$pident == 100 &
        grepl("IMI", sseqid)
    )[, "qlen", drop = FALSE]
  names(IMIqlen) <- c("IMIqlen")
  
  IMPqlen <-
    subset(
      blastResults_df,
      blastResults_df$cov == 1 &
        blastResults_df$pident == 100 &
        grepl("IMP", sseqid)
    )[, "qlen", drop = FALSE]
  names(IMPqlen) <- c("IMPqlen")
  
  VIMqlen <-
    subset(
      blastResults_df,
      blastResults_df$cov == 1 &
        blastResults_df$pident == 100 &
        grepl("VIM", sseqid)
    )[, "qlen", drop = FALSE]
  names(VIMqlen) <- c("VIMqlen")
  
  ##Generate the tables histogram tables for the CPgene lengths
  
  CPcontlen <- function(cl)
  {
    #https://stackoverflow.com/a/27889176
    
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
  
  #Passing the values to the function "CPcontlen" above
  
  #Pass the values only if NDMqlen dataframe is not null. Because if df is null,it will throw error
  
  if (nrow(NDMqlen) != 0) {
    N_Hist <- CPcontlen(NDMqlen$NDMqlen)
    names(N_Hist) <- c("ContigSize_Range", "CPContig_Number")
    #N_Hist
    # Creating Histogram tables for NDM genes contig sizes
    
    line = "\n\n========++++++++NDM Contig Size Distribution+++++++++++============\n"
    write(line, file = "CPContigSizeDist.txt", append = TRUE)
    suppressWarnings(
      write.table(
        N_Hist,
        file = "CPContigSizeDist.txt",
        row.names = FALSE,
        quote = FALSE,
        append = TRUE)
    )
    
    #Plotting the contig size distribution of NDM genes
    # pdf("NDM_Contig_Dist.pdf", width = 8, height = 10)
    # print(ggplot2::ggplot() + ggplot2::geom_histogram(ggplot2::aes(NDMqlen$NDMqlen), fill = 'orange', color =
    #                                                 'white') +  ggplot2::xlab("Contig Length") + ggplot2::ylab("Number of Contigs") +
    #   ggplot2::ggtitle("NDM Carbapenamase Contig Length Distribution") + ggplot2::theme_bw() +
    #   ggplot2:: theme(axis.text.x = ggplot2::element_text(angle = 90)) +  ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")) +
    #   ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "KB", scale = 1e-3), breaks = scales::pretty_breaks(n = 15))
    # )
    # dev.off()
    
    tiff("NDM_Contig_Dist.tiff", width = 1500, height = 2000,units = 'px', res = 150)
    print(ggplot2::ggplot() + ggplot2::geom_histogram(ggplot2::aes(NDMqlen$NDMqlen), fill = 'orange', color =
                                                        'white') +  ggplot2::xlab("Contig Length") + ggplot2::ylab("Number of Contigs") +
            ggplot2::ggtitle("NDM Carbapenamase Contig Length Distribution") + ggplot2::theme_bw() +
            ggplot2:: theme(axis.text.x = ggplot2::element_text(angle = 90)) +  ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")) +
            ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "KB", scale = 1e-3), breaks = scales::pretty_breaks(n = 15))
    )
    dev.off()
    
  }
  
  if (nrow(KPCqlen) != 0) {
    K_Hist <- CPcontlen(KPCqlen$KPCqlen)
    names(K_Hist) <- c("ContigSize_Range", "CPContig_Number")
    #K_Hist
    
    # Creating Histogram tables for KPC genes contig sizes
    line = "\n\n========++++++++KPC Contig Size Distribution+++++++++++============\n"
    write(line, file = "CPContigSizeDist.txt", append = TRUE)
    suppressWarnings(
      write.table(
        K_Hist,
        file = "CPContigSizeDist.txt",
        row.names = FALSE,
        quote = FALSE,
        append = TRUE )
    )
    
    #Plotting the contig size distribution of KPC genes
    tiff("KPC_Contig_Dist.tiff", width = 1500, height = 2000,units = 'px', res = 150)
    print(ggplot2::ggplot() + ggplot2::geom_histogram(ggplot2::aes(KPCqlen$KPCqlen), fill = 'orange', color =
                                                        'white') +  ggplot2::xlab("Contig Length") + ggplot2::ylab("Number of Contigs") +
            ggplot2::ggtitle("KPC Carbapenamase Contig Length Distribution") + ggplot2::theme_bw() +
            ggplot2:: theme(axis.text.x = ggplot2::element_text(angle = 90)) +  ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")) +
            ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "KB", scale = 1e-3), breaks = scales::pretty_breaks(n = 15))
    )
    dev.off()
  }
  
  if (nrow(OXAqlen) != 0) {
    O_Hist <- CPcontlen(OXAqlen$OXAqlen)
    names(O_Hist) <- c("ContigSize_Range", "CPContig_Number")
    #O_Hist
    # Creating Histogram tables for OXA genes contig sizes
    line = "\n\n========++++++++OXA Contig Size Distribution+++++++++++============\n"
    write(line, file = "CPContigSizeDist.txt", append = TRUE)
    suppressWarnings(
      write.table(
        O_Hist,
        file = "CPContigSizeDist.txt",
        row.names = FALSE,
        quote = FALSE,
        append = TRUE
      ))
    
    #Plotting the contig size distribution of OXA genes
    tiff("OXA_Contig_Dist.tiff", width = 1500, height = 2000,units = 'px', res = 150) 
    print(ggplot2::ggplot() + ggplot2::geom_histogram(ggplot2::aes(OXAqlen$OXAqlen), fill = 'orange', color =
                                                        'white') +  ggplot2::xlab("Contig Length") + ggplot2::ylab("Number of Contigs") +
            ggplot2::ggtitle("OXA Carbapenamase Contig Length Distribution") + ggplot2::theme_bw() +
            ggplot2:: theme(axis.text.x = ggplot2::element_text(angle = 90)) +  ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")) +
            ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "KB", scale = 1e-3), breaks = scales::pretty_breaks(n = 15))
    )
    dev.off()
  }
  
  if (nrow(IMIqlen) != 0) {
    IMI_Hist <- CPcontlen(IMIqlen$IMIqlen) # Change IMI_Hist
    names(IMI_Hist) <- c("ContigSize_Range", "CPContig_Number")
    #IMI_Hist
    # Creating Histogram tables for IMI genes contig sizes
    line = "\n\n========++++++++IMI Contig Size Distribution+++++++++++============\n"
    write(line, file = "CPContigSizeDist.txt", append = TRUE)
    suppressWarnings(
      write.table(
        IMI_Hist,
        file = "CPContigSizeDist.txt",
        row.names = FALSE,
        quote = FALSE,
        append = TRUE
      ))
    
    #Plotting the contig size distribution of IMI genes
    tiff("IMI_Contig_Dist.tiff", width = 1500, height = 2000,units = 'px', res = 150) 
    print(ggplot2::ggplot() + ggplot2::geom_histogram(ggplot2::aes(IMIqlen$IMIqlen), fill = 'orange', color =
                                                        'white') +  ggplot2::xlab("Contig Length") + ggplot2::ylab("Number of Contigs") +
            ggplot2::ggtitle("IMI Carbapenamase Contig Length Distribution") + ggplot2::theme_bw() +
            ggplot2:: theme(axis.text.x = ggplot2::element_text(angle = 90)) +  ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")) +
            ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "KB", scale = 1e-3), breaks = scales::pretty_breaks(n = 15))
    )
    dev.off()
  }
  
  if (nrow(IMPqlen) != 0) {
    IMP_Hist <- CPcontlen(IMPqlen$IMPqlen)
    names(IMP_Hist) <- c("ContigSize_Range", "CPContig_Number")
    #IMP_Hist
    # Creating Histogram tables for IMP genes contig sizes
    line = "\n\n========++++++++IMP Contig Size Distribution+++++++++++============\n"
    write(line, file = "CPContigSizeDist.txt", append = TRUE)
    suppressWarnings(
      write.table(
        IMP_Hist,
        file = "CPContigSizeDist.txt",
        row.names = FALSE,
        quote = FALSE,
        append = TRUE
      ))
    
    #Plotting the contig size distribution of IMP genes
    tiff("IMP_Contig_Dist.tiff", width = 1500, height = 2000,units = 'px', res = 150) 
    print(ggplot2::ggplot() + ggplot2::geom_histogram(ggplot2::aes(IMPqlen$IMPqlen), fill = 'orange', color =
                                                        'white') +  ggplot2::xlab("Contig Length") + ggplot2::ylab("Number of Contigs") +
            ggplot2::ggtitle("IMP Carbapenamase Contig Length Distribution") + ggplot2::theme_bw() +
            ggplot2:: theme(axis.text.x = ggplot2::element_text(angle = 90)) +  ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")) +
            ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "KB", scale = 1e-3), breaks = scales::pretty_breaks(n = 15))
    )
    dev.off()
  }
  
  if (nrow(VIMqlen) != 0) {
    VIM_Hist <- CPcontlen(VIMqlen$VIMqlen)
    names(VIM_Hist) <- c("ContigSize_Range", "CPContig_Number")
    #VIM_Hist
    # Creating Histogram tables for VIM genes contig sizes
    line = "\n\n========++++++++VIM Contig Size Distribution+++++++++++============\n"
    write(line, file = "CPContigSizeDist.txt", append = TRUE)
    suppressWarnings(
      write.table(
        VIM_Hist,
        file = "CPContigSizeDist.txt",
        row.names = FALSE,
        quote = FALSE,
        append = TRUE
      ))
    
    #Plotting the contig size distribution of VIM genes
    tiff("VIM_Contig_Dist.tiff", width = 1500, height = 2000,units = 'px', res = 150) 
    print(ggplot2::ggplot() + ggplot2::geom_histogram(ggplot2::aes(VIMqlen$VIMqlen), fill = 'orange', color =
                                                        'white') +  ggplot2::xlab("Contig Length") + ggplot2::ylab("Number of Contigs") +
            ggplot2::ggtitle("VIM Carbapenamase Contig Length Distribution") + ggplot2::theme_bw() +
            ggplot2:: theme(axis.text.x = ggplot2::element_text(angle = 90)) +  ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")) +
            ggplot2::scale_x_continuous(labels = scales::unit_format(unit = "KB", scale = 1e-3), breaks = scales::pretty_breaks(n = 15))
    )
    dev.off()
  }
  
  #----CREATE A MATRIX
  blastResults_Matrix <-
    table(blastResults_df[blastResults_df$cov == 1 &
                            blastResults_df$pident == 100, c("assemblyName" , "sseqid")]) # subsets only the gene name with if CP gene has 100% cov
  #head(blastResults_Matrix)
  
  # # 3) Report how many Assemblies have co-carriage
  
  dupAssemblies_logical <-
    duplicated(blastResults.filt[, c("assemblyName")]) |
    duplicated(blastResults.filt[, c("assemblyName")], fromLast = TRUE)
  dupAssemblies <- blastResults.filt[dupAssemblies_logical, ]
  #length(unique(dupAssemblies$assemblyName)) ## This many assemblies have multiple genes or same genes in various places
  #head(dupAssemblies)
  
  ##SAMECP_SAMECONTIG - Done!
  '%>%' <- purrr::`%>%`
  
  SameCP_SameContig <- dupAssemblies %>%
    dplyr::group_by(assemblyName, qseqid, sseqid) %>%
    dplyr::filter(dplyr::n() > 1)
  # print(n = Inf)
  
  #SameCP_SameContig
  
  ##SAMECP_DIFFCONTIG - groupby AssemblyName and sseqid - Done!
  
  # For example, batch0_01032019_ENT1675_assembly.fasta and KPC-2 are grouped as one entity (something like a key) and filtered if they have distinct qseqid more than 1.
  #In this case of course, it have 2 qseqid for the record so it is displayed
  
  SameCP_DiffContig <- dupAssemblies %>%
    dplyr::group_by(assemblyName, sseqid) %>%
    dplyr::mutate(key = dplyr::n_distinct(qseqid)) %>%
    dplyr::filter(key > 1)  %>%
    dplyr::select(-key)
  # %>% print(n = Inf)
  
  #SameCP_DiffContig
  
  
  ##DIFFCP_SAMECONTIG
  
  DiffCP_SameContig <- dupAssemblies %>%
    dplyr::mutate(key = paste0(sseqid)) %>%
    dplyr::group_by(assemblyName, qseqid) %>%
    dplyr::filter( dplyr::n_distinct(key) > 1) %>%
    dplyr::select(-key)
  # %>% print(n = Inf)
  
  #DiffCP_SameContig
  
  ##DIFFCP_DIFFCONTIG
  
  DiffCP_DiffContig <- dupAssemblies %>%
    dplyr::mutate(key = paste0(qseqid)) %>%
    dplyr::group_by(assemblyName) %>%
    dplyr::filter(dplyr::n_distinct(key) > 1 | dplyr::n() == 1) %>%
    dplyr::select(-key) %>%
    dplyr::mutate(key2 = paste0(sseqid)) %>%
    dplyr::group_by(assemblyName) %>%
    dplyr::filter(dplyr::n_distinct(key2) > 1 | dplyr::n() == 1) %>%
    dplyr::select(-key2)
  # %>% print(n = Inf)
  
  #DiffCP_DiffContig
  # %>% print(n = Inf)
  
  write.table(
    DiffCP_DiffContig,
    "DiffCP_DiffContig.txt",
    row.names = FALSE,
    col.names = TRUE,
    quote = FALSE
  ) ## Save DiffCP_DiffContig output to txt file ##OUTPUT5
  
  
  write.table(
    DiffCP_SameContig,
    "DiffCP_SameContig.txt",
    row.names = FALSE,
    col.names = TRUE,
    quote = FALSE
  ) ## Save DiffCP_SameContig output to txt file ##OUTPUT6
  
  
  write.table(
    SameCP_DiffContig,
    "SameCP_DiffContig.txt",
    row.names = FALSE,
    col.names = TRUE,
    quote = FALSE
  ) # Output contains SameCP_DiffContig ##OUTPUT7
  
  
  write.table(
    SameCP_SameContig,
    "SameCP_SameContig.txt",
    row.names = FALSE,
    col.names = TRUE,
    quote = FALSE
  ) # Output contains SameCP_DiffContig ##OUTPUT8
  
  SameCP_SameContig_Count <- length(unique(SameCP_SameContig$assemblyName))
  SameCP_DiffContig_Count <- length(unique(SameCP_DiffContig$assemblyName))
  DiffCP_DiffContig_Count <- length(unique(DiffCP_DiffContig$assemblyName))
  DiffCP_SameContig_Count <- length(unique(DiffCP_SameContig$assemblyName))
  
  # SameCP_SameContig_Count
  # SameCP_DiffContig_Count
  # DiffCP_DiffContig_Count
  # DiffCP_SameContig_Count
  
  # Creating text file for the filtered co-carriage
  
  cat(
    "Assemblies with SameCP_SameContig_Count are : ",
    SameCP_SameContig_Count,
    file = "Co-carriage_Report.txt",
    append = TRUE
  )
  cat(
    "\nAssemblies with SameCP_DiffContig_Count are : ",
    SameCP_DiffContig_Count,
    file = "Co-carriage_Report.txt",
    append = TRUE
  )
  cat(
    "\nAssemblies with DiffCP_DiffContig_Count are : ",
    DiffCP_DiffContig_Count,
    file = "Co-carriage_Report.txt",
    append = TRUE
  )
  cat(
    "\nAssemblies with DiffCP_SameContig_Count are : ",
    DiffCP_SameContig_Count,
    file = "Co-carriage_Report.txt",
    append = TRUE
  )
  
  
  #----CREATE A PRESENCE/ABSENCE MATRIX
  
  blastResults_BinaryMatrix <-
    as.matrix((blastResults_Matrix > 0) + 0) ## Convert to binary matrix
  
  blastResults_MatrixLong <- reshape2::melt(blastResults_Matrix) ##long format
  
  # Heatmap of CPgene presence-absence matrix profile
  
  # heatMap_ggplot <- 
  #   ggplot2::ggplot(blastResults_MatrixLong, ggplot2::aes(sseqid, assemblyName)) +
  #   ggplot2::geom_tile(ggplot2::aes(fill = value), colour = "white") +
  #   ggplot2::scale_fill_gradient(low = "#143D59", high = "#F4B41A") +  ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
  #   ggplot2::xlab("Carbapenamase Genes") + ggplot2::ylab("Assembly") +
  #   ggplot2::ggtitle("Carbapenamase Gene Profile Heatmap ")  ##https://www.tailorbrands.com/blog/logo-color-combinations
  
  #heatMap_ggplot
  tiff("CPgeneProfile.tiff", width = 1500, height = 2000, units = 'px',res = 150)
  print(ggplot2::ggplot(blastResults_MatrixLong, ggplot2::aes(sseqid, assemblyName)) +
          ggplot2::geom_tile(ggplot2::aes(fill = value), colour = "white") +
          ggplot2::scale_fill_gradient(low = "#143D59", high = "#F4B41A") +  ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
          ggplot2::xlab("Carbapenamase Genes") + ggplot2::ylab("Assembly") +
          ggplot2::ggtitle("Carbapenamase Gene Profile Heatmap ")  ##https://www.tailorbrands.com/blog/logo-color-combinations
  )
  dev.off()
  
  # # Save the CPgene Profile plots in tiff
  # tiff("CPgeneProfile.tiff", width = 1500, height = 2000, units = 'px',res = 150)
  # heatMap_ggplot
  # dev.off()
  
  
  ############--------3) FIND INTERSECTIONS OF CPGENES IN VARIOUS ASSEMBLIES USING UPSETR------##########
  write.csv(
    blastResults_BinaryMatrix,
    file = "cp_presence-abence_matrix.csv",
    row.names = TRUE,
    quote = FALSE
  ) ##OUTPUT9
  
  upsetdf <-
    utils::read.csv(file = "cp_presence-abence_matrix.csv", check.names = FALSE)
  
  upset_plot <- 
    UpSetR::upset(
      upsetdf,
      order.by = "degree",
      nsets = 40,
      number.angles = 0,
      point.size = 1.5,
      line.size = 1,
      mainbar.y.label = "Sample Count",
      sets.x.label = "Carbapenamase Gene Set Size",
      sets.bar.color = "red",
      text.scale = c(1.2, 1.3, 1, 1, 1.2, 1.6)
    ) ##OUTPUT10
  
  #tiff("upSetR.tiff", width = 1500, height = 2000, units = 'px',res = 150)
  pdf("upSetR.pdf", width = 8, height = 10)
  print(UpSetR::upset(upsetdf,order.by = "degree",nsets = 40, number.angles = 0,point.size = 1.5, line.size = 1,
                      mainbar.y.label = "Sample Count",
                      sets.x.label = "Carbapenamase Gene Set Size",
                      sets.bar.color = "red",
                      text.scale = c(1.2, 1.3, 1, 1, 1.2, 1.6))
  )
  dev.off()
  
  ############--------CLEANING IF PREVIOUS OUTPUT FILE EXISTS------##########
  #getwd()
  files.to.move <- list.files(pattern = "txt|pdf|csv|png|jpg|tiff")
  dir.create("CPgeneProfiler_Output")
  base::invisible(file.copy(files.to.move, "CPgeneProfiler_Output")) #invisible silently copies/removes files in R
  base::invisible(file.remove(files.to.move))
  
  # ELAPSED TIME
  new <- Sys.time() - old # calculate difference
  print(new) # print in nice format
  # ELAPSED TIME
}
<<<<<<< HEAD
>>>>>>> 8b4803c980595a95edd1ca1e46a9633c509f109b
=======
>>>>>>> 8b4803c980595a95edd1ca1e46a9633c509f109b
