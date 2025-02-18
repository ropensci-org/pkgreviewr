# modified from usethis::use_git
use_git_pkgrv <- function(path = ".", message = "Initial commit") {
  if (uses_git_pkgrv(path)) {
    return(invisible())
  }
  usethis::ui_done("Initialising Git repo")
  repo <- gert::git_init(path)
  usethis::with_project(path = path, {
    usethis::use_git_ignore(c(".Rhistory", ".RData", ".Rproj.user"))
  })
  usethis::ui_done("Adding files and committing")
  gert::git_add("*", repo = repo)
  gert::git_commit_all(message, repo = repo)
  invisible(TRUE)
}

# modified from usethis:::uses_git
uses_git_pkgrv <- function(path) {
  repo <- tryCatch(
    gert::git_find(usethis::proj_get(path)),
    error = function(e) NULL
  )
  !is.null(repo)
}

# inspired by usethis:::can_overwrite
overwrite_dir <- function(path) {
  if (!fs::file_exists(path)) {
    return(TRUE)
  }
  if (interactive()) {
    usethis::ui_yeah("Overwrite pre-existing directory {ui_path(path)}?")
  } else {
    FALSE
  }
}


write_dir <- function(tmp_dir, out_dir) {
  assertthat::assert_that(fs::dir_exists(fs::path_dir(out_dir)))

  dir_type <- switch( # nolint: object_usage_linter
    fs::file_exists(file.path(tmp_dir, "DESCRIPTION")),
    TRUE ~ "pkg_dir",
    FALSE ~ "review_dir"
  )

  if (fs::dir_exists(out_dir)) {
    fs::dir_delete(out_dir)
  }
  fs::dir_copy(tmp_dir, dirname(out_dir))
  cli::cli_alert_success("{.val {dir_type}} written out")
}


### add former usethis:::package_data(),
### now removed (see https://github.com/r-lib/usethis/pull/1747)
package_data <- function(base_path = NULL) {
  desc <- desc::description$new(base_path) # nolint: extraction_operator_linter
  as.list(desc$get(desc$fields())) # nolint: extraction_operator_linter
}
