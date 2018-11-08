#' Create a review project.
#'
#' Create and initialise an rOpenSci package review project
#' @param pkg_repo character string of the repo owner and name in the form of
#'  `"owner/repo"`.
#' @param review_parent directory in which to setup review project and source package
#'  source code.
#' @param template character string, one of `review` or `editor`.
#'
#' @return setup review project with templates
#' @export
#'
#' @examples
#' \dontrun{
#' pkgreview_create(pkg_repo = "cboettig/rdflib")
#' }
pkgreview_create <- function(pkg_repo, review_parent = ".",
                             template = c("review", "editor")) {
    template <- match.arg(template)
    # checks
    check_rstudio()
    check_global_git()

    # get repo metadata
    meta <- get_repo_meta(pkg_repo)
    tmp <- file.path(tempdir(), "pkgreviewr_prep")
    on.exit(unlink(tmp, recursive = T))
    dir.create(tmp, showWarnings = F)

    tmp_pkg_dir <- normalizePath(file.path(tmp, meta$name), mustWork = F)
    pkg_dir <- normalizePath(file.path(review_parent, meta$name), mustWork = F)
    tmp_review_dir <- normalizePath(file.path(tmp, paste0(meta$name, "-review")),
                                    mustWork = F)
    review_dir <- normalizePath(file.path(review_parent,
                                          paste0(meta$name, "-review")),
                                mustWork = F)

    # clone package source code directory and write to review_parent
    clone <- clone_pkg(pkg_repo, pkg_dir = tmp_pkg_dir)
    if(clone){
        write_dir(tmp_dir = tmp_pkg_dir, out_dir = pkg_dir)
    }

    # create project
    usethis::create_project(tmp_review_dir, open = FALSE)
    unlink(file.path(tmp_review_dir,"R"), recursive = TRUE)

    # initialise and copy review project to review_parent
    if(clone){
        pkgreview_init(pkg_repo, review_dir = tmp_review_dir,
                       pkg_dir = pkg_dir,
                       template = template)
    }else{
        todo("Template initialisation of review project",
             value(basename(review_dir)) ,"not possible. \n Use: ",
             code(" pkgreview_init() "), "after you've cloned repo ",
             value(pkg_repo))
    }
    # initialise with git
    use_git_pkgrv(path = tmp_review_dir)
    # write out review dir
    write_dir(tmp_dir = tmp_review_dir, out_dir = review_dir)

    if (interactive() & rstudioapi::isAvailable()) rstudioapi::openProject(review_dir,
                                                           newSession = T)
}




#' Initialise pkgreview
#'
#' @param pkg_repo character string of the repo owner and name in the form of
#'  `"owner/repo"`.
#' @param review_dir path to the review directory
#' @param pkg_dir path to package source directory, cloned from github
#' Ignore for manual initialisation
#' @param template character string, one of `review` or `editor`.
#'
#' @return Initialisation creates pre-populated `index.Rmd`, `pkgreview.md` and `README.md` documents.
#' To initialise correctly, the function requires that the source code for the
#' package has been cloned. This might need to be done manually if it failed
#' during review creation. If setup is correct. Defaults are set to work in the
#' root of the `review_dir` with `pkg_dir` set to `"../`
#' @export
#'
#' @examples
#' \dontrun{
#' pkgreview_init(pkg_repo = "cboettig/rdflib")
#' }
pkgreview_init <- function(pkg_repo, review_dir = ".",
                           pkg_dir = NULL,
                           template = c("review", "editor")){
    # get repo metadata
    meta <- get_repo_meta(pkg_repo)

    # get package metadata
    if(is.null(pkg_dir)){
        pkg_dir <- file.path(dirname(normalizePath(review_dir)), meta$name)}

    assertthat::assert_that(assertthat::is.dir(pkg_dir))
    assertthat::assert_that(file.exists(file.path(pkg_dir, "DESCRIPTION")))
    pkg_data <- pkgreview_getdata(pkg_dir = pkg_dir, pkg_repo)

    # create templates
    use_onboarding_tmpl(template)
    pkgreview_index_rmd(pkg_data, template)
    switch (template,
        "review" = pkgreview_readme_md(pkg_data),
        "editor" = pkgreview_request(pkg_data)
    )

    done(template, " project ", value(basename(review_dir)),
         " initialised successfully")
}

#' pkgreview_getdata
#'
#' get package metadata from package source code.
#'
#' @param pkg_dir path to the package source code directory
#' @param pkg_repo character string of the repo owner and name in the form of
#'  `"owner/repo"`.
#'
#' @return a list of package metadata
# @importFrom usethis getFromNamespace project_data
#' @examples
#' \dontrun{
#' pkgreview_getdata("../rdflib")
#' }
pkgreview_getdata <- function(pkg_dir = NULL, pkg_repo) {
    # get repo metadata
    meta <- get_repo_meta(pkg_repo, full = T)
    if(is.null(pkg_dir)){
        pkg_dir <- file.path(usethis::proj_path(".."), meta$name)}

    # package repo data
    pkg_data <- usethis:::package_data(pkg_dir)
    pkg_data$pkg_dir <- pkg_dir
    pkg_data$Rmd <- FALSE
    pkg_data$pkg_repo <- pkg_repo
    pkg_data$username <- meta$owner$login
    pkg_data$repo <- meta$name

    # reviewer data
    whoami_try <- try(whoami::gh_username())
    if(!inherits(whoami_try, "try-error")){
        pkg_data$whoami <- whoami_try
        pkg_data$whoami_url <- paste0("https://github.com/", pkg_data$whoami)
        pkg_data$review_repo <- paste0(pkg_data$whoami, "/",
                                       pkg_data$repo, "-review")
        pkg_data$index_url <- paste0("https://", pkg_data$whoami, ".github.io/",
                                     pkg_data$repo, "-review", "/index.nb.html")
        pkg_data$pkgreview_url <- paste0("https://github.com/", pkg_data$review_repo,
                                         "/blob/master/pkgreview.md")
    }else{
        warning("GitHub user unidentifed.
                URLs related to review and review repository not intitialised.")
        pkg_data$whoami <- NULL
        pkg_data$whoami_url <- NULL
        pkg_data$review_repo <- NULL
        pkg_data$index_url <- NULL
        pkg_data$pkgreview_url <- NULL
    }

    pkg_data$issue_url <- issue_meta(pkg_data$pkg_repo, parameter = "url")
    pkg_data$number <- issue_meta(pkg_data$pkg_repo)
    pkg_data$site <- meta$homepage

    pkg_data
}
