# modified from usethis::use_git
use_git_pkgrv <- function (path = ".", message = "Initial commit") {
    if (uses_git_pkgrv(path)) {
        return(invisible())
    }
    usethis::ui_done("Initialising Git repo")
    repo <- gert::git_init(path)
    usethis::with_project(path = path, {
        usethis::use_git_ignore(c(".Rhistory", ".RData", ".Rproj.user"))
    })
    usethis::ui_done("Adding files and committing")
    gert::git_commit_all(message, repo = repo)
    invisible(TRUE)
}

# modified from usethis:::uses_git
uses_git_pkgrv <- function (path) {
    repo <- tryCatch(gert::git_find(proj_get()), error = function(e) NULL)
    !is.null(repo)
}

# inspired by usethis:::can_overwrite
overwrite_dir <- function (path)
{
    if (!fs::file_exists(path)) {
        return(TRUE)
    }
    if (interactive()) {
        usethis::ui_yeah("Overwrite pre-existing directory {ui_path(path)}?")
    }
    else {
        FALSE
    }
}


write_dir <- function(tmp_dir, out_dir){
    assertthat::assert_that(dir.exists(dirname(out_dir)))

    dir_type <- dplyr::case_when(
        file.exists(file.path(tmp_dir, "DESCRIPTION")) ~ "pkg_dir",
        TRUE ~ "review_dir")

        if (dir.exists(out_dir)) {
            unlink(out_dir, recursive=TRUE)
        }
        file.copy(tmp_dir, dirname(out_dir), recursive = T)
        usethis::ui_done("{usethis::ui_field(dir_type)} written out successfully")
}


### add former usethis:::package_data(), now removed (see https://github.com/r-lib/usethis/pull/1747)
package_data <- function(base_path = NULL) {
  desc <- desc::description$new(base_path)
  as.list(desc$get(desc$fields()))
}
