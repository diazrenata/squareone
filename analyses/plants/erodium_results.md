Erodium
================

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

winter <- portalr::plant_abundance(level = "Plot", type = "Winter Annuals", length = "all")
```

    ## Warning in summarize_plant_data(..., shape = "flat", output = "abundance"): The
    ## `length` argument is deprecated; please use `plots` instead.

    ## Loading in data version 2.95.0

    ## Joining, by = "plot"

# Treatment levels

    ## Joining, by = "plot"

    ## Joining, by = "year"

    ## `summarise()` has grouped output by 'year', 'plot', 'plot_type'. You can override using the `.groups` argument.

    ## Joining, by = c("year", "plot", "plot_type", "oera")

    ## `summarise()` has grouped output by 'year', 'plot', 'plot_type'. You can override using the `.groups` argument.

    ## Joining, by = c("year", "plot", "plot_type", "oera")

    ## `summarise()` has grouped output by 'year', 'plot_type'. You can override using the `.groups` argument.

![](erodium_results_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->![](erodium_results_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->

    ## Joining, by = c("period", "oplottype")

![](erodium_results_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

    ##   oera oplottype         est        lower     upper
    ## 1    a        CC 0.007715796 0.0002100903 0.2234425
    ## 2    a        EE 0.057428745 0.0154251810 0.1915570
    ## 3    b        CC 0.388550771 0.2677117420 0.5248413
    ## 4    b        EE 0.559731557 0.4305392969 0.6813096
    ## 5    c        CC 0.042839716 0.0093132477 0.1756575
    ## 6    c        EE 0.217457152 0.1144022568 0.3741271

    ## oplottype = CC:
    ##  contrast estimate    SE  df z.ratio p.value
    ##  a - b       -4.40 1.827 Inf -2.411  0.0421 
    ##  a - c       -1.75 1.967 Inf -0.890  0.6467 
    ##  b - c        2.65 0.828 Inf  3.205  0.0039 
    ## 
    ## oplottype = EE:
    ##  contrast estimate    SE  df z.ratio p.value
    ##  a - b       -3.04 0.727 Inf -4.178  0.0001 
    ##  a - c       -1.52 0.780 Inf -1.946  0.1258 
    ##  b - c        1.52 0.463 Inf  3.285  0.0029 
    ## 
    ## Results are given on the log odds ratio (not the response) scale. 
    ## P value adjustment: tukey method for comparing a family of 3 estimates

# Plot level

Broken out by plot, we get gaps for years and plots when there were no
individuals (of any species) observed:

![](erodium_results_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->![](erodium_results_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->
