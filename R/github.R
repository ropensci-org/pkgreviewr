# get issue metadata
issue_meta <- function(pkg_repo, parameter = c("number", "url"), strict = FALSE){

    software_review_url <- "https://github.com/ropensci/software-review/issues/"
    onboard_url <- "https://github.com/ropensci/onboarding/issues/"
    readme_url <- paste0("https://raw.githubusercontent.com/",
                         pkg_repo,"/master/README.md")

    readme <- suppressMessages(httr::content(httr::GET(readme_url)))

    if(strict){
        assertthat::assert_that(readme != "404: Not Found\n",
                                msg = paste0(readme_url,
                                             ": \n not valid url for repo README raw text"))
    }else{
        valid_issue <- assertthat::validate_that(
            readme != "404: Not Found\n",
            readme != "404: Not Found",
            msg = "undetermined")

        if(valid_issue == "undetermined"){
            warning(paste0(readme_url,
                           "\n not a valid url to review pkg README raw contents
ropensci onboarding issue undetermined"))
            return(valid_issue)
        }
    }

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
        warning("All rOpenSci package review is conducted through GitHub.
             To enable correct detection of your GitHub username,
             a PAT, Personal Authorisation Token, needs to be set up. \n
             Use `usethis::create_github_token` to generate a PAT. \n
             Use `usethis::edit_r_environ` to store it as environment variable
             GITHUB_PAT or GITHUB_TOKEN in your .Renviron file. \n

             For more info, see article on publishing review on GitHub in pkgreviewr documentation.")
    }
}

clone_pkg <- function(pkg_repo, pkg_dir){

    clone <- try(git2r::clone(paste0("https://github.com/", pkg_repo),
                              pkg_dir))

    if(inherits(clone, "try-error")){
        usethis::ui_warn("clone of {usethis::ui_value(pkg_repo)} unsuccesful.")
        usethis::ui_todo("Try {usethis::ui_code(paste0('git clone https://github.com/', pkg_repo, ' ', pkg_dir))} in the terminal to clone pkg source code")
        return(FALSE)
    }
    usethis::ui_done("Package {usethis::ui_field('source')} cloned successfully")
    return(TRUE)
}

get_repo_meta <- function(pkg_repo, full = FALSE){
    meta <- try(gh::gh(paste0("/repos/", pkg_repo)), silent = T)
    if(inherits(meta, "try-error")) {
        if(grepl("404", meta)){
            stop("Public repo: ", pkg_repo, " not found on GitHub. 404 error")
        }else{
            stop("Call to gh API failed with error: \n\n", meta)
        }
    }
    if(full){meta}else{list(name = meta$name, owner = meta$owner$login)}
}


