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
```

    ## Loading in data version 2.95.0
    ## Loading in data version 2.95.0

    ## Joining, by = "plot"

    ## Joining, by = c("year", "season", "plot")

# Treatment levels

Gaps are for censuses in 1996, 2000, 2006, and 2011 where plots were
censused but no individuals were found (of any species).

![](erodium_results_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->![](erodium_results_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->

    ## Analysis of Deviance Table
    ## 
    ## Model 1: erod_treatment_prop_abundance ~ oplottype * oera
    ## Model 2: erod_treatment_prop_abundance ~ oplottype + oera
    ##   Resid. Df Resid. Dev Df Deviance Pr(>Chi)
    ## 1        49     11.182                     
    ## 2        51     11.594 -2 -0.41254    0.356

    ## Joining, by = c("oera", "oplottype")

![](erodium_results_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

    ##   oera oplottype        est       lower      upper
    ## 1    a        CC 0.01838244 0.004807979 0.06767576
    ## 2    a        EE 0.04676210 0.013398288 0.15053085
    ## 3    b        EE 0.59047576 0.468058639 0.70261984
    ## 4    b        CC 0.35501164 0.245745901 0.48182498
    ## 5    c        CC 0.07828937 0.036407384 0.16033442
    ## 6    c        EE 0.18200750 0.098626027 0.31151939

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
