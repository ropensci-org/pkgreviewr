#!/bin/bash
index=($(git diff --cached --name-only | grep 'index\.'))
MSG="use 'git commit --no-verify' to override this check"

if [[ ${#index[@]} == 0 ]]; then
  exit 0
fi

if [[ index.Rmd -nt index.nb.html ]]; then
  echo -e "index.nb.html is out of date; please render index.Rmd\n$MSG"
  exit 1
elif [[ ${#index[@]} -lt 2 ]]; then
  echo -e "index.Rmd and index.nb.html should be both staged\n$MSG"
  exit 1
fi
