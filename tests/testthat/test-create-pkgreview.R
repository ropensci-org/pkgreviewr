context("test-create-pkgreview.R")
on.exit(unlink(review_parent, recursive = T))

test_that("review-proj-created-correctly", {

    #  create review project
    mockery::stub(pkgreview_create,"check_rstudio", NULL)
    #mockery::stub(pkgreview_create,"openProject", NULL)
    pkgreview_create(pkg_repo, review_parent)

    expect_true("rdflib-review" %in% list.files(review_parent))
    expect_true(git2r::in_repository(review_dir))
    expect_true(all(c("index.Rmd", "README.md", "review.md") %in%
                    list.files(review_dir)))
    expect_identical(sort(list.files(pkg_dir, all.files = TRUE)),
                     sort(c(".", "..", ".git", ".gitignore", ".Rbuildignore", ".travis.yml",
                       "appveyor.yml", "codecov.yml", "codemeta.json", "DESCRIPTION",
                       "docs", "inst", "LICENSE", "man", "NAMESPACE", "NEWS.md", "paper.bib",
                       "paper.md", "R", "rdflib.Rproj", "README.md", "README.Rmd", "tests",
                       "vignettes")))
    # expect_true("rdflib-review.Rproj" %in% list.files(review_dir))
})

test_that("get-pkg_data", {
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

    pkg_data <- pkgreviewr:::pkgreview_getdata(pkg_dir, pkg_repo)

    # issue_meta
    expect_warning(pkgreviewr:::issue_meta("cboettig/rdflibh"), "undetermined")
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
    expect_equal(pkg_data$URL, "https://github.com/annakrystalli/rdflib")
    expect_equal(pkg_data$site, "https://cboettig.github.io/rdflib")
    expect_false(pkg_data$Rmd)
})



