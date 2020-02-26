glubort <- function(...) {
  rlang::abort(message = paste(...))
}

glubort0 <- function(...) {
  rlang::abort(message = paste0(...))
}
