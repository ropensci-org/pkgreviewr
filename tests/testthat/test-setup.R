context("test-setup.R")

test_that("check-rstudio", {
    expect_error(pkgreviewr:::check_rstudio())
})

