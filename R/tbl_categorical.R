#' Title
#'
#' @param df
#' @param grouping_var
#' @param header
#' @param total
#'
#' @return
#'
#' @examples
categorical_tbl <- function(df, grouping_var = NULL,
                            header = TRUE, total = TRUE, p_value = TRUE) {

  # extract factor and character variables from data frame
  df <- identify_cat(df)

  df %>%
    purrr::when(length(grouping_var) == 0 ~ .,

                # if grouping variable is not NULL, we remove missing
                # values for the specified groups
                ~ dplyr::filter_at(., vars(grouping_var), ~!is.na(.))) %>%


    # turn NA into character "Missing" and turn columns into character
    # put z_Missing so Missing will be the last row for the categorical variable
    dplyr::mutate_all(.funs = ~ ifelse(is.na(.), "z_Missing", as.character(.))) %>%

    # pivot to longer format
    tidyr::pivot_longer(-grouping_var) %>%

    # count values for grouping variable + column variables + levels
    dplyr::group_by_all() %>%
    dplyr::summarise(n = dplyr::n()) %>%
    dplyr::group_by_at(c(grouping_var, "name")) %>%
    dplyr::mutate(value = str_remove_all(value, "^z_")) %>%

    purrr::when(length(grouping_var) == 0 ~ .,

                # group by name + value (previously columns + levels of columns)
                # in order to get a total
                ~ dplyr::bind_rows(., dplyr::group_by(., name, value) %>%
                                     dplyr::summarise(n = sum(n)))) %>%

    # calculate proportions
    dplyr::mutate(prop = ifelse(value != "Missing",
                                paste0("(", round(n / sum(n[value != "Missing"]), 4) * 100, "%)"),
                                "")) %>%
    tidyr::unite("count", n, prop, sep = " ") %>%

    purrr::when(length(grouping_var) == 0 ~ .,

                # turn grouping_var levels into columns
                ~ tidyr::pivot_wider(., names_from = grouping_var, values_from = count) %>%
                  purrr::set_names(c(colnames(.)[-length(.)], "Total"))) %>%
    dplyr::ungroup() %>%
    tidyr::unite("variable", name, value, sep = "_") %>%
    tidyr::separate_rows(variable) %>%

    # only keeps unique values (the first one) in the variable column and removes all
    # rows where there occurs a duplicate value in the variable column
    # the exception is missing, which will be included in the table regardless of how many times it occurs
    .[sort(c(which(.$variable == "Missing"), match(unique(.$variable[.$variable != "Missing"]), .$variable))), ] %>%
    dplyr::mutate_all(~ ifelse(is.na(.), "No Data", .)) %>%

    # removes everything in the variable name row except for the variable name itself
    purrr::when(length(grouping_var) == 0 ~ dplyr::mutate(., count = ifelse(!variable %in% colnames(df),
                                                                            count,
                                                                            "")),
                ~ mutate_at(., vars(colnames(.)[-1]),
                            ~ ifelse(variable %in% colnames(df),
                                     "",
                                     as.character(.)))) %>%
    dplyr::rename("name" = variable) -> cat

  # some formatting (see formatting function)
  cat <- formatting(df = df, df_mode = cat, grouping_var, header, mode_tbl = "categorical") %>%
    purrr::when(total ~ .,
                # remove total if total = FALSE in function call
                ~ dplyr::select(., -dplyr::contains("Total")))

  # only add p-values when we have a grouping variable,
  # the grouping variable has more than 1 category and
  # p_value = TRUE in function call
  if(length(grouping_var) > 0 &
     p_values_cat(df, grouping_var)[[1]][1] != "Stop" &
     p_value) {

    df_p_values <- p_values_cat(df, grouping_var)

    # makes sure we insert p-values in the right order
    match(df_p_values$variable, stringr::str_remove_all(cat$`&nbsp;`, "\\*")) %>%
    { dplyr::bind_cols(df_p_values, data.frame("Order" = .)) } %>%
      dplyr::arrange(Order) -> df_p_values

    cat %>%
      dplyr::mutate(`p-values` = "") -> cat
    cat[df_p_values$Order, "p-values"] <- df_p_values$`p-value`

  }

  return(cat)

}
df <- gapminder
grouping_var <- NULL
grouping_var <- c("continent", "x")
header <- T
total = F
digit = 2
p_value <- TRUE
categorical_tbl(gapminder)

grouping_var = c("x", "continent")
header = F
p_value = F
