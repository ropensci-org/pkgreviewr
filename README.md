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

This is a basic example of settign up an rOpenSci package review project:


First, create the review project, using `pkgreview_create`. The function takes arguments:

* `pkg_repo`, the **GitHub repo** details of the **package under review** in the form `username/repo` 
* `review_dir`, the local directory in which the review project will be created.

The function creates a new review project (or prompts for instruction if it already exists) and navigates to the review project root.

``` r
library(pkgreviewr)
pkgreview_create(pkg_repo = "cboettig/rdflib", 
                 review_dir = "~/Documents/workflows/rOpenSci/reviews/")
```

### initialise review

Next, initialise the review project with the materials you'll need.

``` r
library(pkgreviewr)
pkgreview_init("cboettig/rdflib")

```
The review project directory will now contain the following files and will be initialised with git.

```
rdflib-review
├── R
├── README.md
├── index.Rmd
├── pkgreview.md
└── rdflib-review.Rproj
```


<br>

### `index.Rmd` 

The most important file it creates is the `index.Rmd html_notebook` file. This workbook is prepopulated with all the major steps required to complete the review in an interactive document to perform and record it in. It also extracts useful links, information and parameter values. 

#### See **example [here](https://github.com/annakrystalli/pkgreviewr/blob/master/inst/examples/example-review-index.Rmd).**

Once rendered to `index.nb.html`, this report can be pushed to github for publication which needs to be pushed to github for the report

<br> 

### `clone of package source code` 

Initialisation also clones package source code from github to a second new directory, in the same directory and depth as the review project to perform local testing.

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

<br> 


### `pkgreview.md` 

Template response form to submit to the package rOpenSci onboarding review issue. 

#### See **template [here](https://github.com/annakrystalli/pkgreviewr/blob/master/inst/examples/example-pkgreview.md)**.

<br> 

### `README.md` 

Prepopulated README for the review repo. 

#### See **example [here:](https://github.com/annakrystalli/pkgreviewr/blob/master/inst/examples/example-README.md)**.

***

# Review workflow

1. Create review project 
1. Initialise project
1. Create blank (don't autimatically create any files on GitHub) review repository on `github` and link. 
    - Follow naming convention `"{pkgname}-review"`.
    - Link local review project to the repository through the terminal, eg
    ```
    git remote add origin https://github.com/annakrystalli/rdflib-review.git
    git push -u origin master
    ```
1. Open `index.Rmd` and work through the review in the notebook. You can make notes either in `index.Rmd` or directly in the `pkgreview.md` response file.
1. Submit your review in the package `ropensci/onboarding` issue by copying and pasting the completed template.
1. Publish your report by pushing to github.


### n.b.

For package to function correctly, the user will need to have their github account confirmed on the machine they are using.

To configure your git user settings, run the following command in the terminal, substituting with your github credentials.
```
git config --global user.name 'Anna Krystalli'
git config --global user.email 'annakrystalli@googlemail.com'
```

To check you current git configuration, run:
```
git config --global --list
```
