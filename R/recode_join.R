##' Recode a column of a data frame by joining with a data frame of values
##'
##' @param tbl Data frame to modify
##' @param col The column to recode
##' @param code_tbl A data frame containing a column of codes and a column of
##'     replacment values with the same name as `col`
##' @param code_col The column of `code_tbl` containing the codes present in
##'     `tbl`
##'
##' @return A data frame with a selected column recoded
##' @importFrom magrittr %>%
##' @export
##' @examples
##' raw_data <- tibble(race = runif(1000, 1, 4), answer = runif(1000, 1, 4)) %>%
##'   mutate_all(round)
##'
##' race_codes <- tribble(
##'   ~ code, ~ race,
##'   1, "AAPI",
##'   2, "Black",
##'   3, "Latinx",
##'   4, "White"
##' )
##'
##' answer_codes <- tribble(
##'   ~ code, ~ answer,
##'   1, "Agree",
##'   2, "Disagree",
##'   3, "No opinion",
##'   4, "Not sure"
##' )
##'
##' raw_data %>%
##'   recode_join(race, race_codes, code) %>%
##'   recode_join(answer, answer_codes, code)

recode_join <- function(tbl, col, code_tbl, code_col = code) {
  col_name      <- deparse(substitute(col))
  code_col_name <- deparse(substitute(code_col))

  code_tbl <- dplyr::select(code_tbl, {{col}}, {{code_col}}) %>%
    dplyr::rename_at(code_col_name, function(...) ".code")

  replacement <- tbl %>%
    dplyr::rename_at(col_name, function(...) ".code") %>%
    dplyr::left_join(code_tbl, by = ".code") %>%
    dplyr::select({{col}})

  tbl[which(names(data_tbl) == col_name)] <- replacement

  tbl
}
