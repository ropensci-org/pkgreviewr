context("test-rev_dependency_usage.R")

test_that("outputs a 3-column dataframe with names package, n, functions", {
  # TODO: How to test the root from the test directory?
  path <- usethis::proj_get()
  n_deps <- rev_dependency_usage(path = path)
  expect_s3_class(n_deps, "data.frame")
  expect_named(n_deps, c("package", "n", "functions"))
})
