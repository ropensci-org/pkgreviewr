#' Produce a package diagnostics report
#'
#' Creates an HTML report with various package summaries and diagnostics,
#' designed for initial editor review of the package and as reference for
#' authors and reviewers.
#'
#' This may fail if there is no internet access for various reasons.
#' @export
#' @importFrom rmarkdown render
#' @importFrom devtools as.package
pkg_report <- function(pkgdir = ".", output_file = NULL) {
    ## Make an absolute path if it's not
    pkgdir <- normalizePath(pkgdir)

    pkg <-as.package(pkgdir)
    pkgname <- pkg$package
  if(is.null(output_file)) {
    output_file <- file.path(paste0(pkgname, "-report.html"))
  }
  render(system.file("package-report", "pkg-report.Rmd", package="pkgreviewr"),
         params = list(pkgdir = pkgdir),  output_file = output_file)

  return(output_file)
}
