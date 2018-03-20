
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

***

## Review workflow

### Overview

1. Create and initialise review project 

1. Open `index.Rmd` and work through the review in the notebook. You can make notes either in `index.Rmd` or directly in the `pkgreview.md` response template.

1. Submit your review in the package `ropensci/onboarding` issue by copying and pasting the completed `pkgreview.md` template.

1. OPTIONAL: Publish your report by pushing to GitHub.

<br>

### Example

This is a basic example of **setting up an rOpenSci package review project**:


### 1. create review project

Create the review project, using `pkgreview_create`. The function takes arguments:

* **`pkg_repo`:** the **GitHub repo** details of the **package under review** in the form `username/repo` 
* **`review_parent`:**, the **local directory** in which the **review project (and folder) will be created** and **package source code will be cloned into**.

``` r
library(pkgreviewr)
pkgreview_create(pkg_repo = "cboettig/rdflib", 
                 review_parent = "~/Documents/workflows/rOpenSci/reviews/")
```

The function creates a new review project in the `review_parent` directory following project naming convention `{pkgname}-review` and populates the review templates to create all required documents. 

#### review files

The review project directory will contain all the files you'll need to complete the review and will be initialised with git.

```
rdflib-review
├── README.md
├── index.Rmd
├── pkgreview.md
└── rdflib-review.Rproj
```

#### **`index.Rmd`**

The most important file it creates is the `index.Rmd html_notebook` file. This workbook is prepopulated with all the major steps required to complete the review in an interactive document to perform and record it in. It also extracts useful links, information and parameter values. 

**See example [here](https://github.com/annakrystalli/pkgreviewr/blob/master/inst/examples/example-review-index.Rmd).**

Once rendered to **`index.nb.html`** (`*.nb.html` is the notebook file format), this report can be pushed to GitHub for publication.

#### **`pkgreview.md`** 

Template response form to submit to the package rOpenSci onboarding review issue. 

**See template [here](https://github.com/annakrystalli/pkgreviewr/blob/master/inst/examples/example-pkgreview.md)**.

#### **`README.md`** 

Prepopulated README for the review repo that will present the repo to people navigating to it. 

**See example [here:](https://github.com/annakrystalli/pkgreviewr/blob/master/inst/examples/example-README.md)**.

***





#### clone of package source code

To enable local testing of the package, review creation also clones the review package source code into `review_parent` from the github repository defned in `pkg_repo` . This also makes it available for local review and perhaps even a pull request. Correcting typos in documentation can be a great review contribution, but first you might want to check the contributing guidelines or ask the author if they are open to such pull requests.

The resulting files from a successful review project will look like this: 

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
    ├── README.md
    ├── index.Rmd
    └── rdflib-review.Rproj

```

<br>

### 2. Perform your review:

Use the index.Rmd notebook to work through the review interactively. The document is designed to guide the process in a logical fashion and bring your attention to relevant aspects and information at different stages of the review. You can make notes and record comments within index.Rmd or directly in the review submission form. 

<br>

### 3. Submit your review:

Currently the workflow is just set up for you to just copy your response from your completed `pkgreview.md` and paste it into the review issue but we're exploring programmatic submission also. Because the response is currently submitted as `.md`, package `reprex` might be useful for inserting reproducible demos of any issues encountered. 

<br>

### 4. Publish your report by pushing to GitHub *

Optional. Have a look at the **Publish pkgreview on GitHub** vignette.
