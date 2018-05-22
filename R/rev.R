#' Create a dataframe of functions that a called and called by
#' 
#' Create a dataframe of all functions in and used by the package
#' 
#' @inheritParams functionMap::map_r_package 
#' @param path package path
#' @param igraph_obj igraph object for function calls dependencies returned by `create_package_igraph()`
#' 
#' @return A dataframe of functions in and used by the package and the number of times they are called and called by
#' 
#' @export

rev_calls <- function(path = ".", igraph_obj = NULL){
  
  ## Get the name of the package
  package <- devtools::as.package(path)$package
  
  
  check_if_installed(package = package)
  
  if(is.null(igraph_obj))
    igraph_obj <- create_package_igraph(path = path)
  
  ## 'Called by' data
  in_degree <- as.data.frame(igraph::degree(igraph_obj, mode = c("in")))
  in_degree$f_name <- rownames(in_degree)
  
  ## 'Calls' data
  out_degree <- as.data.frame(igraph::degree(igraph_obj, mode = c("out")))
  out_degree$f_name <- rownames(out_degree)
  
  ## Combine into one dataframe
  degree_df <- merge(in_degree, out_degree)
  
  colnames(degree_df) <- c("f_name","called-by", "calls")
  
  ## add exported flag to degree_df
  degree_df$exported <- igraph::vertex_attr(igraph_obj, "exported")
  
  return(degree_df)
}


rev_signature <- function(path = "."){
  ## Get the name of the package
  package <- devtools::as.package(path)$package
  
  check_if_installed(package)
  f_vector <- unclass(lsf.str(envir = asNamespace(package), all = TRUE))
  
  f_names <- unlist(lapply(f_vector, get_string_arguments, package = package))
  
  f_args <- paste0(f_vector, " ", gsub("function ", "", f_names))
  
  data.frame(f_names, f_args)
  
}





