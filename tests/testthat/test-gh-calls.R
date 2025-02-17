test_that("check-get_repo_meta", {
    skip_if_offline()
    expect_snapshot(get_repo_meta("annakrystalli/rdflib"))
    expect_snapshot(get_repo_meta("bogusrepo"), error = TRUE)
})
