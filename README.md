# pkgreviewr

The goal of pkgreviewr is to facilitate **rOpenSci** package reviews.

## Installation

You can install pkgreviewr from GitHub with:


``` r
# install.packages("devtools")
devtools::install_github("annakrystalli/pkgreviewr")
```

## Example

### create review project

This is a basic example which shows you how to solve a common problem:


First, create the review project, using `pkgreview_create`. The function takes arguments `pkg_repo`, the repo details in the form `username/repo` and `review_dir`,
the directory in which the review project will be created.

The functions creates a new review project (or prompts for instruction if it already exists) and navigates to the project root.

``` r
library(pkgreviewr)
pkgreview_create(pkg_repo = "cboettig/rdflib", 
                 review_dir = "~/Documents/workflows/rOpenSci/reviews/")
```

### initialise review

Next, initialise the review project with the materials you'll need.

The file creates another folder at the same depth as the review project containing the package source code by cloning it from github.

It also creates a .`html_notebook` .rmd file, prepopulated with all the major steps required to complete the review.

``` r
pkgreview_init("cboettig/rdflib")

```


