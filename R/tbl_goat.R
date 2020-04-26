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
                     total = TRUE, header = TRUE, kabel = TRUE) {

  if(length(grouping_var) == 0) {

    categorical_tbl(df = df) %>%
      dplyr::rename("Characteristic" = name,
                    "Overall" = count) -> cat

    continuous_tbl(df = df) %>%
      dplyr::rename("Characteristic" = name,
                    "Overall" = Total) -> cont

    cont %>%
      dplyr::bind_rows(cat) %>%
      purrr::when(kabel ~ knitr::kable(.),
                  ~.) -> tbl_overall

    return(tbl_overall)

  } else {

    cat <- categorical_tbl(df = df, grouping_var = grouping_var, total = total,
                           header = header, p_value = p_value)
    cont <- continuous_tbl(df = df, grouping_var = grouping_var, digit = digit,
                           total = total, header = header, p_value = p_value)

    cat %>%
      dplyr::bind_rows(cont) %>%
      purrr::when(kabel ~ knitr::kable(.),
                  ~.) -> tbl_stratified

    return(tbl_stratified)

  }

}
# tbl_goat(df = gapminder, grouping_var = c("continent", "x"), header = T, total = T, kabel = F)
