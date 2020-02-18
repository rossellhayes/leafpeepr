leaf_peep <- function(data, weight_col = NULL) {
  if (isTRUE(try(is.character(weight_col), silent = TRUE))) {
    weight_col <- sym(weight_col)
  }

  weight_sum <- dplyr::summarize(
    data, sum({{weight_col}}, na.rm = TRUE)
  )[[1, 1]]

  data %>%
    dplyr::mutate_at(
      dplyr::vars(-{{weight_col}}),
      ~ tidyr::replace_na(as.character(.), "NA")
    ) %>%
    dplyr::group_by_at(dplyr::vars(-{{weight_col}})) %>%
    dplyr::summarize(.proportion = sum({{weight_col}}) / weight_sum) %>%
    dplyr::ungroup() %>%
    dplyr::summarize_at(
      dplyr::vars(everything(), -.proportion),
      ~ list(autumn::weighted_pct(., .proportion))
    ) %>%
    tidyr::pivot_longer(
      everything(), names_to = "variable", values_to = "data"
    ) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      data = list(dplyr::tibble(level = names(data), proportion = data))
    ) %>%
    tidyr::unnest(data)
}
