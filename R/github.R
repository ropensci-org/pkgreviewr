# get issue metadata
issue_meta <- function(pkg_repo, parameter = c("number", "url"), strict = F){

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
            msg = "undetermined")

        if(valid_issue == "undetermined"){
            warning(paste0(readme_url,
                           "\n not a valid url to review pkg README raw contents
ropensci onboarding issue undetermined"))
            return(valid_issue)
        }
    }

    number <- gsub("([^0-9]).*$", "",
                   gsub(paste0("^.*", onboard_url), "",
                        readme))

    switch(match.arg(parameter),
           "number" = as.numeric(number),
           "url" = paste0(onboard_url, number))
}


# check username
check_global_git <- function(){
    test <- try(whoami::gh_username(), silent = T)
    if(class(test) == "try-error"){
        stop("All rOpenSci package review is conducted through github \n
             Prior to initialising a review, please ensure your global github credentials are correctly up. Use: \n\n
             git config --global user.name 'your.gh.username' \n
             git config --global user.email 'your.gh.email@example.com'\n
             in the terminal to configure your global settings")
    }
}
