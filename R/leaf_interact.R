#' Create an interaction column
#'
#' Description
#'
#' @param tbl A data frame
#' @param ... Two or more column names to interact, either unquoted names or a
#'     character vector
#' @param cols A character vector of two or more column names
#' @param sep A string indicating the separator to place between values in
#'     observations
#' @param col_sep A string indicating the separator to place between column
#'     names. If NULL, defaults to `sep` with spaces replaced by underscores
#'
#' @return A modified `tbl` with an interaction column added
#'
#' @seealso [leaf_interactions()] to create multiple interactions with one
#'   function
#'
#'   [leaf_interact_all()] to create interactions bewteen a column and all
#'   other columns
#'
#' @importFrom rlang :=
#'
#' @export

leaf_interact <- function(tbl, ..., cols = NULL, sep = " x ", col_sep = NULL) {
  if (is.null(cols)) {
    if (
      isTRUE(try(is.character(...), silent = TRUE)) ||
      isTRUE(try(is_list_of_characters(...), silent = TRUE))
    ) {
      col_names <- list(...)
      cols      <- rlang::syms(...)
    } else {
      col_names <- deparse_ellipsis(...)
      cols      <- rlang::enquos(...)
    }
  } else {
    col_names <- cols
    cols      <- rlang::syms(cols)
  }

  if (is.null(col_sep)) col_sep <- generate_col_sep(sep)

  new_col <- paste(c(col_names, recursive = TRUE), collapse = col_sep)

  dplyr::mutate(
    tbl,
    {{new_col}} := paste(!!!cols, sep = sep)
  )
}

#' Create an interaction column
#'
#' Description
#'
#' @param ... One or more column names to interact with all other columns,
#'     either unquoted names or a character vector
#' @param cols A string or character vector of one or more column names
#' @param except An unquote name or a character vector of one or more column
#'   names not to interact, e.g. a column of weights
#' @inheritParams leaf_interact
#'
#' @return A modified `tbl` with an interaction column added
#'
#' @seealso [leaf_interact()] to create interactions one at a time
#'
#'     [leaf_interactions()] to create multiple interactions at once
#'
#' @export

leaf_interact_all <- function(
  tbl, ..., cols = NULL, except = NULL, sep = " x ", col_sep = NULL
) {
  if (is.null(cols)) {
    if (
      isTRUE(try(is.character(...), silent = TRUE)) ||
      suppressWarnings(isTRUE(try(is_list_of_characters(...), silent = TRUE)))
    ) {
      cols <- list(...)
    } else {
      cols <- as.list(deparse_ellipsis(...))
    }
  }

  cols <- c(cols, recursive = TRUE)

  except <- rlang::as_name(rlang::enquo(except))

  if (is.null(col_sep)) col_sep <- generate_col_sep(sep)

  new_cols <- purrr::map_dfc(
    cols,
    function(column) {
      dplyr::select(tbl, -except, -cols[seq_len(which(cols == column) - 1)]) %>%
        dplyr::mutate_all(paste, rlang::sym(column), sep = sep) %>%
        dplyr::select(-cols[cols == column]) %>%
        dplyr::rename_all(paste, column, sep = col_sep)
    }
  )

  dplyr::bind_cols(tbl, new_cols)
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
#'     [leaf_interact_all()] to create interactions bewteen a column and all
#'     other columns
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
