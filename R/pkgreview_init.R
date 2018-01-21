#' Initialise package review
#'
#' @param pkg_repo character string of the repo owner and name in the form of
#'  `"owner/repo"`.
#' @param review_dir directory in which to setup review project and source package
#'  source code.
#' @param issue_url url of issue # in the rOpenSci onboarding
#'  <https://github.com/ropensci/onboarding/issues>
#'
#' @return setup review project with templates
#' @export
#'
#' @examples
#' \dontrun{
#' pkgreview_init(pkg_repo = "cboettig/rdflib")
#' }
pkgreview_init <- function(pkg_repo = "cboettig/rdflib", review_dir = ".",
                           issue_url = "https://github.com/ropensci/onboarding/issues/169") {

    # create project
    meta <- devtools:::github_remote(pkg_repo)
    usethis::create_project(file.path(paste0(review_dir,"/", meta$repo, "-review")))

    # create package source code directory
    pkg_dir <- file.path(paste0(here::here(),"/../", meta$repo))
    if (!dir.exists(pkg_dir)) {
        dir.create(pkg_dir, recursive=TRUE)
    }
    repo <- git2r::clone(paste0("https://github.com/", pkg_repo), pkg_dir)

    # create templates
    usethis::use_template("pkgreview.md", package = "pkgreviewr")
    pkgreviewr::pkgreview_readme_rmd(pkg_dir, issue_url)
}

#usethis:::package_data("")

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
#' @param open open on
#' @param issue_url
#'
#' @export
#' @examples
#' \dontrun{
#' use_readme_rmd()
#' use_readme_md()
#' }
pkgreview_readme_rmd <- function(pkg_dir, issue_url, open = interactive()) {
    usethis:::check_installed("rmarkdown")

    pkgdata <- pkgreview_getdata(pkg_dir)
    usethis::use_template(
        "review-README",
        "README.Rmd",
        data = pkgdata,
        ignore = TRUE,
        open = open,
        package = "pkgreviewr"
    )

    if (usethis:::uses_git()) {
        usethis::use_git_hook(
            "pre-commit",
            usethis:::render_template("readme-rmd-pre-commit.sh")
        )
    }

    invisible(TRUE)
}

#' @export
#' @rdname pkgreview_readme_rmd
pkgreview_readme_md <- function(pkg_dir, issue_url, open = interactive()) {
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
    pkg_repo <- paste0(pkgdata$github$username, "/",
                       pkgdata$github$repo)
    pkgdata <- usethis:::project_data(pkg_dir)
    pkgdata$Rmd <- TRUE
    pkgdata$pkg_dir <- pkg_dir
    pkgdata$Rmd <- FALSE

    issue <- search.issues(paste0("ropensci ",pkg_repo))
    pkgdata$issue_url <- issue$content$items[[1]]$html_url
    pkgdata$number <- issue$content$items[[1]]$number

    site <- paste0("https://", pkgdata$github$username, ".github.io/",
           pkgdata$github$repo,"/")
    ifelse(RCurl::url.exists(site),
           {pkgdata$site <- site},
           {pkgdata$site <- NULL})

    pkgdata
}
