#' Convert a data frame to weighting targets
#'
#' @param tbl A data frame of individual observations, e.g. census microdata
#' @param weight_col A column of individual weights, as an unquoted name or
#'     character string
#'
#' @return A data frame of weighting targets
#' @export
#'
#' @example examples/leaf_peep.R

leaf_peep <- function(tbl, weight_col = NULL) {
  if (is_not_null(weight_col)) {
    weight_col <- rlang::as_name(rlang::enquo(weight_col))
  } else {
    weight_col <- ".weight"
    tbl        <- dplyr::mutate(tbl, ".weight" := 1)
  }

  weight_sum <- sum(tbl[[weight_col]], na.rm = TRUE)

  tbl %>%
    dplyr::mutate_at(
      dplyr::vars(-tidyselect::all_of(weight_col)),
      ~ tidyr::replace_na(as.character(.), "NA")
    ) %>%
    tidyr::pivot_longer(
      -weight_col, names_to = "variable", values_to = "level"
    ) %>%
    dplyr::group_by_at(dplyr::vars(-weight_col)) %>%
    dplyr::summarize(
      "proportion" := sum(!!rlang::sym(weight_col)) / weight_sum
    ) %>%
    dplyr::ungroup()
}
