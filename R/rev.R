#' Create a dataframe of functions that a called and called by

rev_calls <- function(path = "."){
  
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





