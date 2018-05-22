
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Example

``` r
library(pkgreviewr)
```

Review dependency usage: Count used functions from external packages.

``` r
n_deps <- rev_dependency_usage()

# You may want to remove dependency on packages from which you use few functions
dplyr::arrange(n_deps, n)
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
#> 10 igraph          2 degree, graph_from_data_frame                        
#> 11 dplyr           3 filter, group_by, summarize                          
#> 12 httr            3 content, GET, http_error                             
#> 13 rstudioapi      3 isAvailable, openProject, getVersion                 
#> 14 usethis         5 create_project, use_template, use_git_hook, proj_get~
#> 15 git2r           6 clone, init, status, add, commit, discover_repository
```
