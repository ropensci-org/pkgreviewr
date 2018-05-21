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


