context("test-setup.R")

# set test parameters
pkg_repo <- "annakrystalli/rdflib"
review_parent <- file.path(tempdir())
review_dir <- paste0(review_parent, "/rdflib-review")

#  create review project
pkgreview_create(pkg_repo, review_parent, open = F)

test_that("review-proj-created-correctly", {
  expect_true("rdflib-review" %in% list.files(review_parent))
   # expect_true("rdflib-review.Rproj" %in% list.files(review_dir))
})

#  init review project
mockery::stub(pkgreview_getdata, "whoami::gh_username", "dummy_username")
pkgreview_init(pkg_repo, review_dir, open = F)

cat(list.files(review_dir))

test_that("structure-correct", {
    expect_true("index.Rmd" %in% list.files(review_dir))
    expect_true("pkgreview.md" %in% list.files(review_dir))
    expect_true("R" %in% list.files(review_dir))
    #expect_true("rdflib-review.Rproj" %in% list.files(review_dir))
    expect_true("README.md" %in% list.files(review_dir))
})


test_that("review-files-initialised-correctly", {
    expect_equal(sort(list.files(review_dir)),
                 sort(c("index.Rmd", "pkgreview.md", "R",
                   #"rdflib-review.Rproj",
                   "README.md")))
})

meta <- devtools:::github_remote(pkg_repo)
pkg_dir <- file.path(paste0(review_dir, "/../", meta$repo))


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

    mockery::stub(pkgreview_getdata, "whoami::gh_username", "dummy_username")
    pkg_data <- pkgreview_getdata(pkg_dir)

    # issue_meta
    expect_equal(issue_meta("cboettig/rdflibh"), "undetermined")
    expect_equal(issue_meta("cboettig/rdflib"), 169)
    expect_equal(issue_meta("cboettig/rdflib", "url"),
                 "https://github.com/ropensci/onboarding/issues/169")

    expect_equal(pkg_data$pkg_repo, "annakrystalli/rdflib")
    expect_equal(pkg_data$username, "annakrystalli")
    expect_equal(pkg_data$index_url, "https://dummy_username.github.io/rdflib-review/index.nb.html")
    expect_equal(pkg_data$review_repo, "dummy_username/rdflib-review")
    expect_equal(pkg_data$pkgreview_url, "https://github.com/dummy_username/rdflib-review/blob/master/pkgreview.md")
    expect_equal(pkg_data$issue_url, "https://github.com/ropensci/onboarding/issues/169")
    expect_equal(pkg_data$number, 169)
    expect_equal(pkg_data$whoami, "dummy_username")
    expect_equal(pkg_data$whoami_url, "https://github.com/dummy_username")
    expect_equal(pkg_data$pkg_dir, pkg_dir)
    expect_equal(pkg_data$Package, "rdflib")
    expect_equal(pkg_data$repo, "rdflib")
    expect_equal(pkg_data$site, "https://annakrystalli.github.io/rdflib/")
    expect_false(pkg_data$Rmd)
})
