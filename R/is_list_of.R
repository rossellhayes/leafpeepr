#' Test if an input is a list of something
#'
#' Tests if all elements of a list are a specific type. `is_list_of` accepts any
#' test function. `is_list_of_lists()` tests if all elements are lists.
#' `is_list_of_characters()` tests if all elements are character vectors.
#'
#' @param input List to test
#' @param test Test function to apply to each element of `input`. Either a
#'     function name, an anonymous function, or a purrr-style lambda function
#'
#' @return A logical value. If `input` is not a list, `FALSE` and a warning.
#'
#' @seealso [is.list()] to test if an input is a list
#'
#'   [purrr::flatten()] or [rlang::flatten()] to remove a level of hierarchy
#'   from a list
#'
#'   [rlang::squash()] to remove all levels of hierarchy from a list
#'
#' @export
#' @example examples/is_list_of.R

is_list_of <- function(input, test) {
  if (!is.list(input)) {
    rlang::warn("Input is not a list.")
    return(FALSE)
  }

  all(vapply(input, rlang::as_function(test), logical(1)))
}

#' @rdname is_list_of
#' @export

is_list_of_lists <- function(input) {
  is_list_of(input, is.list)
}

#' @rdname is_list_of
#' @export

is_list_of_characters <- function(input) {
  is_list_of(input, is.character)
}
