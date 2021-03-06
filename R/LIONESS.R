#' Run python implementation of LIONESS
#'
#' \strong{LIONESS}(Linear Interpolation to Obtain Network Estimates for Single Samples) is a method to estimate sample-specific regulatory networks.
#'  \href{https://arxiv.org/abs/1505.06440}{[(LIONESS arxiv paper)])}.
#'
#' @param e Character string indicating the file path of expression values file, as each gene (row) by samples (columns) \emph{required}
#' @param m Character string indicating the file path of pair file of motif edges,
#'          when not provided, analysis continues with Pearson correlation matrix. \emph{optional}
#' @param ppi Character string indicating the pair file path of Protein-Protein interaction dataset. \emph{optional}
#' @param rm_missing Boolean indicating whether to remove missing values. If TRUE, removes missing values.
#'         if FALSE, keep missing values. The default value is FALSE. \emph{optional}
#' @param start_sample Numeric indicating the start sample number, The default value is 1.
#' @param end_sample Numeric indicating the start sample number, The default value is None. \emph{optional}
#' @param save_dir Character string indicating the folder name of output lioness networks for each sample by defined.\emph{optional}
#'        The default is a folder named "lioness_output" under current working directory.
#' @param save_fmt Character string indicating the format of lioness network of each sample. The dafault is "npy". The option is txt, npy, or mat.
#'
#' @return A data frame with columns representing each sample, rows representing the regulator-target pair in PANDA network generated by \code{\link{runPanda}}. 
#'         Each cell filled with the related score, representing the estimated contribution of a sample to the aggregate network.

#'
#' @examples
#'
#' # refer to the input datasets files of control in inst/extdat as example
#' control_expression_file_path <- system.file("extdata", "expr10_matched.txt", package = "netZooR", mustWork = TRUE)
#' motif_file_path <- system.file("extdata", "chip_matched.txt", package = "netZooR", mustWork = TRUE)
#' ppi_file_path <- system.file("extdata", "ppi_matched.txt", package = "netZooR", mustWork = TRUE)
#' 
#' # Run LIONESS algorithm
#' control_lioness_result <- lioness(e = control_expression_file_path, m = motif_file_path, ppi = ppi_file_path, rm_missing = TRUE,start_sample=1, end_sample=2)
#' 
#' @import reticulate
#' @export
lioness <- function(e = expression, m = motif, ppi = ppi, rm_missing = FALSE, start_sample=1, end_sample="None", save_dir="lioness_output", save_fmt='npy'){

  if(missing(e)){
     stop("Please provide the gene expression data file path to argument e, e.g. e=\"expression.txt\"") }
   else{ str1 <- paste("\'", e, "\'", sep = '') }
  
   if(missing(m)){
     stop("Please provide the prior motif data file path to argument m, e.g. e=\"motif.txt\"") }
   else{ str2 <- paste("\'", m, "\'", sep = '') }
  
   if(missing(ppi)){
     str3 <- paste('None')
     message("No PPI provided.") }
   else{ str3 <- paste("\'", ppi, "\'", sep = '') }
  
   if(rm_missing == FALSE | missing(e)){
     str4 <- paste('False')
     message("Not removing missing values ") }
   else { str4 <- paste('True') }
  
     str5 <- "keep_expression_matrix=True"
  
   # source the panda.py and lioness.py from GitHub raw website.
   reticulate::source_python("https://raw.githubusercontent.com/netZoo/netZooPy/netZoo/panda.py",convert = TRUE)
   reticulate::source_python("https://raw.githubusercontent.com/netZoo/netZooPy/netZoo/lioness.py",convert = TRUE)
   # run py code to create an instance named "p" of Panda Class
   str <-  paste("panda_obj=Panda(", str1, ",", str2,",", str3, ",", "remove_missing=", str4, ",", str5, ")", sep ='')
   py_run_string(str,local = FALSE, convert = TRUE)
   # assign "panda_network" with the output PANDA network
   py_run_string("panda_network=pd.DataFrame(panda_obj.export_panda_results,columns=['tf','gene','motif','force'])",local = FALSE, convert = TRUE)
   panda_net <- py$panda_network
  
   if( length(intersect(panda_net[, 1], panda_net[, 2]))>0){
     panda_net[,1] <-paste('reg_', panda_net[,1], sep='')
     panda_net[,2] <-paste('tar_', panda_net[,2], sep='')
     message("Rename the context of first two columns with prefix 'reg_' and 'tar_'" )
   }
  
   # create an instance named "lioness_obj" of Lioness Class.
   py_run_string(paste("lioness_obj = Lioness(panda_obj", " , " , "start=", start_sample," , ", "end=" ,end_sample, " , " ,"save_dir='", save_dir, "' , " , "save_fmt='" , save_fmt, "' )",sep = "" ))
   # retrieve the "total_lioness_network" attribute of instance "lionesss_obj"
   py_run_string(paste("lioness_network = lioness_obj.total_lioness_network"))
   # convert the python varible "lionesss_network" to a data.frame in R enviroment.
   lioness_net <- py$lioness_network
   # cbind the first two columns of PANDA output with LIONESS output.
   lioness_output <- cbind(panda_net[,c(1,2)], lioness_net)
   return(lioness_output)
}


