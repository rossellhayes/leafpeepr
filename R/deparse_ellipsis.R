deparse_ellipsis <- function(...) {
  lapply(substitute(list(...)), deparse)[-1]
}
