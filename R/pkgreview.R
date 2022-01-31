#' Create a review project.
#'
#' Create and initialise an rOpenSci package review project
#'
#' @param pkg_repo character string of the repo owner and name in the form of
#'  `"owner/repo"`.
#' @param review_parent directory in which to setup review project and source package
#'  source code.
#' @param template character string, one of `review` or `editor`.
#' @param issue_no integer. Issue number of the pkg review in the rOpenSci [`software-review` repository](https://github.com/ropensci/software-review/issues).
#' If `NULL` (default), the issue number is extracted from the rOpenSci **Under Review** badge on the pkg repository README.
#' Supplying an integer to `issue_no` overrides this behaviour and can be useful if a badge has not been added to the README yet.
#'
#' @return setup review project with templates
#' @export
#'
#' @examples
#' \dontrun{
#' # for a review project
#' pkgreview_create(pkg_repo = "ropensci/rdflib", review_parent = "~/Documents/reviews/")
#' # for editors checks
#' pkgreview_create(pkg_repo = "ropensci/rdflib", review_parent = "~/Documents/editorials/",
#' template = "editor")
#' }
pkgreview_create <- function(pkg_repo, review_parent = ".",
                             template = c("review", "editor"),
                             issue_no = NULL) {
    template <- match.arg(template)
    # checks
    review_parent <- fs::path_real(review_parent)
    check_rstudio()
    check_global_git()

    # get repo metadata
    meta <- get_repo_meta(pkg_repo)
    tmp <- file.path(tempdir(), "pkgreviewr_prep")
    on.exit(unlink(tmp, recursive = T))
    dir.create(tmp, showWarnings = F)

    tmp_pkg_dir <- fs::path(tmp, meta$name)
    pkg_dir <- fs::path(review_parent, meta$name)
    tmp_review_dir <- fs::path(tmp, glue::glue("{meta$name}-{template}"))
    review_dir <- fs::path(review_parent, glue::glue("{meta$name}-{template}"))


    #if pkg_dir already exists, overwrite?
    write_clone <- overwrite_dir(pkg_dir)
    if(write_clone) {
        # clone package source code directory and write to review_parent if clone successful
        clone_successful <- clone_pkg(pkg_repo, pkg_dir = tmp_pkg_dir)
        if(clone_successful){
            write_dir(tmp_dir = tmp_pkg_dir, out_dir = pkg_dir)
        }
    }  else {
        usethis::ui_info("pkg_dir:{usethis::ui_path(pkg_dir)} already exists. Not overwitten")
        if (!file.exists(file.path(pkg_dir, "DESCRIPTION"))) {
        usethis::ui_warn("No {usethis::ui_field('DESCRIPTION')} file detected in {usethis::ui_path(pkg_dir)}.
                         Please check the directory contains the source code for {usethis::ui_value(pkg_repo)}")
            clone_successful <- FALSE
        } else {
            clone_successful <- TRUE
        }
    }

    # create project
    withr::local_options(list(usethis.quiet = TRUE))
    usethis::create_project(tmp_review_dir, open = FALSE)
    unlink(file.path(tmp_review_dir,"R"), recursive = TRUE)

    # initialise and copy review project to review_parent if clone was successful
    # and write required (either pkg_dir does not exist or overwrite has been requested)
    if(clone_successful){
        pkgreview_init(pkg_repo, review_dir = tmp_review_dir,
                       pkg_dir = pkg_dir,
                       template = template,
                       issue_no = issue_no)

    }else{
        usethis::ui_todo("Template initialisation of review project {usethis::ui_value(basename(review_dir))} not possible. \n
        Use:  {usethis::ui_code(' pkgreview_init() ')} after you've cloned repo {usethis::ui_value(pkg_repo)}")
    }
    # initialise with git
    use_git_pkgrv(path = tmp_review_dir)
    # write out review dir
    if (overwrite_dir(review_dir)) {
        write_dir(tmp_dir = tmp_review_dir, out_dir = review_dir)
    } else {
        usethis::ui_info("review_dir:{usethis::ui_path(review_dir)} already exists. Not overwitten")
    }
    if (interactive() & rstudioapi::isAvailable()) rstudioapi::openProject(review_dir,
                                                                           newSession = T)
}




#' Initialise pkgreview
#'
#' @inheritParams pkgreview_create
#' @param review_dir path to the review directory. Defaults to the working directory.
#' @param pkg_dir path to package source directory, cloned from github. Defaults
#' to the package source code directory in the review parent.
#'
#' @return Initialisation creates pre-populated `index.Rmd`, `pkgreview.md` and `README.md` documents.
#' To initialise correctly, the function requires that the source code for the
#' package has been cloned. This might need to be done manually if it failed
#' during review creation. If setup is correct.
#' @export
#'
#' @examples
#' \dontrun{
#' # run from within an uninitialised pkgreviewr project
#' pkgreview_init(pkg_repo = "ropensci/rdflib")
#' }
pkgreview_init <- function(pkg_repo, review_dir = ".",
                           pkg_dir = NULL,
                           template = c("review", "editor"),
                           issue_no = NULL){

    template <- match.arg(template)

    # get repo metadata
    meta <- get_repo_meta(pkg_repo)

    # get package metadata
    if(is.null(pkg_dir)){
        pkg_dir <- fs::path(fs::path_dir(review_dir), meta$name)}

    assertthat::assert_that(assertthat::is.dir(pkg_dir))
    assertthat::assert_that(file.exists(file.path(pkg_dir, "DESCRIPTION")))
    pkg_data <- pkgreview_getdata(pkg_dir = pkg_dir, pkg_repo,
                                  template = template,
                                  issue_no = issue_no)

    usethis::with_project(review_dir, {
        # create templates
        use_onboarding_tmpl(template)
        pkgreview_index_rmd(pkg_data, template)
        switch (template,
                "review" = pkgreview_readme_md(pkg_data),
                "editor" = pkgreview_request(pkg_data)
        )
    }, quiet = TRUE)

    usethis::ui_done('{template} project {usethis::ui_value(basename(review_dir))} initialised successfully')
}

#' pkgreview_getdata
#'
#' get package metadata from package source code.
#' @inheritParams pkgreview_create
#' @inheritParams pkgreview_init
#'
#' @return a list of package metadata
# @importFrom usethis getFromNamespace project_data
#' @examples
#' \dontrun{
#' # run from within a pkgreviewr project with the package source code in a
#' sibling directory
#' pkgreview_getdata("../rdflib")
#' }
#' @export
pkgreview_getdata <- function(pkg_dir = NULL, pkg_repo,
                              template = c("review", "editor"),
                              issue_no = NULL) {

    template <- match.arg(template)

    # get repo metadata
    meta <- get_repo_meta(pkg_repo, full = T)
    if(is.null(pkg_dir)){
        pkg_dir <- fs::path(usethis::proj_path(".."), meta$name)}

    # package repo data
    pkg_data <- usethis:::package_data(pkg_dir)

    pkg_data$URL <- meta$html_url

    pkg_data$pkg_dir <- pkg_dir
    pkg_data$Rmd <- FALSE
    pkg_data$pkg_repo <- pkg_repo
    pkg_data$username <- meta$owner$login
    pkg_data$repo <- meta$name

    # reviewer data
    whoami_try <- try_whoami()
    if(!inherits(whoami_try, "try-error")){
        pkg_data$whoami <- whoami_try$login
        pkg_data$whoami_url <- whoami_try$html_url
        pkg_data$review_repo <- glue::glue("{pkg_data$whoami}/{pkg_data$repo}-{template}")
        pkg_data$index_url <- glue::glue("https://{pkg_data$whoami}.github.io/{pkg_data$repo}-{template}/index.nb.html")
        pkg_data$pkgreview_url <- glue::glue("https://github.com/{pkg_data$review_repo}/blob/master/pkgreview.md")
    }else{
        warning("GitHub user unidentifed.
                URLs related to review and review repository not initialised.")
        pkg_data$whoami <- NULL
        pkg_data$whoami_url <- NULL
        pkg_data$review_repo <- NULL
        pkg_data$index_url <- NULL
        pkg_data$pkgreview_url <- NULL
    }

    pkg_data$issue_url <- ifelse(is.null(issue_no),
                                 issue_meta(pkg_data$pkg_repo, parameter = "url"),
                                 paste0("https://github.com/ropensci/software-review/issues/", issue_no))
    pkg_data$number <- ifelse(is.null(issue_no),
                              issue_meta(pkg_data$pkg_repo),
                              issue_no)
    pkg_data$site <- meta$homepage

    pkg_data
}


#' Try whoami
#'
#' Try to get whoami info from local  gh token.
#'
#' @return a list of whoami token metadata
#' @export
try_whoami <- function() {
    try(gh::gh_whoami(gh::gh_token()), silent = T)
}
