#' Title
#'
#' @param df
#' @param grouping_var
#'
#' @return
#'
#' @examples
p_values_cont <- function(df, grouping_var) {

  # when there is more than one variable we want to group by, we first
  # unite these two columns and then calculate the p-values
  if (length(grouping_var) > 1) {
    df %>%
      dplyr::filter_at(vars(grouping_var), ~ !is.na(.)) %>%
      tidyr::unite(col = "grouped", grouping_var, sep = "_") -> df_grouped

    # when there is only one category in the grouped by column, we do not calculate a p-value
    if (test_levels(df_grouped, "grouped") == "Stop") {
      return("Stop")
    }

    # if there is more than one category in the grouped_var column, we will calculate a p-value
    df_grouped %>%
      dplyr::summarize_if(is.numeric, ~ list(kruskal.test(. ~ grouped))) %>%
      purrr::map_dfr(~ purrr::pluck(., 1, 3)) %>%
      dplyr::mutate(ID = dplyr::row_number()) %>%
      tidyr::pivot_longer(-ID, names_to = "variable", values_to = "p-value") %>%
      dplyr::mutate(
        `p-value` = round(`p-value`, 3),
        `p-value` = ifelse(`p-value` == 0.000, paste0("< 0.001"), `p-value`)
      ) -> p_vals

    return(p_vals)
  } else {

    # when there is only one column we want to stratify by and
    # when there is only one category in the grouped by column, we do not calculate a p-value
    if (test_levels(df, grouping_var) == "Stop") {
      return("Stop")
    }

    df %>%
      dplyr::summarize_if(is.numeric, ~ list(kruskal.test(. ~ !!sym(grouping_var)))) %>%
      purrr::map_dfr(~ purrr::pluck(., 1, 3)) %>%
      dplyr::mutate(ID = dplyr::row_number()) %>%
      tidyr::pivot_longer(-ID, names_to = "variable", values_to = "p-value") %>%
      dplyr::mutate(
        `p-value` = round(`p-value`, 3),
        `p-value` = ifelse(`p-value` == 0.000, paste0("< 0.001"), `p-value`)
      ) -> p_vals

    return(p_vals)
  }
}

#' Title
#'
#' @param df
#' @param grouping_var
#'
#' @return
#'
#' @examples
p_values_cat <- function(df, grouping_var) {
  df <- dplyr::mutate_all(df, as.character)

  if (length(grouping_var) == 1) {
    if (test_levels(df, grouping_var) == "Stop") {
      return("Stop")
    }

    # if grouping_var only includes one column
    df %>%
      dplyr::summarise_all(~ ifelse(
        length(na.omit(unique(.))) > 1,
        list(chisq.test(., dplyr::pull(df[, grouping_var]))),
        NA
      )) %>%
      dplyr::select(-grouping_var) %>%
      dplyr::select_if(is.list) %>%
      purrr::map_dfr(~ purrr::pluck(., 1, "p.value")) %>%
      dplyr::mutate(ID = dplyr::row_number()) %>%
      tidyr::pivot_longer(-ID, names_to = "variable", values_to = "p-value") %>%
      dplyr::mutate(
        `p-value` = round(`p-value`, 3),
        `p-value` = ifelse(`p-value` == 0.000, paste0("< 0.001"), `p-value`)
      ) -> p_vals

    return(p_vals)
  } else if (length(grouping_var) > 1) {

    # if grouping_var includes multiple columns
    df %>%
      dplyr::filter_at(vars(grouping_var), ~ !is.na(.)) %>%
      tidyr::unite(col = "grouped", grouping_var, sep = "_") -> df_grouped

    # when there is only one category in the grouped by column, we do not calculate a p-value
    if (test_levels(df_grouped, "grouped") == "Stop") {
      return("Stop")
    }

    df_grouped %>%
      dplyr::summarise_all(~ ifelse(
        length(na.omit(unique(.))) > 1,
        list(chisq.test(., dplyr::pull(df_grouped[, "grouped"]))),
        NA
      )) %>%
      dplyr::select(-grouped) %>%
      dplyr::select_if(is.list) %>%
      purrr::map_dfr(~ purrr::pluck(., 1, "p.value")) %>%
      dplyr::mutate(ID = dplyr::row_number()) %>%
      tidyr::pivot_longer(-ID, names_to = "variable", values_to = "p-value") %>%
      dplyr::mutate(
        `p-value` = round(`p-value`, 3),
        `p-value` = ifelse(`p-value` == 0.000, paste0("< 0.001"), `p-value`)
      ) -> p_vals

    return(p_vals)
  } else {
    return("Stop")
  }
}
