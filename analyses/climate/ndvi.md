ndvi anomaly
================

``` r
ndvi <- ndvi()


ndvi <- ndvi %>%
  mutate(month = format.Date(date, "%m"),
         year = format.Date(date, "%Y")) %>%
  group_by(month) %>%
  mutate(ndvi_norm = mean(ndvi)) %>%
  ungroup() %>%
  mutate(ndvi_difference = ndvi - ndvi_norm,
         ndvi_prop = ndvi / ndvi_norm) %>%
  mutate(numdate = as.numeric(date)) 

ndvi_full <- expand.grid(
  year = c(min(ndvi$year) : max(ndvi$year)),
  month = c(1:12)
) %>%
  left_join(mutate(ndvi, month = as.numeric(month), year = as.numeric(year))) %>%
  mutate(datestr = paste0(year, "-01-", month)) %>%
  mutate(newdate = as.Date(datestr, format = "%Y-%d-%m")) %>%
  arrange(newdate)
```

    ## Joining, by = c("year", "month")

``` r
ndvi_ts <- ts(ndvi_full$ndvi, start = ndvi_full$newdate[1], frequency = 12)

ndvi_ts_interp <- imputeTS::na_interpolation(ndvi_ts)
```

    ## Registered S3 method overwritten by 'quantmod':
    ##   method            from
    ##   as.zoo.data.frame zoo

``` r
ndvi_decomp <- decompose(ndvi_ts_interp, type = "additive")

plot(ndvi_decomp)
```

![](ndvi_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

``` r
ndvi_full$no_seasonal <- as.numeric(ndvi_decomp$trend) + as.numeric(ndvi_decomp$random)
ndvi_full$trend <- as.numeric(ndvi_decomp$trend)

ggplot(ndvi_full, aes(newdate, no_seasonal)) +
  geom_line(alpha = .3)  +
  geom_line(aes(y=trend))
```

    ## Warning: Removed 12 row(s) containing missing values (geom_path).
    
    ## Warning: Removed 12 row(s) containing missing values (geom_path).

![](ndvi_files/figure-gfm/unnamed-chunk-1-2.png)<!-- -->

``` r
ndvi_gam <- mgcv::gam(no_seasonal ~ s(as.numeric(newdate), k = 10), data = ndvi_full)

ndvi_full <- ndvi_full %>%
  gratia::add_fitted(ndvi_gam)
ggplot(ndvi_full, aes(newdate, no_seasonal)) +
  geom_line(alpha = .1)  +
  geom_line(aes(y=trend), alpha = .5) +
  geom_line(aes(y = .value)) +
  geom_vline(xintercept = as.Date("1996-01-01", format = "%Y-%m-%d"), linetype = 4) +  
  geom_vline(xintercept = as.Date("2010-01-01", format = "%Y-%m-%d"), linetype = 4)
```

    ## Warning: Removed 12 row(s) containing missing values (geom_path).
    
    ## Warning: Removed 12 row(s) containing missing values (geom_path).

![](ndvi_files/figure-gfm/unnamed-chunk-1-3.png)<!-- -->
