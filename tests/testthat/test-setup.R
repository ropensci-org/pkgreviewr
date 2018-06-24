context("test-setup.R")

test_that("check-rstudio", {
    expect_error(pkgreviewr:::check_rstudio())
})

test_that("missing-git-config-throws-error", {
    check_global_git <- pkgreviewr:::check_global_git
    mockery::stub(check_global_git,
                  "try", function(){
                      error <- TRUE
                      class(error) <- "try-error"
                      error
                  })
    expect_error(check_global_git())
    rm(check_global_git)
})
