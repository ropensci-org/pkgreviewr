check_rstudio <- function() {
  # check if rstudio available
  if (!rstudioapi::isAvailable()) {
    stop(strwrap(paste("pkreviewr is designed to work with Rstudio version" ,
                       "1.0 and above.", "Please install or launch in Rstudio to proceed.",
                       "Visit <https://www.rstudio.com/products/rstudio/download/>",
                       " to download the latest version"), prefix = "\n"))
  }
  
  # check rstudio version > 1.0.0
  rs_version <- rstudioapi::getVersion()
  if (rs_version < "1.0.0") {
    stop(strwrap(paste("pkreviewr is designed to work with notebooks in Rstudio version" ,
                       "1.0 and above.",
                       "Please update to RStudio version 1.0 or greater to proceed.",
                       "You are running RStudio",
                       as.character(rs_version)), prefix = "\n"))
  }
}

# modified from usethis::use_git
use_git_pkgrv <- function (path = ".", message = "Initial commit") {
  if (uses_git_pkgrv(path)) {
    return(invisible())
  }
  usethis:::done("Initialising Git repo")
  r <- git2r::init(path)
  usethis::use_git_ignore(c(".Rhistory", ".RData", ".Rproj.user"))
  usethis:::done("Adding files and committing")
  paths <- unlist(git2r::status(r))
  git2r::add(r, paths)
  git2r::commit(r, message)
  invisible(TRUE)
}

# modified from usethis:::uses_git
uses_git_pkgrv <- function (path) {
  !is.null(git2r::discover_repository(path))
}

# check if a package is installed
check_if_installed <- function(package){
  if(!requireNamespace(package, quietly = TRUE)){
    stop(paste0(package, " is not installed"), call. = FALSE)
  }
} 


#' @noRd

create_package_igraph <- function(path = ".", include_base = FALSE, directed = TRUE,
                                  external = FALSE){
  
  mapped <- functionMap::map_r_package(path = path, include_base = include_base)
  
  node_df <- mapped$node_df[mapped$node_df$own == TRUE,]
  
  edge_df <- mapped$edge_df[mapped$edge_df$to %in% unique(node_df$ID),]
  edge_df <- edge_df[!duplicated(edge_df[,c('from','to')]),] ## include unique edges 

  igraph_obj <- igraph::graph_from_data_frame(edge_df, directed = directed, vertices = node_df)
  
  igraph::set_vertex_attr(igraph_obj, "exported", value = node_df$exported)
  
}

get_string_arguments <- function(funcs, package){
  v <- get(funcs, envir = asNamespace(package))
  
  if(typeof(v) == "closure"){
    return(deparse(v)[1])
  } else{
    return("not a function")
  }
}


#' Return a table with package functions call summary
#' 
#' @param path package path
#' @param igraph_obj igraph object for function calls dependencies returned by `create_package_igraph()`
#' 
#' @return a table with package functions call summary
#' @export
#' 
pkg_fn_summary <- function(path = ".", igraph_obj = NULL){
  ## get functions direct calls/called by count
  rev_calls_res <- rev_calls(path = path, igraph_obj = igraph_obj)
  
  ## get functions recursive calls
  rev_rec_res <- rev_recursive(path = path, igraph_obj = igraph_obj)
  
  ## merge results
  res <- merge(rev_calls_res, rev_rec_res, all.x = TRUE)
  res[is.na(res)] <- 0
  
  return(res)
}

