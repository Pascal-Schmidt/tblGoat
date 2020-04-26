#' Title
#'
#' @param df
#'
#' @return
#'
#' @examples
identify_cat <- function(df) {

  df %>%
    purrr::map_dfr(~ (is.factor(.) | is.character(.))) %>%
    purrr::pmap(~c(...)) %>%
    purrr::flatten_lgl() %>%
    unname() %>%
    df[, .] -> df

  return(df)

}

library(gapminder)
library(tidyverse)
library(arsenal)

median_gdp <- median(gapminder$gdpPercap)
gapminder %>%
  select(-country) %>%
  mutate(gdpPercap = ifelse(gdpPercap > median_gdp, "high", "low")) %>%
  mutate(gdpPercap = factor(gdpPercap)) %>%
  mutate(pop = pop / 1000000) -> gapminder

gapminder <- lapply(gapminder, function(x) x[sample(c(TRUE, NA),
                                                    prob = c(0.9, 0.1),
                                                    size = length(x),
                                                    replace = TRUE
)])

gapminder <- as_tibble(gapminder)

library(arsenal)
gapminder %>%
  dplyr::mutate(x = sample(c("a", "b", NA), nrow(.), replace = TRUE),
                y = sample(c("e", "f", "g"), nrow(.), replace = TRUE)) -> gapminder

gapminder %>%
  dplyr::filter(continent == "Asia") -> gapminder
