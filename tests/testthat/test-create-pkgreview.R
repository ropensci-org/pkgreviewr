test_that("review-proj-created-correctly", {

  skip_if_offline()

  review_parent <- withr::local_tempdir()
  review_dir <- file.path(review_parent, "riem-review")
  pkg_dir <- file.path(review_parent, "riem")

  pkgreview_create("ropensci/riem", review_parent)

  expect_true("riem-review" %in% list.files(review_parent))
  #expect_true(use_git_pkgrv(review_dir))
  expect_true(all(c("index.Rmd", "README.md", "review.md") %in%
      list.files(review_dir)))
  expect_true(all(c("DESCRIPTION", "README.md") %in%
      list.files(pkg_dir)))

})

test_that("get-pkg_data", {
  review_parent <- withr::local_tempdir()
  review_dir <- file.path(review_parent, "riem-review")
  pkg_dir <- file.path(review_parent, "riem")
  pkgreview_create("ropensci/riem", review_parent)

  httptest::with_mock_dir("data", {
    pkg_data <- pkgreview_getdata(pkg_dir, "ropensci/riem")
    issue_no <- issue_meta("ropensci/riem")
    issue_url <- issue_meta("ropensci/riem", "url")
  })


  # issue_meta
  expect_equal(issue_meta, issue_meta)
  expect_equal(issue_url, "https://github.com/ropensci/onboarding/issues/39")

  pkg_data$pkg_dir <- "<path>"
  expect_snapshot(pkg_data)
})
