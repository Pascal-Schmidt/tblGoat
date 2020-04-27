#' Title
#'
#' @param df
#' @param grouping_var
#' @param digit
#' @param total
#' @param header
#' @param kabel
#'
#' @return
#' @export
#'
#' @examples
tbl_goat <- function(df, grouping_var = NULL, digit = 2, p_value = TRUE,
                     total = TRUE, header = TRUE, kable = TRUE) {

  options(warn=-1)
  if (length(grouping_var) == 0) {
    categorical_tbl(df = df) %>%
      dplyr::rename(
        "Characteristic" = name,
        "Overall" = count
      ) -> cat

    continuous_tbl(df = df) %>%
      dplyr::rename(
        "Characteristic" = name,
        "Overall" = Total
      ) -> cont

    # remove rows where there are zero missing values
    cont[which(pull(cont[, 1]) == "&nbsp;&nbsp;&nbsp;Missing"), -1] %>%
      dplyr::select(-contains(c("Total", "p-value"))) %>%
      dplyr::mutate_all(as.integer) %>%
      purrr::pmap(~c(...)) %>%
      purrr::map(~ unname(.)) %>%
      purrr::map(~sum(.)) %>%
      purrr::set_names(which(pull(cont[, 1]) == "&nbsp;&nbsp;&nbsp;Missing")) %>%
      purrr::keep(~ .x == 0) %>%
      names() %>%
      as.integer() -> remove_missings_0

    if(length(remove_missings_0) > 0) {

      cont <- cont[-remove_missings_0, ]

    }

    cont %>%
      dplyr::bind_rows(cat) %>%
      purrr::when(
        kable ~ knitr::kable(.),
        ~.
      ) -> tbl_overall

    return(tbl_overall)
  } else {
    cat <- categorical_tbl(
      df = df, grouping_var = grouping_var, total = total,
      header = header, p_value = p_value
    )
    cont <- continuous_tbl(
      df = df, grouping_var = grouping_var, digit = digit,
      total = total, header = header, p_value = p_value
    )

    # remove rows where there are zero missing values
    cont[which(pull(cont[, 1]) == "&nbsp;&nbsp;&nbsp;Missing"), -1] %>%
      dplyr::select(-contains(c("Total", "p-value"))) %>%
      dplyr::mutate_all(as.integer) %>%
      purrr::pmap(~c(...)) %>%
      purrr::map(~ unname(.)) %>%
      purrr::map(~sum(.)) %>%
      purrr::set_names(which(pull(cont[, 1]) == "&nbsp;&nbsp;&nbsp;Missing")) %>%
      purrr::keep(~ .x == 0) %>%
      names() %>%
      as.integer() -> remove_missings_0

    if(length(remove_missings_0) > 0) {

      cont <- cont[-remove_missings_0, ]

    }

    cat %>%
      dplyr::bind_rows(cont) %>%
      purrr::when(
        kable ~ knitr::kable(.),
        ~.
      ) -> tbl_stratified

    return(tbl_stratified)
  }
}
# tbl_goat(df = gapminder, grouping_var = c("continent", "x"), header = T, total = T, kabel = F)
