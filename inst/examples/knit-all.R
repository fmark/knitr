#!/usr/bin/env Rscript

if (!nzchar(Sys.which('lyx')) || system('lyx -version') != 0L) q()

call_lyx = function(file) {
  res = sapply(sprintf('lyx -e %s %s', c('knitr', 'r', 'pdf2'), file), 
               system, USE.NAMES = FALSE)
  unlink(sub('\\.lyx$', '.R', file))
  stopifnot(identical(res, integer(3L)))
}

for (i in list.files(pattern = '\\.lyx$')) {
  message(i)
  call_lyx(i)
  flush.console()
}

for (i in list.files(pattern = '\\.R(tex|md|html|rst)')) {
  message(i)
  cmd = if (i == 'knitr-minimal.Rmd') {
    sprintf("Rscript -e 'library(knitr);opts_knit$set(base.url=\"https://github.com/yihui/knitr/raw/master/inst/examples/\");opts_chunk$set(fig.path=\"\");knit(\"%s\")'", i)
  } else {
    sprintf('knit %s', i)
  }
  stopifnot(identical(system(cmd), 0L))
  flush.console()
}

