# get issue metadata
issue_search <- function(repo){

 meta <-  gh::gh("/repos/:owner/:repo/issues",
                 owner = "ropensci",
                 repo = "onboarding",
                 query = paste("is:issue is:open", repo, "in:title"))
}

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
            return(valid_issue)
            }
    }

    number <- readme %>%
        gsub(paste0("^.*", onboard_url), "", .) %>%
        gsub("([^0-9]).*$", "", .)

    switch(match.arg(parameter),
           "number" = as.numeric(number),
           "url" = paste0(onboard_url, number))
}

