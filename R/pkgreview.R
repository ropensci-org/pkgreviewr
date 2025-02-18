#' Create a review project.
#'
#' Create and initialise an rOpenSci package review project
#'
#' @param pkg_repo character string of the repo owner and name in the form of
#'  `"owner/repo"`.
#' @param review_parent directory in which to setup
#' review project and source package source code.
#' @param template character string, one of `review` or `editor`.
#' @param issue_no integer. Issue number of the pkg review in the
#' rOpenSci [`software-review` repository](https://github.com/ropensci/software-review/issues). # nolint: line_length_linter
#' If `NULL` (default), the issue number is extracted from the rOpenSci
#' **Under Review** badge on the pkg repository README.
#' Supplying an integer to `issue_no` overrides this behaviour
#' and can be useful if a badge has not been added to the README yet.
#'
#' @return setup review project with templates
#' @export
#'
#' @examples
#' \dontrun{
#' # for a review project
#' pkgreview_create(
#'   pkg_repo = "ropensci/rdflib",
#'   review_parent = "~/Documents/reviews/"
#' )
#' # for editors checks
#' pkgreview_create(
#'   pkg_repo = "ropensci/rdflib",
#'   review_parent = "~/Documents/editorials/",
#'   template = "editor"
#' )
#' }
pkgreview_create <- function(pkg_repo, review_parent = ".",
                             template = c("review", "editor"),
                             issue_no = NULL) {
  template <- match.arg(template)
  # checks
  review_parent <- fs::path_real(review_parent)
  check_global_git()

  # get repo metadata
  meta <- get_repo_meta(pkg_repo)

  pkg_dir <- fs::path(review_parent, meta[["name"]])
  review_dir <- fs::path(
    review_parent,
    sprintf("%s-%s", meta[["name"]], template)
  )

  create_from_github(pkg_repo, destdir = review_parent, open = FALSE)

  # create project
  withr::local_options(list(usethis.quiet = TRUE))

  pkgreview_init(
    pkg_repo,
    review_dir = review_dir,
    pkg_dir = pkg_dir,
    template = template,
    issue_no = issue_no
  )

  # initialise with git
  use_git_pkgrv(path = review_dir)

  usethis::create_project(review_dir)
}




#' Initialise pkgreview
#'
#' @inheritParams pkgreview_create
#' @param review_dir path to the review directory. Defaults to the working directory. # nolint: line_length_linter
#' @param pkg_dir path to package source directory, cloned from github. Defaults
#' to the package source code directory in the review parent.
#'
#' @return Initialisation creates pre-populated `index.Rmd`, `pkgreview.md` and `README.md` documents. # nolint: line_length_linter
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
                           issue_no = NULL) {

  template <- match.arg(template)

  # get repo metadata
  meta <- get_repo_meta(pkg_repo)

  # get package metadata
  pkg_dir <- pkg_dir %||% fs::path(fs::path_dir(review_dir), meta[["name"]])

  assertthat::assert_that(
    assertthat::is.dir(pkg_dir),
    file.exists(file.path(pkg_dir, "DESCRIPTION"))
  )

  pkg_data <- pkgreview_getdata(
    pkg_repo = pkg_repo,
    pkg_dir = pkg_dir,
    template = template,
    issue_no = issue_no
  )

  if (!fs::dir_exists(review_dir)) {
    fs::dir_create(review_dir)
  }

  usethis::create_project(review_dir, open = FALSE)
  use_onboarding_tmpl(template, destdir = review_dir)
  pkgreview_index_rmd(pkg_data, template, destdir = review_dir)

  switch(
    template,
    review = pkgreview_readme_md(pkg_data, destdir = review_dir),
    editor = pkgreview_request(pkg_data, destdir = review_dir)
  )

  cli::cli_alert_success(
    "{template} project {.val {basename(review_dir)}} initialised"
  )
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
#' pkgreview_getdata("ropensci/rdflib", "../rdflib")
#' }
#' @export
pkgreview_getdata <- function(pkg_repo, pkg_dir = NULL,
                              template = c("review", "editor"),
                              issue_no = NULL) {

  template <- match.arg(template)

  # get repo metadata
  meta <- get_repo_meta(pkg_repo, full = TRUE)
  pkg_dir <- pkg_dir %||% fs::path(usethis::proj_path(".."), meta[["name"]])

  # package repo data
  pkg_data <- package_data(pkg_dir)

  pkg_data <- c(
    pkg_data,
    URL  = meta[["html_url"]],
    pkg_dir = pkg_dir,
    Rmd = FALSE,
    pkg_repo = pkg_repo,
    username = meta[["owner"]][["login"]],
    repo = meta[["name"]]
  )

  # reviewer data
  whoami <- try_whoami()
  if (inherits(whoami, "try-error")) {
    cli::cli_warn(c(
      "GitHub user unidentifed.",
      "URLs related to review and review repository not initialised."
    ))
    pkg_data <- c(
      pkg_data,
      whoami = NULL,
      whoami_url = NULL,
      review_repo = NULL,
      index_url = NULL,
      pkgreview_url = NULL
    )
  } else {
    pkg_data <- c(
      pkg_data,
      whoami = whoami[["login"]],
      whoami_url = whoami[["html_url"]],
      review_repo = sprintf("%s/%s-%s", whoami[["html_url"]], pkg_data[["repo"]], template),  # nolint: line_length_linter
      index_url = sprintf("https://%s.github.io/%s-%s/index.nb.html", whoami[["login"]], pkg_data[["repo"]], template), # nolint: line_length_linter
      pkgreview_url = sprintf("https://github.com/%s/blob/master/pkgreview.md", pkg_data[["review_repo"]]) # nolint: line_length_linter
    )
  }

  issue_no <- issue_no %||% issue_meta(pkg_data[["pkg_repo"]])
  issue_url <- paste0("https://github.com/ropensci/software-review/issues/", issue_no) # nolint: line_length_linter

  pkg_data <- c(
    pkg_data,
    issue_url = issue_url,
    number = issue_no,
    site = meta[["homepage"]]
  )

  pkg_data
}


#' Try whoami
#'
#' Try to get whoami info from local  gh token.
#'
#' @return a list of whoami token metadata
#' @export
try_whoami <- function() {
  if (on_ci()) {
    list(
      login = "maelle",
      html_url = "https://github.com/maelle"
    )
  } else {
    try(gh::gh_whoami(gh::gh_token()), silent = TRUE)
  }
}

create_from_github <- function(pkg_repo, destdir, open) {
  if (on_ci()) {
    url <- sprintf(
      "https://github.com/%s/archive/refs/heads/main.zip",
      pkg_repo
    )
    temp_file <- withr::local_tempfile()
    curl::curl_download(url, temp_file)

    temp_dir <- withr::local_tempdir()
    utils::unzip(temp_file, exdir = temp_dir)
    zip_name <- sprintf("%s-main", fs::path_file(pkg_repo))

    pkg_dir <- fs::path(destdir, fs::path_file(pkg_repo))

    fs::dir_copy(fs::path(temp_dir, zip_name), destdir)
    file.rename(
      file.path(destdir, zip_name),
      file.path(destdir, fs::path_file(pkg_repo))
    )
    gert::git_init(fs::path(destdir, fs::path_file(pkg_repo)))
    return(TRUE)
  }

  usethis::create_from_github(pkg_repo, destdir = destdir, open = open)
}
