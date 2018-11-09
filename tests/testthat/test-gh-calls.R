context("test-gh-calls.R")


library(pkgreviewr)

pkg_repo <- "annakrystalli/rdflib"

test_that("check-get_repo_meta", {
    tr <- try(silent = TRUE,
        gh <- httr::GET(
            "https://api.github.com",
            httr::add_headers("user-agent" = "https://github.com/r-lib/whoami"),
            httr::timeout(1.0)
        )
    )
    if (inherits(tr, "try-error") || gh$status_code != 200) {
        skip("No internet, skipping")
    }

    meta <- get_repo_meta(pkg_repo)
    expect_equal(meta$name, "rdflib")
    expect_equal(meta$owner, "annakrystalli")
    expect_error(get_repo_meta("bogusrepo"))

    expect_identical(get_repo_meta(pkg_repo),
                     structure(list(name = "rdflib", owner = "annakrystalli"),
                               .Names = c("name", "owner")))
    expect_identical(get_repo_meta(pkg_repo, full = T)$owner$login, "annakrystalli")

})

test_that("gh_username-works", {
    expect_equal(whoami::gh_username(),
                 "annakrystalli")
})



