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


test_that("template-urls-resolve", {

    template <- "editor"
    expect_s3_class(
                    gh::gh("/repos/:owner/:repo/contents/:path",
                           owner = "ropensci",
                           repo = "dev_guide",
                           path = glue::glue("templates/{template}.md")),
                    c("gh_response", "list"))

    template <- "review"
    expect_s3_class(
                    gh::gh("/repos/:owner/:repo/contents/:path",
                           owner = "ropensci",
                           repo = "dev_guide",
                           path = glue::glue("templates/{template}.md")),
                    c("gh_response", "list"))
})
