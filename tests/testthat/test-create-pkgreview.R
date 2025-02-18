test_that("review-proj-created-correctly", {
  skip_if_offline()

  review_parent <- withr::local_tempdir()
  review_dir <- file.path(review_parent, "riem-review")
  pkg_dir <- file.path(review_parent, "riem")

  pkgreview_create("ropensci/riem", review_parent) # nolint: nonportable_path_linter

  expect_true("riem-review" %in% list.files(review_parent))
  expect_true(
    all(c("index.Rmd", "README.md", "review.md") %in% list.files(review_dir))
  )
  expect_true(
    all(c("DESCRIPTION", "README.md") %in% list.files(pkg_dir))
  )
})

test_that("get-pkg_data", {
  skip_if_offline()

  review_parent <- withr::local_tempdir()
  review_dir <- file.path(review_parent, "riem-review")
  pkg_dir <- file.path(review_parent, "riem")
  pkgreview_create("ropensci/riem", review_parent)# nolint: nonportable_path_linter

  pkg_data <- pkgreview_getdata("ropensci/riem", pkg_dir)# nolint: nonportable_path_linter
  issue_no <- issue_meta("ropensci/riem")# nolint: nonportable_path_linter
  issue_url <- issue_meta("ropensci/riem", "url")# nolint: nonportable_path_linter

  # issue_meta
  expect_identical(issue_meta, issue_meta)
  expect_identical(issue_url, "https://github.com/ropensci/onboarding/issues/39")# nolint: nonportable_path_linter

  pkg_data[["pkg_dir"]] <- "<path>"
  expect_snapshot(pkg_data)
})
