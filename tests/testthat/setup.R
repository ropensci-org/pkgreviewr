library(httptest2)
options(usethis.quiet = TRUE)
with_mock_dir <- function(name, ...) {
  skip_if_not_installed("httptest2") # Needed for httptest2::with_mock_dir
  httptest2::with_mock_dir(test_path("../fixtures", name), ...)
}
# set test parameters
pkg_repo <- "annakrystalli/rdflib"
