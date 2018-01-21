#' Print review package function source code
#'
#' @param pkgname character string. review package name
#'
#' @return prints out function source code for all exported functions.
#' @export
#' @importFrom magrittr %>%
#' @examples
#' \dontrun{
#' library("pkgreviewr")
#' pkgreview_print_source("pkgreviewr")
#' }
pkgreview_print_source <- function(pkgname){

    ls(paste0("package:", pkgname)) %>%
        sapply(FUN = function(x){
            cat(paste0("## ",x, "\n"))
            get(x) %>% print
            cat(paste0("--- \n \n"))})
}


