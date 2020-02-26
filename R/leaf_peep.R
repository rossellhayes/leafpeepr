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
  .proportion <- rlang::sym(".proportion")
  data        <- rlang::sym("data")

  if (is_not_null(weight_col))
    weight_col <- rlang::sym(rlang::as_name(rlang::enquo(weight_col)))

  if (is.null(weight_col)) {
    weight_col <- rlang::sym(".weight")
    tbl        <- dplyr::mutate(tbl, .weight = 1)
  }

  weight_sum <- dplyr::summarize(tbl, sum({{weight_col}}, na.rm = TRUE))[[1, 1]]

  tbl %>%
    dplyr::mutate_at(
      dplyr::vars(-{{weight_col}}),
      ~ tidyr::replace_na(as.character(.), "NA")
    ) %>%
    dplyr::group_by_at(dplyr::vars(-{{weight_col}})) %>%
    dplyr::summarize(.proportion = sum({{weight_col}}) / weight_sum) %>%
    dplyr::ungroup() %>%
    dplyr::summarize_at(
      dplyr::vars(dplyr::everything(), -.proportion),
      ~ list(autumn::weighted_pct(., .proportion))
    ) %>%
    tidyr::pivot_longer(
      dplyr::everything(), names_to = "variable", values_to = "data"
    ) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      data = list(dplyr::tibble(level = names(data), proportion = data))
    ) %>%
    tidyr::unnest(data)
}
