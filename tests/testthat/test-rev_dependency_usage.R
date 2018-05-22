context("test-rev_dependency_usage.R")

test_that("outputs a 3-column dataframe with names package, n, functions", {
  n_deps <- rev_dependency_usage()
  expect_s3_class(n_deps, "data.frame")
  expect_named(n_deps, c("package", "n", "functions"))
})
