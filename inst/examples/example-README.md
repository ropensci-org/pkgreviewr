---
output: github_document
---


# `rdflib` - package review repository

##

This repo contains files associated with the **rOpenSci** review of

### **`rdflib`: ropensci/onboarding**  issue [\#169](https://github.com/ropensci/onboarding/issues/169).

<br>


***

## **Reviewer:** [\@annakrystalli](https://github.com/annakrystalli)
### Review Submitted:
**`r cat(sprintf("**Last updated:** %s", Sys.Date()))`**

<br>

### see the review report [here:](https://annakrystalli.github.io/rdflib-review/index.nb.html)

or view the submiited review to rOpenSci [here:](https://github.com/annakrystalli/rdflib-review/blob/master/pkgreview.md)

<br>


## Package info

**Description:**

The Resource Description Framework, or 'RDF' is a widely used
             data representation model that forms the cornerstone of the 
             Semantic Web. 'RDF' represents data as a graph rather than 
             the familiar data table or rectangle of relational databases.
             The 'rdflib' package provides a friendly and concise user interface
             for performing common tasks on 'RDF' data, such as reading, writing
             and converting between the various serializations of 'RDF' data,
             including 'rdfxml', 'turtle', 'nquads', 'ntriples', and 'json-ld';
             creating new 'RDF' graphs, and performing graph queries using 'SPARQL'.
             This package wraps the low level 'redland' R package which
             provides direct bindings to the 'redland' C library.  Additionally,
             the package supports the newer and more developer friendly
             'JSON-LD' format through the 'jsonld' package. The package
             interface takes inspiration from the Python 'rdflib' library.

**Author:** `r person("Carl", "Boettiger", 
                  email = "cboettig@gmail.com", 
                  role = c("aut", "cre", "cph"),
                  comment=c(ORCID = "0000-0002-1642-628X"))`

**repo url:** <https://github.com/cboettig/rdflib>

**website url:** <https://cboettig.github.io/rdflib/>
