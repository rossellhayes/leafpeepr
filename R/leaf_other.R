#' Consolidate levels into other category
#'
#' @param tbl A data frame with three columns -- `variable`, `level`, and
#'   `proportion`, as created by `leaf_peep()`
#' @param cutoff The proportion below which levels will be turned to other
#' @param other A string indicating the name to be used for the other category,
#'     defaults to "Other"
#' @param inclusive If TRUE, when a variable's other category is still below the
#'     cutoff, the next smallest level will also be converted to other.
#'     If FALSE, the other category may remain below the cutoff
#'
#' @return A data frame where levels with proportions below the cutoff are
#'     consolidated into an "other" category
#' @export
#'
#' @example examples/leaf_other.R

leaf_other <- function(tbl, cutoff, other = "Other", inclusive = TRUE) {
  variable   <- rlang::sym("variable")
  proportion <- rlang::sym("proportion")
  .cumsum    <- rlang::sym(".cumsum")
  .lagsum    <- rlang::sym(".lagsum")
  level      <- rlang::sym("level")
  .is_other  <- rlang::sym(".is_other")

  if (is.na(other)) other <- NA_character_

  result <- tbl %>%
    dplyr::mutate(.row  = dplyr::row_number()) %>%
    dplyr::arrange(variable, proportion) %>%
    dplyr::group_by(variable)

  if (inclusive) {
    result <- result %>%
      dplyr::mutate(
        .cumsum = cumsum(proportion),
        .lagsum = dplyr::lag(.cumsum),
        .lagsum = dplyr::if_else(is.na(.lagsum), .cumsum, .lagsum),
        level   = dplyr::if_else(
          proportion < cutoff | .lagsum < cutoff,
          other,
          level
        )
      )
  } else {
    result <- result %>%
      dplyr::mutate(
        level = dplyr::if_else(proportion < cutoff, other, level)
      )
  }

  result %>%
    dplyr::group_by(variable, level) %>%
    dplyr::summarize(proportion = sum(proportion), .row = max(.row)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(.is_other = level == other) %>%
    dplyr::arrange(variable, .is_other, .row) %>%
    dplyr::select(-.row, -.is_other)
}
