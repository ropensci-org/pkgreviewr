
[![Travis build status](https://travis-ci.org/ropenscilabs/pkgreviewr.svg?branch=master)](https://travis-ci.org/ropenscilabs/pkgreviewr)
[![codecov](https://codecov.io/gh/ropenscilabs/pkgreviewr/branch/master/graph/badge.svg)](https://codecov.io/gh/ropenscilabs/pkgreviewr)

# pkgreviewr

The goal of pkgreviewr is to facilitate **rOpenSci** package reviews.

## Installation

You can install pkgreviewr from GitHub with:


``` r
# install.packages("devtools")
devtools::install_github("ropenscilabs/pkgreviewr")
```


Because rOpenSci reviews are conducted through github repository [`ropensci/onboarding`](https://github.com/ropensci/onboarding), `pkgreviewr` uses your GitHub user.name and user.email when creating new review projects. If you do not have both settings in your global configuration, you will receive an error. You can set both from within your terminal:

```
# Example GitHub global configuration
git config --global user.name "Mona Lisa"
git config --global user.email "email@example.com"
```

To check you current git configuration, use:
```
git config --global --list
```

The package also makes use of [**`R Notebooks`**](https://rmarkdown.rstudio.com/r_notebooks.html) (an RMarkdown format) and requires installation of **Rstudio version 1.0** or higher 


## Example

This is a basic example of **setting up an rOpenSci package review project**:

<br>

### create review project

Next, create the review project, using `pkgreview_create`. The function takes arguments:

* **`pkg_repo`:** the **GitHub repo** details of the **package under review** in the form `username/repo` 
* **`review_parent`:**, the **local directory** in which the **review project (and folder) will be created** and **package source code will be cloned into**.

The function creates a new review project (or prompts for instruction if it already exists) and navigates to the review project root. 

``` r
library(pkgreviewr)
pkgreview_create(pkg_repo = "cboettig/rdflib", 
                 review_parent = "~/Documents/workflows/rOpenSci/reviews/")
```
<br>

### initialise review

Next, initialise the review project.

``` r
library(pkgreviewr)
pkgreview_init(pkg_repo = "cboettig/rdflib")

```

#### clone of package source code

To enable local testing of the package, initialisation clones package source code from github to a second, sibling directory to the review project. This also makes it available for local review and perhaps even a pull request. Correcting typos in documentation can be a great review contribution, but first ask the author if they are open to such pull requests!

```
reviews
├── rdflib
│   ├── DESCRIPTION
│   ├── LICENSE
│   ├── NAMESPACE
│   ├── NEWS.md
│   ├── R
│   │   └── rdf.R
│   ├── README.Rmd
│   ├── README.md
│   ├── appveyor.yml
│   ├── codecov.yml
│   ├── codemeta.json
│   ├── docs
│   │   ├── LICENSE.html
│   │   ├── articles
│   │   │   ├── index.html
│   │   │   ├── rdflib.html
│   │   │   └── rdflib_files
│   │   │       ├── datatables-binding-0.2
│   │   │       │   └── datatables.js
│   │   │       ├── dt-core-1.10.12
│   │   │       │   ├── css
│   │   │       │   │   ├── jquery.dataTables.extra.css
│   │   │       │   │   └── jquery.dataTables.min.css
│   │   │       │   └── js
│   │   │       │       └── jquery.dataTables.min.js
│   │   │       ├── htmlwidgets-0.9
│   │   │       │   └── htmlwidgets.js
│   │   │       └── jquery-1.12.4
│   │   │           ├── LICENSE.txt
│   │   │           └── jquery.min.js
│   │   ├── authors.html
│   │   ├── index.html
│   │   ├── jquery.sticky-kit.min.js
│   │   ├── link.svg
│   │   ├── news
│   │   │   └── index.html
│   │   ├── pkgdown.css
│   │   ├── pkgdown.js
│   │   └── reference
│   │       ├── index.html
│   │       ├── rdf.html
│   │       ├── rdf_add.html
│   │       ├── rdf_parse.html
│   │       ├── rdf_query.html
│   │       ├── rdf_serialize.html
│   │       └── rdflib-package.html
│   ├── inst
│   │   ├── examples
│   │   │   └── rdf_table.R
│   │   └── extdata
│   │       ├── ex.xml
│   │       └── vita.json
│   ├── man
│   │   ├── rdf.Rd
│   │   ├── rdf_add.Rd
│   │   ├── rdf_parse.Rd
│   │   ├── rdf_query.Rd
│   │   ├── rdf_serialize.Rd
│   │   └── rdflib-package.Rd
│   ├── paper.bib
│   ├── paper.md
│   ├── rdflib.Rproj
│   ├── tests
│   │   ├── testthat
│   │   │   └── test-rdf.R
│   │   └── testthat.R
│   └── vignettes
│       └── rdflib.Rmd
└── rdflib-review
    ├── R
    ├── README.md
    ├── index.Rmd
    └── rdflib-review.Rproj

```

#### review files

After initialisation, the review project directory will contain all the files you'll need to complete the review and will be initialised with git.

```
rdflib-review
├── R
├── README.md
├── index.Rmd
├── pkgreview.md
└── rdflib-review.Rproj
```
<br>


## Review files

### `index.Rmd` 

The most important file it creates is the `index.Rmd html_notebook` file. This workbook is prepopulated with all the major steps required to complete the review in an interactive document to perform and record it in. It also extracts useful links, information and parameter values. 

#### See **example [here](https://github.com/annakrystalli/pkgreviewr/blob/master/inst/examples/example-review-index.Rmd).**

Once rendered to `index.nb.html` (`.nb.html` is the notebook file format), this report can be pushed to GitHub for publication.

### `pkgreview.md` 

Template response form to submit to the package rOpenSci onboarding review issue. 

#### See **template [here](https://github.com/annakrystalli/pkgreviewr/blob/master/inst/examples/example-pkgreview.md)**.

### `README.md` 

Prepopulated README for the review repo that will present the repo to people navigating to it. 

#### See **example [here:](https://github.com/annakrystalli/pkgreviewr/blob/master/inst/examples/example-README.md)**.

***

# Review workflow

1. Create review project 
1. Initialise project
1. Create blank (don't autimatically create any files on GitHub) review repository on GitHub and link. 
    - Follow naming convention `"{pkgname}-review"`.
    - Link local review project to the repository through the terminal, eg
    ```
    git remote add origin https://github.com/annakrystalli/rdflib-review.git
    git push -u origin master
    ```
1. Open `index.Rmd` and work through the review in the notebook. You can make notes either in `index.Rmd` or directly in the `pkgreview.md` response file.
1. Submit your review in the package `ropensci/onboarding` issue by copying and pasting the completed template.
1. Publish your report by pushing to GitHub.




