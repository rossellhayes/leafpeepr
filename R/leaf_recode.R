#' Recode columns of a data frame
#'
#' `leaf_recode()` recodes values in a column of a data frame by joining with a
#' data frame of recoded values. `leaf_recode_all()` recodes all columns that
#' have matching coumn names between both data frames.
#'
#' @param tbl Data frame to modify
#' @param code_tbl A data frame containing a column of codes and a column of
#'     replacment values with the same name as `col`
#' @param col The column to recode
#' @param code_col The column of `code_tbl` containing the codes present in
#'     `tbl`
#'
#' @return A data frame with selected columns recoded
#'
#' @seealso [dplyr::case_when()] to recode data using formulas
#'
#' @importFrom rlang %||%
#'
#' @export
#'
#' @example examples/leaf_recode.R

leaf_recode <- function(tbl, code_tbl) {
  if (ncol(code_tbl) %% 2 == 0) {
    if (!any(names(code_tbl) %in% names(tbl)))
      glubort("`leaf_recode()` can only use a wide `code_tbl` if its column",
              "names match `tbl`.")
    code_tbl <- pivot_code_tbl_longer(code_tbl, tbl)
  } else if (ncol(code_tbl) != 3) {
    glubort("Invalid `code_tbl`: code_tbl must have either three columns,",
            "or two columns for each recoding.")
  }

  code_list <- split(code_tbl, code_tbl$variable) %>%
    purrr::map(~ dplyr::select(., -variable))

  decoded_cols <- code_list %>%
    purrr::map2_dfc(
      .,
      names(.),
      ~ leaf_recode_internal(tbl = tbl, code_tbl = .x, col = .y)
    )

  purrr::map_dfc(
    names(tbl),
    function(col) {
      if (col %in% names(decoded_cols)) decoded_cols[col]
      else tbl[col]
    }
  )
}

leaf_recode_internal <- function(tbl, code_tbl, col) {
  if (length(code_tbl) != 2)
    glubort("`code_tbl` must have two columns.",
            "You might want `leaf_recode_all()`.")

  if (all(grepl("^~", code_tbl[["code"]]))) {
    result <- code_tbl %>%
      dplyr::transmute(
        .formula = gsub("\\.", col, code) %>%
          gsub("~\\s?", "", .) %>%
          paste0(' ~ "', value, '"'
        )
      ) %>%
      dplyr::pull(.formula) %>%
      paste(collapse = ", ") %>%
      paste0("dplyr::mutate(tbl, ", col, " = dplyr::case_when(", ., "))") %>%
      {eval(parse(text = .))} %>%
      dplyr::select_at(col)

    return(result)
  }

  col <- rlang::sym(col)

  code_tbl <- code_tbl %>%
    dplyr::rename(".code" = "code", {{col}} := "value") %>%
    dplyr::mutate_all(as.character)

  result <- tbl %>%
    dplyr::mutate_all(as.character) %>%
    dplyr::rename(".code" = {{col}}) %>%
    dplyr::left_join(code_tbl, by = ".code") %>%
    dplyr::select({{col}})

  result
}

pivot_code_tbl_longer <- function(code_tbl, tbl) {
  lapply(
    seq(from = 2, to = ncol(code_tbl), by = 2),
    function(i) code_tbl[(i - 1):i]
  ) %>%
    `names<-`(purrr::map_chr(., ~ names(.)[names(.) %in% names(tbl)])) %>%
    purrr::map(
      ~ `names<-`(., c("code", "value")) %>%
        dplyr::mutate_all(as.character) %>%
        janitor::remove_empty("rows")
    ) %>%
    dplyr::bind_rows(.id = "variable")
}
