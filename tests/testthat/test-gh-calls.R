test_that("check-get_repo_meta", {
  skip_if_offline()
  expect_snapshot(get_repo_meta("annakrystalli/rdflib")) # nolint: nonportable_path_linter
  expect_snapshot(get_repo_meta("bogusrepo"), error = TRUE)
})
