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
pkgreview_create <- function(pkg_repo, review_parent = ".", open = interactive()) {

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
pkgreview_init <- function(pkg_repo, review_dir = ".", open = interactive()) {
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
    usethis::use_git()
    use_reviewtmpl(open = open)
    pkg_data <- pkgreview_getdata(pkg_dir)
    pkgreviewr::pkgreview_index_rmd(pkg_data, open = open)
    pkgreviewr::pkgreview_readme_md(pkg_data, open = open)


}

#' Create review templates.
#'
#' Creates skeleton review files:
#' \itemize{
#' \item `index.Rmd`: `html_notebook` to perform and record review in
#' \item `pkgreview.md`: review response submission template.
#' \item `README.md`: prepopulated README for review repo.
#' }
#' `index.Rmd` will be automatically added to `.Rbuildignore`. The resulting templates are populated with default
#' YAML frontmatter and R fenced code chunks (`Rmd`).
#'
#' @param pkg_dir package directory
#' @param open allow interaction
#'
#' @export
# @importFrom usethis getFromNamespace check_installed
# @importFrom usethis getFromNamespace render_template
#' @examples
#' \dontrun{
#' pkgreview_index_rmd("../rdflib/")
#' pkgreview_readme_md("../rdflib/")
#' pkgreview_pkgreview_md("../rdflib/")
#' }
pkgreview_index_rmd <- function(pkg_data, open = interactive()) {
    usethis:::check_installed("rmarkdown")

    usethis::use_template(
        "review-index",
        "index.Rmd",
        data = pkg_data,
        ignore = TRUE,
        open = open,
        package = "pkgreviewr"
    )

    if (usethis:::uses_git()) {
        usethis::use_git_hook(
            "pre-commit",
            usethis:::render_template("readme-rmd-pre-commit.sh",
                                      package = "pkgreviewr")
        )
    }

    invisible(TRUE)
}

#' @export
#' @rdname pkgreview_index_rmd
pkgreview_readme_md <- function(pkg_data, open = interactive()) {

    usethis::use_template(
        "review-README",
        "README.md",
        data = pkg_data,
        ignore = TRUE,
        open = open,
        package = "pkgreviewr"
    )
}

#' @export
#' @rdname pkgreview_index_rmd
pkgreview_pkgreview_md <- function(pkg_data, open = interactive()) {

    usethis::use_template(
        "pkgreview.md",
        "pkgreview.md",
        data = pkg_data,
        ignore = TRUE,
        open = open,
        package = "pkgreviewr"
    )
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

    pkg_data <- usethis:::project_data(pkg_dir)
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


# get review text from ropensci onboarding repo
use_reviewtmpl <- function(open = FALSE){
    review_url <- "https://raw.githubusercontent.com/ropensci/onboarding/master/reviewer_template.md"
    review_txt <- RCurl::getURL(review_url, ssl.verifypeer = FALSE)

    new <- usethis:::write_over(usethis::proj_get(), "pkgreview.md", review_txt)
    if(open){
        usethis:::edit_file(usethis::proj_get(), "pkgreview.md")
    }
    invisible(new)
}
