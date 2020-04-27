# tblGoat

## The GOAT among the Summary Statistics Package... 

This is a summary statistcis package that creates summary statistcis tables by groups and overall. 

```r
# install.packages("devtools")
devtools::install_github("Pascal-Schmidt/tblGoat")
library(tidyverse)
library(tblgoat)

mtcars %>%
  dplyr::mutate_at(vars("cyl", "am", "vs", "gear", "carb"), 
                   .funs = ~ as.factor(.)) %>%
  dplyr::as_tibble() -> mtcars
```

#### Overall Summary Statistics Table

To create an overall summary statistics table, we just have to pass in a data frame into the `tbl_goat` function. 

