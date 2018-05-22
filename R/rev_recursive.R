#' Review recursive function calls
#'
#' @description
#' `rev_recursive()` counts the number of functions that depend on each function in the package under review
#'
#' #' @author Joyce Robbins \url{https://github.com/jtr13}
#'
#' @inheritParams  rev_fn_summary
#'
#' @return A two-column dataframe
#'
#' @export
#'
#' @examples
#' \dontrun{
#' rev_recursive()
#' }
rev_recursive <- function(path = ".", igraph_obj = NULL) {

  if(is.null(igraph_obj))
    igraph_obj <- create_package_igraph(path = path)

  order <- length(igraph::V(igraph_obj))
  function_list <- igraph::ego(igraph_obj, order = order, mode = "out", mindist = 1)

  function_list %>%
    purrr::map(names) %>%
    unlist() %>%
    data.frame() %>%
    stats::setNames("f_name") %>%
    dplyr::group_by(f_name) %>%
    dplyr::summarize(all_called_by = n())
}
