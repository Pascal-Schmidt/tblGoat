# tblGoat

This is my first attempt at writing an R package. During my time at the BC Cancer Agency, I researched a lot of summary statistics packages online. Many of these packages produced beautiful tables but were not very flexible when it came to handling `NA` values for example. For this package, I wrote code which produces summary statistics tables that represents the data best in my opinion. The `tblgoat` package can produce overall summary statistics tables and can also produce tables by groups.  

One thing to note for this package is that it transforms `factors` into `character` variables. Hence, if there are certain categories in the data set that have no values, they won't be represented in the table as count 0 (0%). They will just be left out. Something to be aware of.

Also, this package can return `tibbles` if you specify `kable = FALSE` in the `tbl_goat` function. This is made available if you want to further work with a data frame rather than just getting the markdown format with `kable()`. 

If you want to use more flexible and very sophisticated summary statistics packages, I would recommend using the [arsenal](https://cran.r-project.org/web/packages/arsenal/vignettes/tableby.html) package or the [gtsummary](https://cran.r-project.org/web/packages/gtsummary/vignettes/gallery.html) package. Both are available on CRAN. 

## Mini Vignette

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

### Overall Summary Statistics Table

```r
tblgoat::tbl_goat(mtcars)
```


To create an overall summary statistics table, we just have to pass in a data frame into the `tbl_goat` function. 

|Characteristic                     |Overall              |
|:----------------------------------|:--------------------|
|**disp**                           |                     |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |230.72 (123.94)      |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |196.3 (120.83 - 326) |
|&nbsp;&nbsp;&nbsp;Range            |71.1 - 472           |
|**drat**                           |                     |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |3.6 (0.53)           |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |3.7 (3.08 - 3.92)    |
|&nbsp;&nbsp;&nbsp;Range            |2.76 - 4.93          |
|**hp**                             |                     |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |146.69 (68.56)       |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |123 (96.5 - 180)     |
|&nbsp;&nbsp;&nbsp;Range            |52 - 335             |
|**mpg**                            |                     |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |20.09 (6.03)         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |19.2 (15.43 - 22.8)  |
|&nbsp;&nbsp;&nbsp;Range            |10.4 - 33.9          |
|**qsec**                           |                     |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |17.85 (1.79)         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |17.71 (16.89 - 18.9) |
|&nbsp;&nbsp;&nbsp;Range            |14.5 - 22.9          |
|**wt**                             |                     |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |3.22 (0.98)          |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |3.33 (2.58 - 3.61)   |
|&nbsp;&nbsp;&nbsp;Range            |1.51 - 5.42          |
|**am**                             |                     |
|&nbsp;&nbsp;&nbsp;0                |19 (59.38%)          |
|&nbsp;&nbsp;&nbsp;1                |13 (40.62%)          |
|**carb**                           |                     |
|&nbsp;&nbsp;&nbsp;1                |7 (21.88%)           |
|&nbsp;&nbsp;&nbsp;2                |10 (31.25%)          |
|&nbsp;&nbsp;&nbsp;3                |3 (9.38%)            |
|&nbsp;&nbsp;&nbsp;4                |10 (31.25%)          |
|&nbsp;&nbsp;&nbsp;6                |1 (3.12%)            |
|&nbsp;&nbsp;&nbsp;8                |1 (3.12%)            |
|**cyl**                            |                     |
|&nbsp;&nbsp;&nbsp;4                |11 (34.38%)          |
|&nbsp;&nbsp;&nbsp;6                |7 (21.88%)           |
|&nbsp;&nbsp;&nbsp;8                |14 (43.75%)          |
|**gear**                           |                     |
|&nbsp;&nbsp;&nbsp;3                |15 (46.88%)          |
|&nbsp;&nbsp;&nbsp;4                |12 (37.5%)           |
|&nbsp;&nbsp;&nbsp;5                |5 (15.62%)           |
|**vs**                             |                     |
|&nbsp;&nbsp;&nbsp;0                |18 (56.25%)          |
|&nbsp;&nbsp;&nbsp;1                |14 (43.75%)          |


### Summary Statistics Tables By Group

```r
tblgoat::tbl_goat(mtcars, grouping_var = "am")
```

|&nbsp;                             |0 N = 19 (59.38%)     |1 N = 13 (40.62%)     |Total N = 32 (100%)  |p-values |
|:----------------------------------|:---------------------|:---------------------|:--------------------|:--------|
|**carb**                           |                      |                      |                     |0.284    |
|&nbsp;&nbsp;&nbsp;1                |3 (15.79%)            |4 (30.77%)            |7 (21.88%)           |         |
|&nbsp;&nbsp;&nbsp;2                |6 (31.58%)            |4 (30.77%)            |10 (31.25%)          |         |
|&nbsp;&nbsp;&nbsp;3                |3 (15.79%)            |No Data               |3 (9.38%)            |         |
|&nbsp;&nbsp;&nbsp;4                |7 (36.84%)            |3 (23.08%)            |10 (31.25%)          |         |
|&nbsp;&nbsp;&nbsp;6                |No Data               |1 (7.69%)             |1 (3.12%)            |         |
|&nbsp;&nbsp;&nbsp;8                |No Data               |1 (7.69%)             |1 (3.12%)            |         |
|**cyl**                            |                      |                      |                     |0.013    |
|&nbsp;&nbsp;&nbsp;4                |3 (15.79%)            |8 (61.54%)            |11 (34.38%)          |         |
|&nbsp;&nbsp;&nbsp;6                |4 (21.05%)            |3 (23.08%)            |7 (21.88%)           |         |
|&nbsp;&nbsp;&nbsp;8                |12 (63.16%)           |2 (15.38%)            |14 (43.75%)          |         |
|**gear**                           |                      |                      |                     |< 0.001  |
|&nbsp;&nbsp;&nbsp;3                |15 (78.95%)           |No Data               |15 (46.88%)          |         |
|&nbsp;&nbsp;&nbsp;4                |4 (21.05%)            |8 (61.54%)            |12 (37.5%)           |         |
|&nbsp;&nbsp;&nbsp;5                |No Data               |5 (38.46%)            |5 (15.62%)           |         |
|**vs**                             |                      |                      |                     |0.556    |
|&nbsp;&nbsp;&nbsp;0                |12 (63.16%)           |6 (46.15%)            |18 (56.25%)          |         |
|&nbsp;&nbsp;&nbsp;1                |7 (36.84%)            |7 (53.85%)            |14 (43.75%)          |         |
|**disp**                           |                      |                      |                     |0.001    |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |290.38 (110.17)       |143.53 (87.2)         |230.72 (123.94)      |         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |275.8 (196.3 - 360)   |120.3 (79 - 160)      |196.3 (120.83 - 326) |         |
|&nbsp;&nbsp;&nbsp;Range            |120.1 - 472           |71.1 - 351            |71.1 - 472           |         |
|**drat**                           |                      |                      |                     |< 0.001  |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |3.29 (0.39)           |4.05 (0.36)           |3.6 (0.53)           |         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |3.15 (3.07 - 3.7)     |4.08 (3.85 - 4.22)    |3.7 (3.08 - 3.92)    |         |
|&nbsp;&nbsp;&nbsp;Range            |2.76 - 3.92           |3.54 - 4.93           |2.76 - 4.93          |         |
|**hp**                             |                      |                      |                     |0.044    |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |160.26 (53.91)        |126.85 (84.06)        |146.69 (68.56)       |         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |175 (116.5 - 192.5)   |109 (66 - 113)        |123 (96.5 - 180)     |         |
|&nbsp;&nbsp;&nbsp;Range            |62 - 245              |52 - 335              |52 - 335             |         |
|**mpg**                            |                      |                      |                     |0.002    |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |17.15 (3.83)          |24.39 (6.17)          |20.09 (6.03)         |         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |17.3 (14.95 - 19.2)   |22.8 (21 - 30.4)      |19.2 (15.43 - 22.8)  |         |
|&nbsp;&nbsp;&nbsp;Range            |10.4 - 24.4           |15 - 33.9             |10.4 - 33.9          |         |
|**qsec**                           |                      |                      |                     |0.258    |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |18.18 (1.75)          |17.36 (1.79)          |17.85 (1.79)         |         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |17.82 (17.18 - 19.17) |17.02 (16.46 - 18.61) |17.71 (16.89 - 18.9) |         |
|&nbsp;&nbsp;&nbsp;Range            |15.41 - 22.9          |14.5 - 19.9           |14.5 - 22.9          |         |
|**wt**                             |                      |                      |                     |< 0.001  |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |3.77 (0.78)           |2.41 (0.62)           |3.22 (0.98)          |         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |3.52 (3.44 - 3.84)    |2.32 (1.94 - 2.78)    |3.33 (2.58 - 3.61)   |         |
|&nbsp;&nbsp;&nbsp;Range            |2.46 - 5.42           |1.51 - 3.57           |1.51 - 5.42          |         |

### Summary Statistics Table By Multiple Groups

If you want to startify the table by multiple columns, just add more variables in the `groupig_var` vector. 

```r
tblgoat::tbl_goat(mtcars, grouping_var = c("am", "vs"))
```
|&nbsp;                             |0_1 N = 7 (21.88%)     |1_1 N = 7 (21.88%)    |0_0 N = 12 (37.5%)    |1_0 N = 6 (18.75%)    |Total N = 32 (100%)  |p-values |
|:----------------------------------|:----------------------|:---------------------|:---------------------|:---------------------|:--------------------|:--------|
|**carb**                           |                       |                      |                      |                      |                     |0.028    |
|&nbsp;&nbsp;&nbsp;1                |3 (42.86%)             |4 (57.14%)            |No Data               |No Data               |7 (21.88%)           |         |
|&nbsp;&nbsp;&nbsp;2                |2 (28.57%)             |3 (42.86%)            |4 (33.33%)            |1 (16.67%)            |10 (31.25%)          |         |
|&nbsp;&nbsp;&nbsp;3                |No Data                |No Data               |3 (25%)               |No Data               |3 (9.38%)            |         |
|&nbsp;&nbsp;&nbsp;4                |2 (28.57%)             |No Data               |5 (41.67%)            |3 (50%)               |10 (31.25%)          |         |
|&nbsp;&nbsp;&nbsp;6                |No Data                |No Data               |No Data               |1 (16.67%)            |1 (3.12%)            |         |
|&nbsp;&nbsp;&nbsp;8                |No Data                |No Data               |No Data               |1 (16.67%)            |1 (3.12%)            |         |
|**cyl**                            |                       |                      |                      |                      |                     |< 0.001  |
|&nbsp;&nbsp;&nbsp;4                |3 (42.86%)             |7 (100%)              |No Data               |1 (16.67%)            |11 (34.38%)          |         |
|&nbsp;&nbsp;&nbsp;6                |4 (57.14%)             |No Data               |No Data               |3 (50%)               |7 (21.88%)           |         |
|&nbsp;&nbsp;&nbsp;8                |No Data                |No Data               |12 (100%)             |2 (33.33%)            |14 (43.75%)          |         |
|**gear**                           |                       |                      |                      |                      |                     |< 0.001  |
|&nbsp;&nbsp;&nbsp;3                |3 (42.86%)             |No Data               |12 (100%)             |No Data               |15 (46.88%)          |         |
|&nbsp;&nbsp;&nbsp;4                |4 (57.14%)             |6 (85.71%)            |No Data               |2 (33.33%)            |12 (37.5%)           |         |
|&nbsp;&nbsp;&nbsp;5                |No Data                |1 (14.29%)            |No Data               |4 (66.67%)            |5 (15.62%)           |         |
|**disp**                           |                       |                      |                      |                      |                     |< 0.001  |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |175.11 (49.13)         |89.8 (18.8)           |357.62 (71.82)        |206.22 (95.23)        |230.72 (123.94)      |         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |167.6 (143.75 - 196.3) |79 (77.2 - 101.55)    |355 (296.95 - 410)    |160 (148.75 - 265.75) |196.3 (120.83 - 326) |         |
|&nbsp;&nbsp;&nbsp;Range            |120.1 - 258            |71.1 - 121            |275.8 - 472           |120.3 - 351           |71.1 - 472           |         |
|**drat**                           |                       |                      |                      |                      |                     |< 0.001  |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |3.57 (0.46)            |4.15 (0.38)           |3.12 (0.23)           |3.94 (0.34)           |3.6 (0.53)           |         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |3.7 (3.38 - 3.92)      |4.08 (3.96 - 4.17)    |3.08 (3.05 - 3.17)    |3.9 (3.69 - 4.14)     |3.7 (3.08 - 3.92)    |         |
|&nbsp;&nbsp;&nbsp;Range            |2.76 - 3.92            |3.77 - 4.93           |2.76 - 3.73           |3.54 - 4.43           |2.76 - 4.93          |         |
|**hp**                             |                       |                      |                      |                      |                     |< 0.001  |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |102.14 (20.93)         |80.57 (24.14)         |194.17 (33.36)        |180.83 (98.82)        |146.69 (68.56)       |         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |105 (96 - 116.5)       |66 (65.5 - 101)       |180 (175 - 218.75)    |142.5 (110 - 241.75)  |123 (96.5 - 180)     |         |
|&nbsp;&nbsp;&nbsp;Range            |62 - 123               |52 - 113              |150 - 245             |91 - 335              |52 - 335             |         |
|**mpg**                            |                       |                      |                      |                      |                     |< 0.001  |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |20.74 (2.47)           |28.37 (4.76)          |15.05 (2.77)          |19.75 (4.01)          |20.09 (6.03)         |         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |21.4 (18.65 - 22.15)   |30.4 (25.05 - 31.4)   |15.2 (14.05 - 16.62)  |20.35 (16.78 - 21)    |19.2 (15.43 - 22.8)  |         |
|&nbsp;&nbsp;&nbsp;Range            |17.8 - 24.4            |21.4 - 33.9           |10.4 - 19.2           |15 - 26               |10.4 - 33.9          |         |
|**qsec**                           |                       |                      |                      |                      |                     |< 0.001  |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |19.97 (1.46)           |18.7 (0.95)           |17.14 (0.8)           |15.8 (1.09)           |17.85 (1.79)         |         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |20 (19.17 - 20.12)     |18.61 (18.56 - 19.18) |17.35 (16.98 - 17.66) |15.98 (14.82 - 16.64) |17.71 (16.89 - 18.9) |         |
|&nbsp;&nbsp;&nbsp;Range            |18.3 - 22.9            |16.9 - 19.9           |15.41 - 18            |14.5 - 17.02          |14.5 - 22.9          |         |
|**wt**                             |                       |                      |                      |                      |                     |< 0.001  |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |3.19 (0.35)            |2.03 (0.44)           |4.1 (0.77)            |2.86 (0.49)           |3.22 (0.98)          |         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |3.21 (3.17 - 3.44)     |1.94 (1.73 - 2.26)    |3.81 (3.56 - 4.37)    |2.82 (2.66 - 3.1)     |3.33 (2.58 - 3.61)   |         |
|&nbsp;&nbsp;&nbsp;Range            |2.46 - 3.46            |1.51 - 2.78           |3.44 - 5.42           |2.14 - 3.57           |1.51 - 5.42          |         |

### Summary Statistics Table Without p-values and total

```r
tblgoat::tbl_goat(mtcars, grouping_var = "am", p_value = F, header = F, total = F)
```
|&nbsp;                             |0                     |1                     |
|:----------------------------------|:---------------------|:---------------------|
|**carb**                           |                      |                      |
|&nbsp;&nbsp;&nbsp;1                |3 (15.79%)            |4 (30.77%)            |
|&nbsp;&nbsp;&nbsp;2                |6 (31.58%)            |4 (30.77%)            |
|&nbsp;&nbsp;&nbsp;3                |3 (15.79%)            |No Data               |
|&nbsp;&nbsp;&nbsp;4                |7 (36.84%)            |3 (23.08%)            |
|&nbsp;&nbsp;&nbsp;6                |No Data               |1 (7.69%)             |
|&nbsp;&nbsp;&nbsp;8                |No Data               |1 (7.69%)             |
|**cyl**                            |                      |                      |
|&nbsp;&nbsp;&nbsp;4                |3 (15.79%)            |8 (61.54%)            |
|&nbsp;&nbsp;&nbsp;6                |4 (21.05%)            |3 (23.08%)            |
|&nbsp;&nbsp;&nbsp;8                |12 (63.16%)           |2 (15.38%)            |
|**gear**                           |                      |                      |
|&nbsp;&nbsp;&nbsp;3                |15 (78.95%)           |No Data               |
|&nbsp;&nbsp;&nbsp;4                |4 (21.05%)            |8 (61.54%)            |
|&nbsp;&nbsp;&nbsp;5                |No Data               |5 (38.46%)            |
|**vs**                             |                      |                      |
|&nbsp;&nbsp;&nbsp;0                |12 (63.16%)           |6 (46.15%)            |
|&nbsp;&nbsp;&nbsp;1                |7 (36.84%)            |7 (53.85%)            |
|**disp**                           |                      |                      |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |290.38 (110.17)       |143.53 (87.2)         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |275.8 (196.3 - 360)   |120.3 (79 - 160)      |
|&nbsp;&nbsp;&nbsp;Range            |120.1 - 472           |71.1 - 351            |
|**drat**                           |                      |                      |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |3.29 (0.39)           |4.05 (0.36)           |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |3.15 (3.07 - 3.7)     |4.08 (3.85 - 4.22)    |
|&nbsp;&nbsp;&nbsp;Range            |2.76 - 3.92           |3.54 - 4.93           |
|**hp**                             |                      |                      |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |160.26 (53.91)        |126.85 (84.06)        |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |175 (116.5 - 192.5)   |109 (66 - 113)        |
|&nbsp;&nbsp;&nbsp;Range            |62 - 245              |52 - 335              |
|**mpg**                            |                      |                      |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |17.15 (3.83)          |24.39 (6.17)          |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |17.3 (14.95 - 19.2)   |22.8 (21 - 30.4)      |
|&nbsp;&nbsp;&nbsp;Range            |10.4 - 24.4           |15 - 33.9             |
|**qsec**                           |                      |                      |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |18.18 (1.75)          |17.36 (1.79)          |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |17.82 (17.18 - 19.17) |17.02 (16.46 - 18.61) |
|&nbsp;&nbsp;&nbsp;Range            |15.41 - 22.9          |14.5 - 19.9           |
|**wt**                             |                      |                      |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |3.77 (0.78)           |2.41 (0.62)           |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |3.52 (3.44 - 3.84)    |2.32 (1.94 - 2.78)    |
|&nbsp;&nbsp;&nbsp;Range            |2.46 - 5.42           |1.51 - 3.57           |

### Summary Statistics Table (how `tblgoat` handles missing values)

```r
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

tblgoat::tbl_goat(gapminder, grouping_var = "continent")
```

|&nbsp;                             |Africa N = 567 (37.11%) |Americas N = 263 (17.21%) |Asia N = 357 (23.36%) |Europe N = 319 (20.88%) |Oceania N = 22 (1.44%)  |Total N = 1528 (100%) |p-values |
|:----------------------------------|:-----------------------|:-------------------------|:---------------------|:-----------------------|:-----------------------|:---------------------|:--------|
|**gdpPercap**                      |                        |                          |                      |                        |                        |                      |< 0.001  |
|&nbsp;&nbsp;&nbsp;high             |87 (17.09%)             |178 (73.55%)              |137 (42.28%)          |263 (92.28%)            |20 (100%)               |685 (49.64%)          |         |
|&nbsp;&nbsp;&nbsp;low              |422 (82.91%)            |64 (26.45%)               |187 (57.72%)          |22 (7.72%)              |No Data                 |695 (50.36%)          |         |
|&nbsp;&nbsp;&nbsp;Missing          |58                      |21                        |33                    |34                      |2                       |148                   |         |
|**lifeExp**                        |                        |                          |                      |                        |                        |                      |< 0.001  |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |48.82 (9.16)            |64.79 (9.2)               |60.35 (12.16)         |71.92 (5.4)             |73.97 (3.65)            |59.42 (13)            |         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |47.79 (42.37 - 54.41)   |67.05 (58.95 - 71.72)     |62.3 (51.5 - 70.2)    |72.19 (69.59 - 75.44)   |73.49 (71.1 - 76.33)    |60.77 (48.09 - 70.84) |         |
|&nbsp;&nbsp;&nbsp;Range            |23.6 - 76.44            |37.58 - 80.65             |28.8 - 82.6           |43.59 - 81.76           |69.12 - 81.23           |23.6 - 82.6           |         |
|&nbsp;&nbsp;&nbsp;Missing          |55                      |24                        |39                    |36                      |1                       |155                   |         |
|**pop**                            |                        |                          |                      |                        |                        |                      |< 0.001  |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |10.3 (16.59)            |22.35 (47.61)             |81.11 (218.87)        |16.85 (20.4)            |8.93 (6.4)              |30.5 (112.6)          |         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |4.57 (1.37 - 10.72)     |6.31 (3.03 - 17.23)       |14.62 (3.83 - 46.77)  |8.43 (4.32 - 21.07)     |8.69 (3.21 - 14.07)     |7.15 (2.79 - 19.77)   |         |
|&nbsp;&nbsp;&nbsp;Range            |0.06 - 135.03           |0.66 - 301.14             |0.14 - 1318.68        |0.15 - 82.4             |1.99 - 20.43            |0.06 - 1318.68        |         |
|&nbsp;&nbsp;&nbsp;Missing          |73                      |23                        |34                    |29                      |1                       |160                   |         |
|**year**                           |                        |                          |                      |                        |                        |                      |0.886    |
|&nbsp;&nbsp;&nbsp;Mean (sd)        |1979.12 (17.26)         |1980.01 (17.17)           |1980.22 (17.24)       |1979.17 (16.94)         |1978.82 (17.22)         |1979.54 (17.15)       |         |
|&nbsp;&nbsp;&nbsp;Median (Q1 - Q3) |1977 (1962 - 1992)      |1982 (1967 - 1997)        |1982 (1967 - 1997)    |1977 (1967 - 1992)      |1979.5 (1963.25 - 1992) |1982 (1967 - 1992)    |         |
|&nbsp;&nbsp;&nbsp;Range            |1952 - 2007             |1952 - 2007               |1952 - 2007           |1952 - 2007             |1952 - 2007             |1952 - 2007           |         |
|&nbsp;&nbsp;&nbsp;Missing          |56                      |29                        |32                    |33                      |0                       |150                   |         |
