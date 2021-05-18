Erodium
================

  - [Treatment levels](#treatment-levels)
      - [GLM on proportional abundance](#glm-on-proportional-abundance)
  - [Plot level](#plot-level)

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(soar)
library(ggplot2)
knitr::opts_chunk$set(echo = FALSE, fig.dim = c(6, 3))

theme_set(theme_bw())

era_grid <-   facet_grid(cols = vars(oera), space = "free", scales = "free_x")
both_scale <- scale_color_viridis_d(begin = .1, end = .8)
cc_scale <- scale_color_viridis_d(begin = .1, end = .1)
ee_scale <- scale_color_viridis_d(begin = .8, end =.8)
both_fscale <- scale_fill_viridis_d(begin = .1, end = .8)
cc_fscale <- scale_fill_viridis_d(begin = .1, end = .1)
ee_fscale <- scale_fill_viridis_d(begin = .8, end =.8)
```

    ## Loading in data version 2.95.0
    ## Loading in data version 2.95.0

    ## Joining, by = "plot"

    ## Joining, by = c("year", "season", "plot")

# Treatment levels

Gaps are for censuses in 1996, 2000, 2006, and 2011 where plots were
censused but no individuals were found (of any species).

![](erodium_results_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->![](erodium_results_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->

### GLM on proportional abundance

`prop_abund ~ treatment + era, family = quasibinomial`

    ## Joining, by = c("oera", "oplottype")

![](erodium_results_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

<div class="kable-table">

| oera | oplottype |       est |     lower |     upper |
| :--- | :-------- | --------: | --------: | --------: |
| a    | CC        | 0.0183824 | 0.0048080 | 0.0676758 |
| a    | EE        | 0.0467621 | 0.0133983 | 0.1505308 |
| b    | EE        | 0.5904758 | 0.4680586 | 0.7026198 |
| b    | CC        | 0.3550116 | 0.2457459 | 0.4818250 |
| c    | CC        | 0.0782894 | 0.0364074 | 0.1603344 |
| c    | EE        | 0.1820075 | 0.0986260 | 0.3115194 |

</div>

    ## oplottype = CC:
    ##  contrast estimate    SE  df z.ratio p.value
    ##  a - b       -3.38 0.666 Inf -5.074  <.0001 
    ##  a - c       -1.51 0.719 Inf -2.101  0.0895 
    ##  b - c        1.87 0.392 Inf  4.768  <.0001 
    ## 
    ## oplottype = EE:
    ##  contrast estimate    SE  df z.ratio p.value
    ##  a - b       -3.38 0.666 Inf -5.074  <.0001 
    ##  a - c       -1.51 0.719 Inf -2.101  0.0895 
    ##  b - c        1.87 0.392 Inf  4.768  <.0001 
    ## 
    ## Results are given on the log odds ratio (not the response) scale. 
    ## P value adjustment: tukey method for comparing a family of 3 estimates

# Plot level

Broken out by plot, we get gaps for years and plots when there were no
individuals (of any species) observed:

    ## Loading in data version 2.95.0
    ## Loading in data version 2.95.0

    ## Joining, by = "plot"

    ## Joining, by = c("year", "season", "plot")

![](erodium_results_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->![](erodium_results_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->![](erodium_results_files/figure-gfm/unnamed-chunk-4-3.png)<!-- -->
