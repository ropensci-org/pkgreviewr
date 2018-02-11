#' Create and initialise package review
#'
#' Create a review project using `pkgreview_create`. Wait till your workspace has
#' been switched to pkg review project dircetory and initialise review using
#' `pkgreview_init`
#' @param pkg_repo character string of the repo owner and name in the form of
#'  `"owner/repo"`.
#' @param review_parent directory in which to setup review project and source package
#'  source code.
#' @param review_dir path to review project root.
#' @param open Open the newly created project/file for editing? Happens in RStudio, if
#'   applicable, or via [utils::file.edit()] otherwise.
#'
#' @return setup review project with templates
# @importFrom devtools getFromNamespace github_remote
# @importFrom usethis getFromNamespace can_overwrite
#' @export
#'
#' @examples
#' \dontrun{
#' pkgreview_init(pkg_repo = "cboettig/rdflib")
#' }
pkgreview_create <- function(pkg_repo, review_parent = ".", open = TRUE) {

    # create project
    meta <- devtools:::github_remote(pkg_repo)
    review_path <- file.path(paste0(review_parent,"/",
                                    meta$repo, "-review"))
    ifelse(usethis:::can_overwrite(review_path),
           {unlink(review_path, recursive=TRUE)
               usethis::create_project(review_path, open = open)},
           {message(paste0(review_path,
                           "review project already exists. Opening project"))
               usethis::proj_set(review_path)})
}

#' @export
#' @rdname pkgreview_create
pkgreview_init <- function(pkg_repo, review_dir = here::here(), open = TRUE) {

    check_global_git()

    # create package source code directory
    meta <- devtools:::github_remote(pkg_repo)


    pkg_dir <- file.path(paste0(review_dir, "/../", meta$repo))

    if (!usethis:::can_overwrite(pkg_dir))
        message(paste0("../", meta$repo,
                ": directory already exists. repo clone skipped"))
    if (dir.exists(pkg_dir)) {
        unlink(pkg_dir, recursive=TRUE)
    } else{
        dir.create(pkg_dir, recursive=TRUE)
    }
    repo <- git2r::clone(paste0("https://github.com/", pkg_repo), pkg_dir)

    # create templates
    use_reviewtmpl(open = open)
    pkg_data <- pkgreview_getdata(pkg_dir)
    pkgreview_readme_md(pkg_data, open = open)
    pkgreview_index_rmd(pkg_data, open = open)
    usethis::use_git()

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

    if(RCurl::url.exists(site)){
        pkg_data$site <- site}else{pkg_data$site <- NULL}

    pkg_data
}
