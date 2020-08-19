#' Generate a profile of carbapenamase genes from the genome assemblies
#'
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



