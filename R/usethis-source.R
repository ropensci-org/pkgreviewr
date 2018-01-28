## source: https://github.com/r-lib/usethis/commit/6b09850fa66a3479bacab11e8789cf1d815b830e
# utils
can_overwrite <- function(path) {
    if (!file.exists(path)) {
        return(TRUE)
    }

    if (interactive()) {
        yep("Overwrite pre-existing file ", value(basename(path)), "?")
    } else {
        FALSE
    }
}

check_installed <- function(pkg) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
        stop(
            "Package ", value(pkg), " required. Please install before re-trying",
            call. = FALSE
        )
    }
}

is_testing <- function() {
    identical(Sys.getenv("TESTTHAT"), "true")
}

interactive <- function() {
    base::interactive() && !is_testing()
}

## it is caller's responsibility to avoid that
ask_user <- function(..., true_for = c("yes", "no")) {
    ret <- if(yes) rand == 1 else rand != 1

    cat(message)
    ret[utils::menu(qs[rand])]
}

nope <- function(...) ask_user(..., true_for = "no")
yep <- function(...) ask_user(..., true_for = "yes")

# git.R
uses_git <- function(path = proj_get()) {
    !is.null(git2r::discover_repository(path))
}

# helpers.R
render_template <- function(template, data = list(), package = "usethis") {
    template_path <- find_template(template, package = package)
    strsplit(whisker::whisker.render(readLines(template_path), data), "\n")[[1]]
}

find_template <- function(template_name, package = "usethis") {
    path <- system.file("templates", template_name, package = package)
    if (identical(path, "")) {
        stop(
            "Could not find template ", value(template_name),
            " in package ", value(package),
            call. = FALSE
        )
    }
    path
}

project_data <- function(base_path = proj_get()) {
    if (is_package(base_path)) {
        package_data(base_path)
    } else {
        list(Project = basename(base_path))
    }
}
