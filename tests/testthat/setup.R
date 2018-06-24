detach("package:pkgreviewr", unload=TRUE)
library(pkgreviewr)
library(rstudioapi)

# set test parameters
pkg_repo <- "annakrystalli/rdflib"

review_parent <- file.path(tempdir(), "pkgreviewr_test")
dir.create(review_parent, showWarnings = F)
review_dir <- file.path(review_parent, "rdflib-review")
pkg_dir <- file.path(review_parent, "rdflib")

