# get issue metadata
issue_meta <- function(pkg_repo, parameter = c("number", "url"), strict = FALSE){

    software_review_url <- "https://github.com/ropensci/software-review/issues/"
    onboard_url <- "https://github.com/ropensci/onboarding/issues/"
    readme_url <- gh::gh(sprintf("/repos/%s/readme", pkg_repo))[["download_url"]]

    temp_readme <- withr::local_tempfile()
    curl::curl_download(readme_url, temp_readme)
    readme <- brio::read_lines(temp_readme)

    number <- gsub("([^0-9]).*$", "",
                   gsub(paste0("(^.*", onboard_url, "|^.*",
                               software_review_url,")"), "",
                        readme))

    switch(match.arg(parameter),
           "number" = as.numeric(number),
           "url" = paste0(onboard_url, number))
}


# check username
check_global_git <- function(){
    test <- try_whoami()
    if(class(test)[1] == "try-error"){
        usethis::git_sitrep()
    }
}

clone_pkg <- function(pkg_repo, pkg_dir) {

    usethis::create_from_github(pkg_repo, destdir = pkgdir, open = FALSE)
}

get_repo_meta <- function(pkg_repo, full = FALSE){
   meta <- gh::gh(paste0("/repos/", pkg_repo))

    if (full) {
      meta
    } else {
      list(name = meta$name, owner = meta$owner$login)
    }
}


