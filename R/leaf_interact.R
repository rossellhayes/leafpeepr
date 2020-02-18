#' Create an interaction column
#'
#' Description
#'
#' @param tbl A data frame
#' @param ... Two or more column names to interact, optionally in a character
#'     vector
#' @param cols A character vector of two or more column names
#' @param sep A string indicating the separator to place between values in
#'     observations. Defaults to " x "
#' @param col_sep A string indicating the separator to place between column
#'     names. Defaults to `sep` with spaces replaced by underscores
#'
#' @return A modified `tbl` with an interaction column added
#'
#' @seealso [leaf_interactions()] to create multiple interactions at once
#'
#' @export

leaf_interact <- function(tbl, ..., cols, sep = " x ", col_sep = NULL) {
  if (missing(cols)) {
    col_names <- deparse_ellipsis(...)
    cols      <- rlang::enquos(...)
  } else {
    col_names <- cols
    cols      <- rlang::syms(cols)
  }

  if (is.null(col_sep)) {
    col_sep <- gsub("\\s", "_", sep)
  }

  new_col <- purrr::reduce(col_names, paste, sep = col_sep)

  dplyr::mutate(
    tbl,
    {{new_col}} := paste(!!!cols, sep = sep)
  )
}

#' Create interaction columns
#'
#' Description
#'
#' @param ... Character vectors of two or more columns names to interact,
#'     optionally in a list
#' @inheritParams leaf_interact
#'
#' @return A modified `tbl` with an interaction column added
#'
#' @seealso [leaf_interact()] to create interactions one at a time
#'
#' @export

leaf_interactions <- function(tbl, ..., sep = " x ", col_sep = NULL) {
  col_list <- list(...)

  if(is_list_of_lists(col_list)) {
    col_list <- purrr::flatten(col_list)
  }

  internal_interact <- function(tbl, cols) {
    leaf_interact(tbl = tbl, cols = cols, sep = sep, col_sep = col_sep)
  }

  col_list[[1]] <- internal_interact(tbl = tbl, cols = col_list[[1]])

  purrr::reduce(col_list, internal_interact)
}
