context("test-setup.R")

# set test parameters
pkg_repo <- "annakrystalli/rdflib"
review_parent <- file.path(tempdir())
review_dir <- file.path(review_parent, "rdflib-review")

test_that("check-rstudio", {
    expect_error(pkgreviewr:::check_rstudio())
})

library(rstudioapi)
#  create review project
mockery::stub(pkgreview_create,"check_rstudio", NULL)
#mockery::stub(pkgreview_create,"openProject", NULL)
pkgreview_create(pkg_repo, review_parent)

test_that("review-proj-created-correctly", {
  expect_true("rdflib-review" %in% list.files(review_parent))
   # expect_true("rdflib-review.Rproj" %in% list.files(review_dir))
})


test_that("gh_username-works", {
    expect_equal(whoami::gh_username(),
                 "annakrystalli")
})

test_that("missing-config-throws-error", {
    check_global_git <- pkgreviewr:::check_global_git
    mockery::stub(check_global_git,
                  "try", function(){
                      error <- TRUE
                      class(error) <- "try-error"
                      error
                  })
    expect_error(check_global_git())
    rm(check_global_git)
})




test_that("initialised-correctly", {
    expect_setequal(c("index.Rmd", "pkgreview.md", "README.md"),
                    list.files(review_dir, include.dirs = T))
        #expect_true("rdflib-review.Rproj" %in% list.files(review_dir))
})


meta <- devtools:::github_remote(pkg_repo)
pkg_dir <- file.path(review_dir, "..", meta$repo)



test_that("check-pkg_data", {

    tr <- try(
        silent = TRUE,
        gh <- httr::GET(
            "https://api.github.com",
            httr::add_headers("user-agent" = "https://github.com/r-lib/whoami"),
            httr::timeout(1.0)
        )
    )

    if (inherits(tr, "try-error") || gh$status_code != 200) {
        skip("No internet, skipping")
    }

    pkg_data <- pkgreview_getdata(pkg_dir)

    # issue_meta
    expect_equal(pkgreviewr:::issue_meta("cboettig/rdflibh"), "undetermined")
    expect_equal(pkgreviewr:::issue_meta("cboettig/rdflib"), 169)
    expect_equal(pkgreviewr:::issue_meta("cboettig/rdflib", "url"),
                 "https://github.com/ropensci/onboarding/issues/169")

    expect_equal(pkg_data$pkg_repo, "annakrystalli/rdflib")
    expect_equal(pkg_data$username, "annakrystalli")
    expect_equal(pkg_data$index_url, "https://annakrystalli.github.io/rdflib-review/index.nb.html")
    expect_equal(pkg_data$review_repo, "annakrystalli/rdflib-review")
    expect_equal(pkg_data$pkgreview_url, "https://github.com/annakrystalli/rdflib-review/blob/master/pkgreview.md")
    expect_equal(pkg_data$issue_url, "https://github.com/ropensci/onboarding/issues/169")
    expect_equal(pkg_data$number, 169)
    expect_equal(pkg_data$whoami, "annakrystalli")
    expect_equal(pkg_data$whoami_url, "https://github.com/annakrystalli")
    expect_equal(pkg_data$pkg_dir, pkg_dir)
    expect_equal(pkg_data$Package, "rdflib")
    expect_equal(pkg_data$repo, "rdflib")
    expect_equal(pkg_data$site, "https://annakrystalli.github.io/rdflib/")
    expect_false(pkg_data$Rmd)
})
