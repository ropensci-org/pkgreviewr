#' Create a dataframe of functions that a called and called by
#' 
#' Create a dataframe of all functions in and used by the package
#' 
#' @inheritParams functionMap::map_r_package 
#' 
#' @return A dataframe of functions in and used by the package and the number of times they are called and called by

rev_calls <- function(path = "."){
  
  ## Get the name of the package
  package <- devtools::as.package(path)$package
  
  
  check_if_installed(package = package)
  
  
  call_data <- create_package_igraph()
  
  
  in_degree <- as.data.frame(igraph::degree(call_data, mode = c("in")))
  in_degree$f_name <- rownames(in_degree)
  out_degree <- as.data.frame(igraph::degree(call_data, mode = c("out")))
  out_degree$f_name <- rownames(out_degree)
  
  degree_df <- merge(in_degree, out_degree)
  
  colnames(degree_df) <- c("f_name","called-by", "calls")
  
  return(degree_df)
}





