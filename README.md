
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing) ![GitHub R package version](https://img.shields.io/github/r-package/v/ropensci-org/pkgreviewr) [![Travis build status](https://travis-ci.org/ropenscilabs/pkgreviewr.svg?branch=master)](https://travis-ci.org/ropenscilabs/pkgreviewr)
[![codecov](https://codecov.io/gh/ropenscilabs/pkgreviewr/branch/master/graph/badge.svg)](https://codecov.io/gh/ropenscilabs/pkgreviewr)

# pkgreviewr

The goal of pkgreviewr is to facilitate **rOpenSci** reviewers in their package reviews. 

It creates a review project containing populated templates of all the files you'll need to complete your review. It also clones the source code of the package under review to a convenient location, allowing easy checking and testing.

See [Getting started](articles/get_started.html) vignette for more details

## Installation

You can install `pkgreviewr` from GitHub with:


``` r
# install.packages("devtools")
devtools::install_github("ropenscilabs/pkgreviewr")
```
<br>

### Git

`pkgreviewr` functions clone the source code of the package under review so require **Git** to be installed. 

### GitHub user configuration

Because rOpenSci reviews are conducted through github repository [`ropensci/software-review`](https://github.com/ropensci/software-review), **`pkgreviewr` uses your GitHub username to prepopulate various fields in the review project files**.

To detect your username correctly, a PAT, Personal Authorisation Token, needs to be set up.
You can use `usethis::browse_github_pat()` to generate a PAT and `usethis::edit_r_environ()` to store it as environment variable `GITHUB_PAT` or `GITHUB_TOKEN` in your .`Renviron` file. For more info, see article on publishing review on GitHub in pkgreviewr documentation.

If you do not have a PAT set up, you will receive an warning and any fields related to your GitHub username will not be correctly populated. However, this shouldn't affect your ability to complete your review. 


### R Notebooks

The package currently also makes use of [**`R Notebooks`**](https://rmarkdown.rstudio.com/r_notebooks.html) (an RMarkdown format) and requires installation of **Rstudio version 1.0** or higher, but we are [considering offering an option to remove the requirement for RStudio](https://github.com/ropenscilabs/pkgreviewr/issues/64).

***

## Review workflow

<br>

#### 1. Create and initialise review project 

```r
library(pkgreviewr)
pkgreview_create(pkg_repo = "ropensci/rdflib", 
                 review_parent = "~/Documents/workflows/rOpenSci/reviews/")
```

The review project directory will contain all the files you'll need to complete the review and will be initialised with git.

```
rdflib-review
├── README.md
├── index.Rmd
├── pkgreview.md
└── rdflib-review.Rproj
```
<br>

#### 2. Perform review

Open `index.Rmd` and work through the review in the notebook. You can make notes either in `index.Rmd` or directly in the `pkgreview.md` response template.

<br>

#### 3. Submit review

Submit your review in the package [`ropensci/software-review`](https://github.com/ropensci/software-review/issues) issue by copying and pasting the completed `pkgreview.md` template.

<br>

#### 4. Publish review*

OPTIONAL: Publish your review on GitHub. See [vignette](articles/publish-review-on-github.html) for further instructions

<br>


***

## `pkgreviewr` for editors 

`pkgreviewr` can now also be used to set up projects for editor checks. See [`pkgreviewr` for editors](articles/editors.html) vignette.


***

Please note that 'pkgreviewr' is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.
