New plots with 81 data
================

![](gams_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

``` r
load_mgcv()
df <- data_sim("eg4")
m <- gam(y ~ fac + s(x2, by = fac) + s(x0), data = df, method = "REML")
difference_smooths(m, smooth = "s(x2)")
```

    ## # A tibble: 300 x 9
    ##    smooth by    level_1 level_2  diff    se  lower upper      x2
    ##    <chr>  <chr> <chr>   <chr>   <dbl> <dbl>  <dbl> <dbl>   <dbl>
    ##  1 s(x2)  fac   1       2        1.74 0.839 0.0943  3.38 0.00109
    ##  2 s(x2)  fac   1       2        1.75 0.788 0.202   3.29 0.0112 
    ##  3 s(x2)  fac   1       2        1.75 0.740 0.304   3.20 0.0212 
    ##  4 s(x2)  fac   1       2        1.76 0.694 0.401   3.12 0.0313 
    ##  5 s(x2)  fac   1       2        1.77 0.652 0.492   3.05 0.0414 
    ##  6 s(x2)  fac   1       2        1.78 0.613 0.575   2.98 0.0515 
    ##  7 s(x2)  fac   1       2        1.78 0.579 0.650   2.92 0.0615 
    ##  8 s(x2)  fac   1       2        1.79 0.548 0.717   2.87 0.0716 
    ##  9 s(x2)  fac   1       2        1.80 0.522 0.776   2.82 0.0817 
    ## 10 s(x2)  fac   1       2        1.80 0.498 0.827   2.78 0.0918 
    ## # ... with 290 more rows

``` r
rat_totals <- rat_totals %>%
  mutate(brown_trtmnt = as.factor(brown_trtmnt))

n_gam <- gam(nind ~  brown_trtmnt + s(period, by = brown_trtmnt), data = filter(rat_totals, type == "small_granivore"), method = "REML", family = "poisson")

n_gam_fitted <- rat_totals %>%
  filter(type == "small_granivore") %>%
  add_fitted(model = n_gam, value = "fitted")

ggplot(n_gam_fitted, aes(period, nind, shape = brown_trtmnt)) +
  geom_line() +
  geom_line(aes(period, fitted), color = "blue") +
  facet_wrap(vars(brown_trtmnt))
```

![](gams_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
n_gam_diff <- difference_smooths(n_gam, smooth = "s(period)", newdata = select(filter(rat_totals, type == "small_granivore"), period, brown_trtmnt))

head(n_gam_diff)
```

    ## # A tibble: 6 x 9
    ##   smooth    by           level_1     level_2      diff    se lower  upper period
    ##   <chr>     <chr>        <chr>       <chr>       <dbl> <dbl> <dbl>  <dbl>  <dbl>
    ## 1 s(period) brown_trtmnt dipo_absent dipo_prese~ -3.39 1.38  -6.08 -0.689   1   
    ## 2 s(period) brown_trtmnt dipo_absent dipo_prese~ -3.18 1.21  -5.57 -0.803   1.34
    ## 3 s(period) brown_trtmnt dipo_absent dipo_prese~ -2.98 1.07  -5.07 -0.890   1.69
    ## 4 s(period) brown_trtmnt dipo_absent dipo_prese~ -2.78 0.938 -4.62 -0.940   2.03
    ## 5 s(period) brown_trtmnt dipo_absent dipo_prese~ -2.58 0.833 -4.21 -0.944   2.37
    ## 6 s(period) brown_trtmnt dipo_absent dipo_prese~ -2.37 0.755 -3.85 -0.895   2.72

``` r
draw(n_gam)
```

![](gams_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->

``` r
ggplot(n_gam_diff, aes(period, diff)) +
  geom_line() +
  geom_line(aes(period, lower)) +
  geom_line(aes(period, upper)) +
  theme_bw() +
  geom_hline(yintercept = 0)
```

![](gams_files/figure-gfm/unnamed-chunk-2-3.png)<!-- -->

I’m not sure what the difference is between,

`nind ~ brown_trtmnt + s(period, by = brown_trtmnt)`

`nind ~ s(period, by = brown_trtmnt)`

and even more complicated models, like including effects for plot or
somehow fitting all 3 types (krats, small granivores, and omnivores)
within the same model.
