#' Create and initialise package review
#'
#' Create a review project using `pkgreview_create`. Wait till your workspace has
#' been switched to pkg review project dircetory and initialise review using
#' `pkgreview_init`
#' @param pkg_repo character string of the repo owner and name in the form of
#'  `"owner/repo"`.
#' @param review_dir directory in which to setup review project and source package
#'  source code.
#'
#' @return setup review project with templates
#' @export
#'
#' @examples
#' \dontrun{
#' pkgreview_init(pkg_repo = "cboettig/rdflib")
#' }
pkgreview_create <- function(pkg_repo, review_dir = ".") {

    # create project
    meta <- devtools:::github_remote(pkg_repo)
    review_path <- file.path(paste0(review_dir,"/",
                                    meta$repo, "-review"))
    ifelse(usethis:::can_overwrite(review_path),
           {unlink(review_path, recursive=TRUE)
               usethis::create_project(review_path)},
           {message(paste0(review_path,
                           "review project already exists. Opening project"))
               usethis::proj_set(review_path)})
}

#' @export
#' @rdname pkgreview_create
pkgreview_init <- function(pkg_repo, review_dir = ".") {
    # create package source code directory
    meta <- devtools:::github_remote(pkg_repo)
    pkg_dir <- file.path(paste0(here::here(),"/../", meta$repo))
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
    usethis::use_template("pkgreview.md", package = "pkgreviewr")
    pkgreviewr::pkgreview_index_rmd(pkg_dir)
    pkgreviewr::pkgreview_readme_md(pkg_dir)


}

#' Create README files.
#'
#' Creates skeleton README files with sections for
#' \itemize{
#' \item a high-level description of the package and its goals
#' \item R code to install from GitHub, if GitHub usage detected
#' \item a basic example
#' }
#' Use `Rmd` if you want a rich intermingling of code and data. Use
#' `md` for a basic README. `README.Rmd` will be automatically
#' added to `.Rbuildignore`. The resulting README is populated with default
#' YAML frontmatter and R fenced code blocks (`md`) or chunks (`Rmd`).
#'
#' @param pkg_dir package directory
#' @param open allow interaction
#'
#' @export
#' @examples
#' \dontrun{
#' use_readme_rmd()
#' use_readme_md()
#' }
pkgreview_index_rmd <- function(pkg_dir, open = interactive()) {
    usethis:::check_installed("rmarkdown")

    pkgdata <- pkgreview_getdata(pkg_dir)
    usethis::use_template(
        "review-index",
        "index.Rmd",
        data = pkgdata,
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
pkgreview_readme_md <- function(pkg_dir, open = interactive()) {
    pkgdata <- pkgreview_getdata(pkg_dir)

    usethis::use_template(
        "review-README",
        "README.md",
        data = pkgdata,
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
#' @examples
#' \dontrun{
#' pkgreview_getdata("../rdflib")
#' }
pkgreview_getdata <- function(pkg_dir) {

    pkgdata <- usethis:::project_data(pkg_dir)
    pkgdata$Rmd <- TRUE
    pkgdata$pkg_dir <- pkg_dir
    pkgdata$Rmd <- FALSE
    pkgdata$pkg_repo <- paste0(pkgdata$github$username, "/",
                       pkgdata$github$repo)
    pkgdata$username <- pkgdata$github$username
    pkgdata$repo <- pkgdata$github$repo
    pkgdata$whoami <- whoami::whoami()["gh_username"]
    pkgdata$whoami_url <- paste0("https://github.com/", pkgdata$whoami)
    pkgdata$review_repo <- paste0(pkgdata$whoami, "/",
                                  pkgdata$repo, "-review")
    pkgdata$index_url <- paste0("https://", pkgdata$whoami, ".github.io/",
                                pkgdata$pkg_repo, "/index.nb.html")
    pkgdata$pkgreview_url <- paste0("https://github.com/", pkgdata$review_repo,
                                    "/blob/master/pkgreview.md")

    issue <- github::search.issues(paste("ropensci onboarding",pkgdata$repo))

    pkgdata$issue_url <- issue$content$items[[1]]$html_url
    pkgdata$number <- issue$content$items[[1]]$number

    site <- paste0("https://", pkgdata$github$username, ".github.io/",
           pkgdata$github$repo,"/")

    ifelse(RCurl::url.exists(site),
           {pkgdata$site <- site},
           {pkgdata$site <- NULL})

    pkgdata
}
