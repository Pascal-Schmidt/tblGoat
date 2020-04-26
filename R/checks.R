#' Title
#'
#' @param df
#' @param column
#'
#' @return
#'
#' @examples
test_levels <- function(df, column) {
  if (is.null(column)) {
    return("Stop")
  }

  # when there is only one category in the grouped by column, we do not calculate a p-value
  test_levels <- na.omit(unique(dplyr::pull(df[, column])))
  if (length(test_levels) < 2) {
    return("Stop")
  } else {
    return("continue")
  }
}
