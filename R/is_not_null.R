is_not_null <- function(input) {
  !isTRUE(try(is.null(input), silent = TRUE))
}
