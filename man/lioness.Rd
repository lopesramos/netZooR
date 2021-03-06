% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LIONESS.R
\name{lioness}
\alias{lioness}
\title{Run python implementation of LIONESS}
\usage{
lioness(e = expression, m = motif, ppi = ppi, rm_missing = FALSE,
  start_sample = 1, end_sample = "None", save_dir = "lioness_output",
  save_fmt = "npy")
}
\arguments{
\item{e}{Character string indicating the file path of expression values file, as each gene (row) by samples (columns) \emph{required}}

\item{m}{Character string indicating the file path of pair file of motif edges,
when not provided, analysis continues with Pearson correlation matrix. \emph{optional}}

\item{ppi}{Character string indicating the pair file path of Protein-Protein interaction dataset. \emph{optional}}

\item{rm_missing}{Boolean indicating whether to remove missing values. If TRUE, removes missing values.
if FALSE, keep missing values. The default value is FALSE. \emph{optional}}

\item{start_sample}{Numeric indicating the start sample number, The default value is 1.}

\item{end_sample}{Numeric indicating the start sample number, The default value is None. \emph{optional}}

\item{save_dir}{Character string indicating the folder name of output lioness networks for each sample by defined.\emph{optional}
The default is a folder named "lioness_output" under current working directory.}

\item{save_fmt}{Character string indicating the format of lioness network of each sample. The dafault is "npy". The option is txt, npy, or mat.}
}
\value{
A data frame with columns representing each sample, rows representing the regulator-target pair in PANDA network generated by \code{\link{runPanda}}. 
        Each cell filled with the related score, representing the estimated contribution of a sample to the aggregate network.
}
\description{
\strong{LIONESS}(Linear Interpolation to Obtain Network Estimates for Single Samples) is a method to estimate sample-specific regulatory networks.
 \href{https://arxiv.org/abs/1505.06440}{[(LIONESS arxiv paper)])}.
}
\examples{

# refer to the input datasets files of control in inst/extdat as example
control_expression_file_path <- system.file("extdata", "expr10_matched.txt", package = "netZooR", mustWork = TRUE)
motif_file_path <- system.file("extdata", "chip_matched.txt", package = "netZooR", mustWork = TRUE)
ppi_file_path <- system.file("extdata", "ppi_matched.txt", package = "netZooR", mustWork = TRUE)

# Run LIONESS algorithm
control_lioness_result <- lioness(e = control_expression_file_path, m = motif_file_path, ppi = ppi_file_path, rm_missing = TRUE,start_sample=1, end_sample=2)

}
