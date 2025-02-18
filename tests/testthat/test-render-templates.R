test_that("template-urls-resolve", {
  template <- "editor"
  expect_s3_class(
    gh::gh("/repos/:owner/:repo/contents/:path",
      owner = "ropensci",
      repo = "dev_guide",
      path = sprintf("templates/%s.md", template) # nolint: nonportable_path_linter
    ),
    c("gh_response", "list")
  )

  template <- "review"
  expect_s3_class(
    gh::gh("/repos/:owner/:repo/contents/:path",
      owner = "ropensci",
      repo = "dev_guide",
      path = sprintf("templates/%s.md", template) # nolint: nonportable_path_linter
    ),
    c("gh_response", "list")
  )
})
