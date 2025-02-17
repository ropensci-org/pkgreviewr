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
