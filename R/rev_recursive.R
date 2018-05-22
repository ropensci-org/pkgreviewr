#' Review recursive function calls
#'
#' @description
#' `rev_recursive()` counts the number of functions that depend on each function in the package under review, taking the object of class `igraph` returned by `create_package_igraph()` as input
#'
#' @param igraph_obj object returned by `create_package_igraph()`
#'
#' @return A two-column dataframe
#' @export
#'
#' @examples
#' \dontrun{
#' rev_recursive(igraph_obj)
#' }
rev_recursive <- function(igraph_obj) {
  order <- length(V(igraph_obj))
  function_list <- igraph::ego(igraph_obj, order = order, mode = "out", mindist = 1)

  function_list %>%
    purrr::map(names) %>%
    unlist() %>%
    data.frame() %>%
    setNames("f_name") %>%
    group_by(f_name) %>%
    summarize(all_called_by = n())
}
