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
        pkgreview_init(pkg_repo, review_dir = review_dir, tmp = tmp)
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

    if (rstudioapi::isAvailable()) rstudioapi::openProject(review_dir,
                                                           newSession = T)
}




#' Initialise pkgreview
#'
#' @param pkg_repo character string of the repo owner and name in the form of
#'  `"owner/repo"`.
#' @param review_dir path to the review directory
#' @param pkg_dir path to package source directory, cloned from github
#' @param tmp used to specify a tmp directory during project creation.
#' Ignore for manual initialisation
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
pkgreview_init <- function(pkg_repo, review_dir = NULL,
                           pkg_dir = NULL, tmp = NULL){
    # get repo metadata
    meta <- get_repo_meta(pkg_repo)

    # get package metadata
    if(is.null(review_dir)){
        review_dir <- here::here()}
    if(is.null(pkg_dir)){
        pkg_dir <- file.path(dirname(review_dir), meta$name)}
    if(!is.null(tmp)){
        tmp_pkg_dir <- file.path(tmp, meta$name)
        tmp_review_dir <- file.path(tmp, paste0(meta$name, "-review"))

        here::set_here(tmp_review_dir)
        assertthat::assert_that(assertthat::is.dir(tmp_pkg_dir))
        assertthat::assert_that(file.exists(file.path(tmp_pkg_dir,
                                                      "DESCRIPTION")))
        pkg_data <- pkgreview_getdata(pkg_dir = tmp_pkg_dir, pkg_repo)
        pkg_data$pkg_dir <- pkg_dir
    }else{
        assertthat::assert_that(assertthat::is.dir(pkg_dir))
        assertthat::assert_that(file.exists(file.path(pkg_dir, "DESCRIPTION")))
        pkg_data <- pkgreview_getdata(pkg_dir = pkg_dir, pkg_repo)
    }

    # create templates
    use_reviewtmpl()
    pkgreview_readme_md(pkg_data)
    pkgreview_index_rmd(pkg_data)

    done("Review project ", value(basename(review_dir)),
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
pkgreview_getdata <- function(pkg_dir, pkg_repo) {
    # get repo metadata
    meta <- get_repo_meta(pkg_repo, full = T)

    # package repo data
    pkg_data <- usethis:::package_data(pkg_dir)
    pkg_data$pkg_dir <- pkg_dir
    pkg_data$Rmd <- FALSE
    pkg_data$pkg_repo <- pkg_repo
    pkg_data$username <- meta$owner$login
    pkg_data$repo <- meta$name

    # reviewer data
    whoami_try <- try(whoami::gh_username())
    if(!class(whoami_try) == "try-error"){
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
