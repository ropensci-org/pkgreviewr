#' Return a table with package functions call summary
#' 
#' @inheritParams functionMap::map_r_package 
#' @param igraph_obj igraph object for function calls dependencies returned by `create_package_igraph()`
#' 
#' @return a table with package functions call summary
#' @export
#' 
rev_fn_summary <- function(path = ".", igraph_obj = NULL){
  
  fn_igraph_obj <- create_package_igraph()
  ## get functions direct calls/called by count
  rev_calls_res <- rev_calls(path = path, igraph_obj = fn_igraph_obj)
  
  ## get functions recursive calls
  rev_rec_res <- rev_recursive(path = path, igraph_obj = fn_igraph_obj)
  
  rev_signature_res <- rev_signature(path = path)
  
  ## merge results
  res <- merge(rev_calls_res, rev_rec_res, all.x = TRUE)
  res <- merge(res, rev_signature_res, all.x = TRUE)
  res[is.na(res)] <- 0
  
  res[,c("f_args","called_by","calls","exported","all_called_by")]
  
}

#' Create a dataframe of functions that a called and called by
#' 
#' Create a dataframe of all functions in and used by the package
#' 
#' @inheritParams rev_fn_summary
#' 
#' @return A dataframe of functions in and used by the package and the number of times they are called and called by
#' 
#' @export

rev_calls <- function(path = ".", igraph_obj = NULL){
  
  ## Get the name of the package
  package <- devtools::as.package(path)$package
  
  
  check_if_installed(package = package)
  
  if(is.null(igraph_obj)) igraph_obj <- create_package_igraph(path = path)
  
  ## 'Called by' data
  in_degree <- as.data.frame(igraph::degree(igraph_obj, mode = c("in")))
  in_degree$f_name <- rownames(in_degree)
  
  ## 'Calls' data
  out_degree <- as.data.frame(igraph::degree(igraph_obj, mode = c("out")))
  out_degree$f_name <- rownames(out_degree)
  
  ## Combine into one dataframe
  degree_df <- merge(in_degree, out_degree)
  
  colnames(degree_df) <- c("f_name","called_by", "calls")
  
  ## add exported flag to degree_df
  degree_df$exported <- igraph::vertex_attr(igraph_obj, "exported")
  
  return(degree_df)
}


rev_signature <- function(path = "."){
  ## Get the name of the package
  package <- devtools::as.package(path)$package
  
  check_if_installed(package)
  f_name <- unclass(lsf.str(envir = asNamespace(package), all = TRUE))
  
  f_bare_args <- unlist(lapply(f_name, get_string_arguments, package = package))
  
  f_args <- paste0(f_name, " ", gsub("function ", "", f_bare_args))
  
  data.frame(f_name, f_args)
  
}





