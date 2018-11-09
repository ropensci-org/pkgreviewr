context("test-render-templates.R")

library(pkgreviewr)

test_that("template-paths-resolve",{
    expect_true(
        system.file("templates",
                    template_name = "review-README",
                    package = "pkgreviewr") != "")
    expect_true(
        system.file("templates",
                    template_name = "review-index",
                    package = "pkgreviewr") != "")
})
