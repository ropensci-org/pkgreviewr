#' Create a review project.
#'
#' Create and initialise an rOpenSci package review project
#' @param pkg_repo character string of the repo owner and name in the form of
#'  `"owner/repo"`.
#' @param review_parent directory in which to setup review project and source package
#'  source code.
#'
#' @return setup review project with templates
# @importFrom devtools getFromNamespace github_remote
# @importFrom usethis getFromNamespace can_overwrite
#' @export
#'
#' @examples
#' \dontrun{
#' pkgreview_create(pkg_repo = "cboettig/rdflib")
#' }
pkgreview_create <- function(pkg_repo, review_parent = ".") {
    # checks
    check_rstudio()
    check_global_git()

    # create project
    meta <- devtools:::github_remote(pkg_repo)
    review_path <- normalizePath(file.path(review_parent,
                                    paste0(meta$repo, "-review")))
    ifelse(usethis:::can_overwrite(review_path),
           {unlink(review_path, recursive=TRUE)
               usethis::create_project(review_path, open = FALSE)
               unlink(file.path(review_path,"R"), recursive = TRUE)},
           {message(paste0(review_path,
                           "review project already exists."))})

    # clone package source code directory
    meta <- devtools:::github_remote(pkg_repo)
    pkg_dir <- normalizePath(file.path(review_path, "..", meta$repo), mustWork = F)
    if (!usethis:::can_overwrite(pkg_dir)){
        message(paste0("../", meta$repo,
                       ": directory already exists. repo clone skipped"))
    }else{
        if (dir.exists(pkg_dir)) {
            unlink(pkg_dir, recursive=TRUE)
        }
        git2r::clone(paste0("https://github.com/", pkg_repo), pkg_dir)
    }

    # create templates
    pkg_data <- pkgreview_getdata(pkg_dir)

    setwd(review_path)
    use_reviewtmpl()
    pkgreview_readme_md(pkg_data)
    pkgreview_index_rmd(pkg_data)

    use_git_pkgrv(path = ".")
    if (rstudioapi::isAvailable()) rstudioapi::openProject(review_path)
}



#' pkgreview_getdata
#'
#' get package metadata from package source code.
#'
#' @param pkg_dir path to the package source code directory
#'
#' @return a list of package metadata
#' @export
# @importFrom usethis getFromNamespace project_data
#' @examples
#' \dontrun{
#' pkgreview_getdata("../rdflib")
#' }
pkgreview_getdata <- function(pkg_dir) {

    pkg_data <- usethis:::package_data(pkg_dir)
    pkg_data$pkg_dir <- pkg_dir
    pkg_data$Rmd <- FALSE
    pkg_data$pkg_repo <- paste0(pkg_data$github$username, "/",
                       pkg_data$github$repo)
    pkg_data$username <- pkg_data$github$username
    pkg_data$repo <- pkg_data$github$repo
    pkg_data$whoami <- whoami::gh_username()
    pkg_data$whoami_url <- paste0("https://github.com/", pkg_data$whoami)
    pkg_data$review_repo <- paste0(pkg_data$whoami, "/",
                                  pkg_data$repo, "-review")
    pkg_data$index_url <- paste0("https://", pkg_data$whoami, ".github.io/",
                                pkg_data$repo, "-review", "/index.nb.html")
    pkg_data$pkgreview_url <- paste0("https://github.com/", pkg_data$review_repo,
                                    "/blob/master/pkgreview.md")

    pkg_data$issue_url <- issue_meta(pkg_data$pkg_repo, parameter = "url")
    pkg_data$number <- issue_meta(pkg_data$pkg_repo)


    site <- paste0("https://", pkg_data$github$username, ".github.io/",
           pkg_data$github$repo,"/")

    if(!httr::http_error(site)){
        pkg_data$site <- site}else{pkg_data$site <- NULL}

    pkg_data
}
