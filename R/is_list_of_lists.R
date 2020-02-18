#' Test if an input is a list of lists
#'
#' Description
#'
#' @param ... Character vectors of two or more columns names to interact,
#'     optionally in a list
#' @inheritParams leaf_interact
#'
#' @return A logical value
#'
#' @seealso [is.list()] to test if an input is a list
#'
#'     [purrr::flatten()] to remove a level of hierarchy from a list
#'
#'     [purrr::squash()] to remove all levels of hierarchy from a list
#'
#' @export

is_list_of_lists <- function (list) {
  if (!is.list(list)) {
    rlang::warn(
      message = paste0("Input `", deparse(substitute(list)), "` is not a list.")
    )
    return(FALSE)
  }

  all(purrr::map_lgl(list, is.list))
}
