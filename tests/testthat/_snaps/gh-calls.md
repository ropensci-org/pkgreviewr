# check-get_repo_meta

    Code
      get_repo_meta("annakrystalli/rdflib")
    Output
      $name
      [1] "rdflib"
      
      $owner
      [1] "annakrystalli"
      

---

    Code
      get_repo_meta("bogusrepo")
    Condition
      Error in `gh::gh()`:
      ! GitHub API error (404): Not Found
      x URL not found: <https://api.github.com/repos/bogusrepo>
      i Read more at <https://docs.github.com/rest>

