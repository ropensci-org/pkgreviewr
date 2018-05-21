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
pkg_report <- function(pkgdir = ".", output_file = NULL,
                       save_obj = FALSE, obj_dir = NULL) {

    pkg <-as.package(pkgdir)
    pkgname <- pkg$package
  if(is.null(output_file)) {
    td <- tempdir()
    output_file <- file.path(td, paste0(pkgname, "-report.html"))
  }

  if(is.null(obj_dir)) {
    obj_dir <- file.path(pkgdir, "pkg-report")
  }
  render(system.file("templates", "pkg-report.Rmd", package="pkgreviewer"),
         params = list(pkgdir = pkgdir, save_obj = save_obj, obj_dir = NULL),
         output_file = output_file)

  return(output_file)
}
