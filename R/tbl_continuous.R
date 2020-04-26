#' Title
#'
#' @param df
#' @param grouping_var
#' @param digit
#' @param total
#' @param header
#'
#' @return
#' @importFrom magrittr %>%
#' @importFrom dplyr vars
#' @examples
continuous_tbl <- function(df, grouping_var = NULL, digit = 2,
                           total = TRUE, header = TRUE, modification = "",
                           p_value = TRUE) {
  df %>%
    # when we want overall summary table
    purrr::when(
      length(grouping_var) == 0 & base::nchar(modification) == 0 ~ .,

      # when we want to add total to the end of table
      base::nchar(modification)[1] > 0 ~ dplyr::filter_at(., vars(modification), ~ !is.na(.)),

      # if grouping variable is not NULL, we remove missing grouping values
      ~ dplyr::filter_at(., vars(grouping_var), ~ !is.na(.)) %>%
        dplyr::group_by_at(., vars(grouping_var))
    ) %>%

    # summary functions applied
    dplyr::summarise_if(is.numeric, list(
      a_Mean = ~ paste0(
        round(mean(., na.rm = TRUE), digit), " (",
        round(sd(., na.rm = TRUE), digit), ")"
      ),
      b_Median = ~ paste0(
        round(median(., na.rm = TRUE), digit), " (",
        round(quantile(., 0.25, na.rm = TRUE), digit), " - ",
        round(quantile(., 0.75, na.rm = TRUE), digit), ")"
      ),
      c_Range = ~ paste0(round(range(., na.rm = TRUE), digit), collapse = " - "),
      d_Missing = ~ sum(is.na(.))
    ), na.rm = TRUE) %>%

    # coerce every column to character in order to perform pivoting
    dplyr::mutate_all(as.character) %>%

    # make data frame longer
    purrr::when(
      length(grouping_var) == 0 ~ # add ID for pivoting
      dplyr::mutate(., ID = row_number()) %>%
        tidyr::pivot_longer(-ID, values_to = "Total"),
      ~ tidyr::pivot_longer(., -grouping_var)
    ) %>%

    # arange by grouping variable and name (statistic)
    dplyr::arrange_at(c(grouping_var, "name")) %>%

    # turn grouping variables into columns
    purrr::when(
      length(grouping_var) == 0 ~ .,
      ~ tidyr::pivot_wider(., names_from = grouping_var, values_from = value)
    ) %>%
    dplyr::ungroup() %>%

    # remove previous column names for rows except for rows where Mean appears
    dplyr::mutate(
      name = stringr::str_remove_all(name, ".*_[a-z]_(?!Mean)"),
      name = stringr::str_remove_all(name, "_a")
    ) %>%

    # put variable name on separate line
    tidyr::separate_rows(name) %>%
    purrr::when(
      length(grouping_var) == 0 ~ dplyr::mutate(., Total = ifelse(!name %in% colnames(df),
        as.character(Total),
        ""
      )) %>%
        dplyr::select(-ID),
      # remove everything in variable row except variable itself
      ~ dplyr::mutate_at(
        ., vars(colnames(.)[-1]),
        ~ ifelse(name %in% colnames(df),
          "",
          as.character(.)
        )
      )
    ) -> cont


  if (length(grouping_var) > 0) {
    if (p_values_cont(df, grouping_var)[[1]][1] == "Stop") {
      cont %>%
        dplyr::mutate(Total = dplyr::pull(., 2)) -> cont
    } else {
      cont %>%
        dplyr::bind_cols(continuous_tbl(df = df, grouping_var = NULL, modification = grouping_var) %>%
          dplyr::select(-name)) -> cont
    }
  }

  cont <- formatting(df = df, df_mode = cont, grouping_var, header, mode_tbl = "numeric") %>%
    purrr::when(
      total ~ .,
      ~ dplyr::select(., -dplyr::contains("Total"))
    )

  if (length(grouping_var) > 0 &
    p_values_cont(df, grouping_var)[[1]][1] != "Stop" &
    p_value) {
    df_p_values <- p_values_cont(df, grouping_var)

    match(df_p_values$variable, stringr::str_remove_all(cont$`&nbsp;`, "\\*")) %>%
      {
        dplyr::bind_cols(df_p_values, data.frame("Order" = .))
      } %>%
      dplyr::arrange(Order) -> df_p_values

    cont %>%
      dplyr::mutate(`p-values` = "") -> cont
    cont[df_p_values$Order, "p-values"] <- df_p_values$`p-value`
  }

  return(cont)
}
# df <- gapminder %>%
#   dplyr::filter(continent == "Asia")
# grouping_var <- c("continent", "x")
# header <- T
# total = F
# digit = 2
# modification = ""
# p_value <- TRUE
#
# continuous_tbl(gapminder)
