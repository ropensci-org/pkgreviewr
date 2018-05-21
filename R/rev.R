#' Create a dataframe of functions that a called and called by

rev_calls <- function(package){
  
  check_if_installed(package = package)
  
  call_data <- create_igraph_object()
  
  d_call_data <- igraph::degree(call_data)
  
  
  in_degree <- as.data.frame(d_call_data[["inDegree"]])
  in_degree$f_name <- rownames(in_degree)
  out_degree <- as.data.frame(d_call_data[["outDegree"]])
  out_degree$f_name <- rownames(out_degree)
  
  degree_df <- merge(in_degree, out_degree)
  
  colnames(degree_df) <- c("f_name","called-by", "calls")
  
  return(degree_df)
}





