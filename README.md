
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing) [![Travis build status](https://travis-ci.org/ropenscilabs/pkgreviewr.svg?branch=master)](https://travis-ci.org/ropenscilabs/pkgreviewr)
[![codecov](https://codecov.io/gh/ropenscilabs/pkgreviewr/branch/master/graph/badge.svg)](https://codecov.io/gh/ropenscilabs/pkgreviewr)

# pkgreviewr

The goal of pkgreviewr is to facilitate **rOpenSci** reviewers in their package reviews. 

It creates a review project containing populated templates of all the files you'll need to complete your review. It also clones the source code of the package under review to a convenient location, allowing easy checking and testing.

See [Getting started](articles/01_get_started.html) vignette for more details

## Installation

You can install `pkgreviewr` from GitHub with:


``` r
# install.packages("devtools")
devtools::install_github("ropenscilabs/pkgreviewr")
```
<br>


### git configuration

Because rOpenSci reviews are conducted through github repository [`ropensci/software-review`](https://github.com/ropensci/software-review), **`pkgreviewr` uses your GitHub `user.name` and `user.email` when creating new review projects**. If you do not have both settings in your global configuration, you will receive an error. 

#### `usethis`

You see if user name and email are currently configured with **`usethis` function `use_git_config()`**

```r
# install.packages("usethis")
usethis::use_git_config()
```

You can set both using:

```r
usethis::use_git_config(
    user.name = "Jane", 
    user.email = "jane@example.org")
```

#### terminal

Alternatively, from **within your terminal**,

check you current git configuration with:

```{bash}
git config --global --list
```
and set it with

```{bash}
git config --global user.name "Jane"
git config --global user.email "jane@example.org"
```
<br>

### R Notebooks

The package also makes use of [**`R Notebooks`**](https://rmarkdown.rstudio.com/r_notebooks.html) (an RMarkdown format) and requires installation of **Rstudio version 1.0** or higher 

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
