#' Title
#'
#' @param df
#' @param df_mode
#' @param grouping_var
#' @param header
#' @param mode_tbl
#'
#' @return
#'
#' @examples
formatting <- function(df, df_mode, grouping_var, header = TRUE, mode_tbl) {
  df_mode %>%

    # make variabel name bold
    dplyr::mutate(name = ifelse(name %in% colnames(df),
      paste0("**", name, "**"),
      name
    )) -> df_mode

  if (header & length(grouping_var) > 0) {

    # add number of grouping variables in header
    df %>%
      dplyr::filter_at(vars(grouping_var), ~ !is.na(.)) %>%
      dplyr::count(!!!syms(grouping_var)) %>%
      dplyr::mutate(prop = paste0(round(n / sum(n), 4) * 100, "%")) %>%
      {
        dplyr::bind_rows(
          mutate_all(., as.character),
          purrr::set_names(dplyr::as_tibble(t(c(rep("Total", length(grouping_var)), sum(.$n), "100%"))), colnames(.))
        )
      } %>%
      tidyr::unite(col = "group", grouping_var, sep = "_") %>%

      # make sure no column switching
      .[match(dplyr::pull(., group)[order(match(dplyr::pull(., group), colnames(df_mode)))], .$group), ] %>%
      dplyr::mutate(
        group = ifelse(stringr::str_detect(group, "Total"), "Total", group),
        col_name = paste0(group, " N = ", n, " (", prop, ")")
      ) %>%
      dplyr::pull(col_name) -> table_names
  }

  # add sd, and quantiles to mean, median and indent
  df_mode %>%
    purrr::when(
      mode_tbl == "numeric" ~ dplyr::mutate(., name = ifelse(stringr::str_detect(name, "Mean"),
        paste0(name, " (sd)"),
        name
      )) %>%
        dplyr::mutate(., name = ifelse(stringr::str_detect(name, "Median"),
          paste0(name, " (Q1 - Q3)"),
          name
        )),
      ~.
    ) %>%
    dplyr::mutate(name = ifelse(stringr::str_detect(df_mode$name, "\\*"),
      name,
      paste0(strrep("&nbsp;", 3), name)
    )) -> formatted_tbl

  if (length(grouping_var) > 0) {
    formatted_tbl %>%
      purrr::when(
        header ~ purrr::set_names(., c("&nbsp;", table_names)),
        ~ purrr::set_names(., c("&nbsp;", colnames(.)[-1]))
      ) -> formatted_tbl
  }

  return(formatted_tbl)
}
