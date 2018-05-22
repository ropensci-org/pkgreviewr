
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

To enable local testing of the package, review creation also clones the review package source code into `review_parent` from the github repository defined in `pkg_repo` . This also makes it available for local review and perhaps even a pull request. Correcting typos in documentation can be a great review contribution, but first you might want to check the contributing guidelines or ask the author if they are open to such pull requests.

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



## rOpenSci 2018: `pkgtests` branch


### Argument default usage

We introduced the `rev_args()` function that identifies all the arguments used in the functions of a given package and its main feature is a logical vector indicating if the default value of the argument is consistent across all uses of the argument. The idea is that this information can be useful to a reviewer because it is a proxy of the complexity of the package and potential source of confusion to users. Maybe the package uses the same argument name for two completely different things. Or maybe it's a logical flag that sometimes is set to `TRUE` and other times to `FALSE`.

#### Details

The function `rev_args(path = '.', exported_only = FALSE)` takes two arguments:

* `path`: path to a package
* `exported_only`: logical indicating whether to focus only on the exported functions or not.

`rev_args()` returns a list with two elements:

* `arg_df`: a data.frame with columns
    - `arg_name`: name of the argument
    - `n_functions`: number of functions where the argument is used
    - `default_consistent`: logical, is the argument default value consistent across all usages
    - `default_consistent_percent`: [0, 100] indicating how consistent the default usage is when compared against the first use of the argument.
* `arg_map`: a logical matrix with function names in the rows, argument names in the columns. It indicates where each argument is used.

#### Example output

```R
## Install viridisLite if needed
> install.packages('viridisLite')

## Identify the location of the test version of viridisLite that's included
> path <- system.file('viridisLite', package = 'pkgreviewr', mustWork = TRUE)

## Run rev_args() on the example package viridisLite that is included in pkgreviewr
> arg_info_exported <- rev_args(path = path, exported_only = TRUE)

## Explore the output
> arg_info_exported
$arg_df
   arg_name n_functions default_consistent default_consistent_percent
1         n           5              FALSE                         80
2     alpha           5               TRUE                        100
3     begin           5               TRUE                        100
4       end           5               TRUE                        100
5 direction           5               TRUE                        100
6    option           2               TRUE                        100

$arg_map
              n alpha begin  end direction option
cividis    TRUE  TRUE  TRUE TRUE      TRUE  FALSE
magma      TRUE  TRUE  TRUE TRUE      TRUE  FALSE
plasma     TRUE  TRUE  TRUE TRUE      TRUE  FALSE
viridis    TRUE  TRUE  TRUE TRUE      TRUE   TRUE
viridisMap TRUE  TRUE  TRUE TRUE      TRUE   TRUE
```

In this example, the `n` argument doesn't have a consistent default value in all 5 functions where it's used.
<<<<<<< HEAD
=======


### Review dependency usage

New `rev_dependency_usage()` counts used functions from external packages.

``` r
library(pkgreviewr)
library(dplyr, warn.conflicts = FALSE)
```

```r
n_deps <- rev_dependency_usage()

# You may want to remove dependency on packages from which you use few functions
# As tibble truncates `functions` so they use no more than a single line
as_tibble(arrange(n_deps, n))
#> # A tibble: 20 x 3
#>    package         n functions                                            
#>    <chr>       <int> <chr>                                                
#>  1 ???             1 n                                                    
#>  2 base64enc       1 base64decode                                         
#>  3 devtools        1 as.package                                           
#>  4 functionMap     1 map_r_package                                        
#>  5 gh              1 gh                                                   
#>  6 magrittr        1 %>%                                                  
#>  7 pkgreviewr      1 rev_calls                                            
#>  8 purrr           1 map                                                  
#>  9 rmarkdown       1 render                                               
#> 10 stats           1 setNames                                             
#> 11 tidyr           1 separate                                             
#> 12 utils           1 lsf.str                                              
#> 13 whoami          1 gh_username                                          
#> 14 assertthat      2 assert_that, validate_that                           
#> 15 dplyr           3 filter, group_by, summarize                          
#> 16 httr            3 content, GET, http_error                             
#> 17 rstudioapi      3 isAvailable, openProject, getVersion                 
#> 18 usethis         5 create_project, use_template, use_git_hook, proj_get~
#> 19 git2r           6 clone, init, status, add, commit, discover_repository
#> 20 igraph          6 degree, vertex_attr, V, ego, graph_from_data_frame, ~
```

`kable()` lets you see al functions even if they don't fit in a single line.

```r
knitr::kable(n_deps)
```

<table>
<thead>
<tr class="header">
<th style="text-align: left;">package</th>
<th style="text-align: right;">n</th>
<th style="text-align: left;">functions</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">???</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">n</td>
</tr>
<tr class="even">
<td style="text-align: left;">assertthat</td>
<td style="text-align: right;">2</td>
<td style="text-align: left;">assert_that, validate_that</td>
</tr>
<tr class="odd">
<td style="text-align: left;">base64enc</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">base64decode</td>
</tr>
<tr class="even">
<td style="text-align: left;">devtools</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">as.package</td>
</tr>
<tr class="odd">
<td style="text-align: left;">dplyr</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">filter, group_by, summarize</td>
</tr>
<tr class="even">
<td style="text-align: left;">functionMap</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">map_r_package</td>
</tr>
<tr class="odd">
<td style="text-align: left;">gh</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">gh</td>
</tr>
<tr class="even">
<td style="text-align: left;">git2r</td>
<td style="text-align: right;">6</td>
<td style="text-align: left;">clone, init, status, add, commit, discover_repository</td>
</tr>
<tr class="odd">
<td style="text-align: left;">httr</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">content, GET, http_error</td>
</tr>
<tr class="even">
<td style="text-align: left;">igraph</td>
<td style="text-align: right;">6</td>
<td style="text-align: left;">degree, vertex_attr, V, ego, graph_from_data_frame, set_vertex_attr</td>
</tr>
<tr class="odd">
<td style="text-align: left;">magrittr</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">%&gt;%</td>
</tr>
<tr class="even">
<td style="text-align: left;">pkgreviewr</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">rev_calls</td>
</tr>
<tr class="odd">
<td style="text-align: left;">purrr</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">map</td>
</tr>
<tr class="even">
<td style="text-align: left;">rmarkdown</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">render</td>
</tr>
<tr class="odd">
<td style="text-align: left;">rstudioapi</td>
<td style="text-align: right;">3</td>
<td style="text-align: left;">isAvailable, openProject, getVersion</td>
</tr>
<tr class="even">
<td style="text-align: left;">stats</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">setNames</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tidyr</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">separate</td>
</tr>
<tr class="even">
<td style="text-align: left;">usethis</td>
<td style="text-align: right;">5</td>
<td style="text-align: left;">create_project, use_template, use_git_hook, proj_get, use_git_ignore</td>
</tr>
<tr class="odd">
<td style="text-align: left;">utils</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">lsf.str</td>
</tr>
<tr class="even">
<td style="text-align: left;">whoami</td>
<td style="text-align: right;">1</td>
<td style="text-align: left;">gh_username</td>
</tr>
</tbody>
</table>

Created on 2018-05-22 by the [reprex package](http://reprex.tidyverse.org) (v0.2.0).

