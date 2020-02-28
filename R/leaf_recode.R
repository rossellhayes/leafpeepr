#' Recode columns of a data frame
#'
#' Recodes values in a data frame by joining with a data frame of recoded
#' values.
#'
#' @param tbl Data frame to modify
#' @param code_tbl A data frame of recoding values, either:
#'
#'   * A data frame with three columns, `variable`, `code`, and `value`.
#'     `variable` matches the column name to recode in `tbl`. `code` matches the
#'     encoded values in `tbl`. `value` contains the values that each code
#'     should be replaced with. (For example, see `leafpeepr::acs_codes_long`.)
#'
#'   * A data frame with two adjacent columns for each column to be recoded in
#'     `tbl`. One column contains encoded values and can have any name. The
#'     other contains recoded values and has the same name as the column to
#'     recode in `tbl`. (For example, see `leafpeepr::acs_codes`.)
#'
#'   Each code column can contain either literal codes or one-sided formulas.
#'   (For example, compare `leafpeepr::acs_race_codes` and
#'   `leafpeepr::acs_age_codes`.)
#'
#' @return A data frame with selected columns recoded
#'
#' @seealso [dplyr::case_when()] to recode data using formulas
#'
#' @importFrom rlang :=
#'
#' @export
#'
#' @example examples/leaf_recode.R

leaf_recode <- function(tbl, code_tbl) {
  if (ncol(code_tbl) %% 2 == 0) {
    if (!any(names(code_tbl) %in% names(tbl))) {
      glubort("`leaf_recode()` can only use a wide `code_tbl` if its column",
              "names match `tbl`.")
    }
    code_tbl <- pivot_code_tbl_longer(code_tbl, tbl)
  } else if (ncol(code_tbl) != 3) {
    glubort("Invalid `code_tbl`: code_tbl must have either three columns",
            "or two columns for each variable in `tbl` to recode.")
  }

  code_list <- code_tbl %>%
    split(code_tbl$variable) %>%
    purrr::map(dplyr::select_at, dplyr::vars(-"variable"))

  decoded_cols <- purrr::map2_dfc(
    code_list, names(code_list),
    ~ leaf_recode_internal(tbl = tbl, code_tbl = .x, col = .y)
  ) %>%
    dplyr::mutate_all(readr::parse_guess)

  purrr::map_dfc(
    names(tbl),
    function(col) {
      if (col %in% names(decoded_cols)) decoded_cols[col]
      else tbl[col]
    }
  )
}

leaf_recode_internal <- function(tbl, code_tbl, col) {
  code    <- rlang::sym("code")
  value   <- rlang::sym("value")

  formulas <- code_tbl %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      code = stringr::str_squish(code),
      code = dplyr::if_else(
        stringr::str_detect(code, "^~"),
        code %>%
          stringr::str_replace("\\.", col) %>%
          stringr::str_replace("^~\\s?", "") %>%
          stringr::str_squish(),
        unclass(glue::glue('{col} == "{code}"'))
      ),
      "formula" := unclass(glue::glue('{code} ~ "{value}"'))
    ) %>%
    dplyr::pull("formula") %>%
    glue::glue_collapse(sep = ", ")

  glue::glue("dplyr::transmute(tbl, {col} = dplyr::case_when({formulas}))") %>%
    rlang::parse_expr() %>%
    rlang::eval_tidy()
}

pivot_code_tbl_longer <- function(code_tbl, tbl) {
  code_list <- seq(from = 2, to = ncol(code_tbl), by = 2) %>%
    purrr::map(function(i) code_tbl[(i - 1):i])

  names(code_list) <- purrr::map_chr(
    code_list,
    ~ names(.)[names(.) %in% names(tbl)]
  )

  code_list %>%
    purrr::map(
      function(code_tbl) {
        names(code_tbl)[which(!names(code_tbl) %in% names(tbl))] <- "code"
        names(code_tbl)[which(names(code_tbl) %in% names(tbl))] <- "value"
        code_tbl
      }
    ) %>%
    purrr::map(dplyr::mutate_all, as.character) %>%
    purrr::map_dfr(janitor::remove_empty, "rows", .id = "variable")
}
