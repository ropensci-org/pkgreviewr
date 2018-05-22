
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Example

``` r
library(pkgreviewr)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

Review dependency usage: Count used functions from external packages.

``` r
# Usnig default path to review dependency usage of pkgreviewr
n_deps <- rev_dependency_usage()

# You may want to remove dependency on packages from which you use few functions
# As tibble truncates `functions` so they use no more than a single line
as_tibble(arrange(n_deps, n))
#> # A tibble: 15 x 3
#>    package         n functions                                            
#>    <chr>       <int> <chr>                                                
#>  1 base64enc       1 base64decode                                         
#>  2 devtools        1 as.package                                           
#>  3 functionMap     1 map_r_package                                        
#>  4 gh              1 gh                                                   
#>  5 magrittr        1 %>%                                                  
#>  6 rmarkdown       1 render                                               
#>  7 tidyr           1 separate                                             
#>  8 whoami          1 gh_username                                          
#>  9 assertthat      2 assert_that, validate_that                           
#> 10 dplyr           3 filter, group_by, summarize                          
#> 11 httr            3 content, GET, http_error                             
#> 12 rstudioapi      3 isAvailable, openProject, getVersion                 
#> 13 igraph          4 degree, vertex_attr, graph_from_data_frame, set_vert~
#> 14 usethis         5 create_project, use_template, use_git_hook, proj_get~
#> 15 git2r           6 clone, init, status, add, commit, discover_repository
```

``` r
# `kable()` lets you see al functions even if they don't fit in a single line.
knitr::kable(n_deps)
```

| package     | n | functions                                                                   |
| :---------- | -: | :-------------------------------------------------------------------------- |
| assertthat  | 2 | assert\_that, validate\_that                                                |
| base64enc   | 1 | base64decode                                                                |
| devtools    | 1 | as.package                                                                  |
| dplyr       | 3 | filter, group\_by, summarize                                                |
| functionMap | 1 | map\_r\_package                                                             |
| gh          | 1 | gh                                                                          |
| git2r       | 6 | clone, init, status, add, commit, discover\_repository                      |
| httr        | 3 | content, GET, http\_error                                                   |
| igraph      | 4 | degree, vertex\_attr, graph\_from\_data\_frame, set\_vertex\_attr           |
| magrittr    | 1 | %\>%                                                                        |
| rmarkdown   | 1 | render                                                                      |
| rstudioapi  | 3 | isAvailable, openProject, getVersion                                        |
| tidyr       | 1 | separate                                                                    |
| usethis     | 5 | create\_project, use\_template, use\_git\_hook, proj\_get, use\_git\_ignore |
| whoami      | 1 | gh\_username                                                                |
