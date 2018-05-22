#' Extracts the default arguments and checks for consistency
#'
#' From a package, get all the default arguments for the functions of said
#' package. Then check how many times each argument is used and whether
#' the default value for teh argument is consistent across all functions
#' where it's used. This function also returns a matrix indicating each function
#' where the arguments are used.
#'
#' @inheritParams functionMap::map_r_package
#' @param exported_only Logical. Whether to check only the exported functions
#' or allt he functions detected by \link{rev_calls}.
#'
#' @return A two element list with \code{arg_df} and \code{arg_map}.
#' The \code{arg_df} is a data.frame with one element per argument that
#' has the name of the argument, the number of functions where it's used,
#' whether the default is consistent across all functions and percent
#' of consistency.
#' \code{arg_map} is a logical matrix with the functions in the rows and the
#' arguments in the columns. It specifies which functions use which arguments.
#'
#' @author Leonardo Collado-Torres \url{https://github.com/lcolladotor}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ## If your current working directory is the home of a package, use:
#' rev_args('.')
#' }
#'

rev_args <- function(path = '.', exported_only = FALSE) {

    ## Get the functions from rev() and their exported status
    degree_df <- pkgreviewr::rev_calls(path)

    ## Subset if necessary and check that we have data to work with
    if(exported_only) degree_df <- degree_df[degree_df$exported, ]
    stopifnot(nrow(degree_df) > 0)

    ## From rev(). Get the package name and check that it's installed
    pkg <- devtools::as.package(path)$package
    check_if_installed(package = pkg)


    ## Get the list of arguments
    # Based on formals() from the last answer in
    # https://stackoverflow.com/questions/11885207/get-all-parameters-as-list
    pkg_args <- lapply(degree_df$f_name, function(fun) {
        .Internal(formals(get(fun, envir = asNamespace(pkg))))
    })
    names(pkg_args) <- degree_df$f_name


    ## Could add to degree_df the number of arguments per function
    degree_df$n_args <- sapply(pkg_args, length)

    ## Start the summary data frame for the arguments
    args_df <- data.frame(
        arg_name = unique(unlist(sapply(pkg_args, names))),
        stringsAsFactors = FALSE
    )

    ## Create a table with arguments on the columns, functions on the rows
    arg_map <- sapply(args_df$arg_name, function(arg) {
        sapply(pkg_args, function(fun) { arg %in% names(fun) })
    })

    ## Add the number of times an argument is used
    args_df$n_functions <- colSums(arg_map)


    ## Get the default values of the arguments
    get_defaults <- function(arg) {
        raw_default <- sapply(pkg_args[names(arg_map[, arg][arg_map[, arg]])], '[', arg)
        if(any(sapply(raw_default, function(x) { any(is.null(x))}))){
            ## Special case when it's NULL.
            ## This happens with the 'output_file' argument in pkgreviewr
            raw_default <- sapply(raw_default, function(x) { x[is.null(x)] <- '' })
        }
        sapply(raw_default, as.character)
    }

    ## Are the arguments consistent
    args_df$default_consistent <- sapply(
        sapply(args_df$arg_name, get_defaults), function(defaults) {
        all(sapply(defaults, function(x) x == defaults[1]))
    })

    args_df$default_consistent_percent <- sapply(
        sapply(args_df$arg_name, get_defaults), function(defaults) {
        mean(sapply(defaults, function(x) x == defaults[1])) * 100
    })


    ## Build final list
    return(list(arg_df = args_df, arg_map = arg_map))

}
