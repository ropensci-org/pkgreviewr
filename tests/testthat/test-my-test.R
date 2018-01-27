context("test-my-test.R")

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
pkgreview_init(pkg_repo, review_dir, open = F)

cat(list.files(review_dir))

test_that("structure-correct", {
    expect_true("index.Rmd" %in% list.files(review_dir))
    expect_true("pkgreview.md" %in% list.files(review_dir))
    expect_true("R" %in% list.files(review_dir))
    #expect_true("rdflib-review.Rproj" %in% list.files(review_dir))
    expect_true("README.md" %in% list.files(review_dir))
})


test_that("review-initialised-correctly", {
    expect_equal(sort(list.files(review_dir)),
                 sort(c("index.Rmd", "pkgreview.md", "R",
                   #"rdflib-review.Rproj",
                   "README.md")))
})
