ndvi anomaly
================

``` r
weather <- weather(level = "monthly", fill = T)

weather <- weather %>%
    dplyr::mutate(date = format(lubridate::parse_date_time(paste(month, year, sep=" "),
                                                           orders = c("m/Y")), "%m-%Y")) %>%
    dplyr::mutate(date = as.Date(paste("01",date,sep="-"), format="%d-%m-%Y"))  %>%
  mutate(numdate = as.numeric(date))


weather_full <- expand.grid(year = c(min(weather$year) : max(weather$year)),
  month = c(1:12)
) %>%
  left_join(mutate(weather, month = as.numeric(month), year = as.numeric(year))) %>%
  mutate(datestr = paste0(year, "-01-", month)) %>%
  mutate(newdate = as.Date(datestr, format = "%Y-%d-%m")) %>%
  arrange(newdate)
```

    ## Joining, by = c("year", "month")

## precip

### Total precip

``` r
precip_ts <- ts(weather_full$precipitation, start = weather_full$newdate[1], frequency = 12)

precip_ts_interp <- imputeTS::na_interpolation(precip_ts)
```

    ## Registered S3 method overwritten by 'quantmod':
    ##   method            from
    ##   as.zoo.data.frame zoo

``` r
precip_decomp <- decompose(precip_ts_interp, type = "additive")

plot(precip_decomp)
```

![](precip_results_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
precip_full <- weather_full %>%
  mutate(no_seasonal = as.numeric(precip_decomp$trend) + as.numeric(precip_decomp$random),
         trend= as.numeric(precip_decomp$trend))

ggplot(precip_full, aes(newdate, no_seasonal)) +
  geom_line(alpha = .3)  +
  geom_line(aes(y=trend))
```

    ## Warning: Removed 12 row(s) containing missing values (geom_path).
    
    ## Warning: Removed 12 row(s) containing missing values (geom_path).

![](precip_results_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->

``` r
precip_gam <- mgcv::gam(trend ~ s(as.numeric(newdate)), data = precip_full)

precip_full <- precip_full %>%
  gratia::add_fitted(precip_gam)
ggplot(precip_full, aes(newdate, no_seasonal)) +
  geom_line(alpha = .1)  +
  geom_line(aes(y=trend), alpha = .5) +
  geom_line(aes(y = .value)) +
  geom_vline(xintercept = as.Date("1996-01-01", format = "%Y-%m-%d"), linetype = 4) +  
  geom_vline(xintercept = as.Date("2010-01-01", format = "%Y-%m-%d"), linetype = 4)
```

    ## Warning: Removed 12 row(s) containing missing values (geom_path).
    
    ## Warning: Removed 12 row(s) containing missing values (geom_path).

![](precip_results_files/figure-gfm/unnamed-chunk-2-3.png)<!-- -->

### Summer precip

``` r
summer_precip <- weather_full %>%
  filter(month %in% c(4:9)) %>%
  group_by(year) %>%
  summarize(s_precip = sum(precipitation)) %>%
  ungroup() 

ggplot(summer_precip, aes(year, s_precip)) + geom_line()
```

    ## Warning: Removed 1 row(s) containing missing values (geom_path).

![](precip_results_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

### Winter precip

``` r
winter_precip <- weather_full %>%
  filter(month %in% c(1:3, 10:12)) %>%
  mutate(water_year = ifelse(month > 5, year + 1, year)) %>%
  group_by(water_year) %>%
  summarize(w_precip = sum(precipitation)) %>%
  ungroup() %>%
  filter(water_year < 2020)

ggplot(winter_precip, aes(water_year, w_precip)) + geom_line()
```

![](precip_results_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

<!-- ### Warm precip -->

<!-- ```{r} -->

<!-- warm_precip_ts <- ts(weather_full$warm_precip, start = weather_full$newdate[1], frequency = 12) -->

<!-- warm_precip_ts_interp <- imputeTS::na_interpolation(warm_precip_ts) -->

<!-- warm_precip_decomp <- decompose(warm_precip_ts_interp, type = "additive") -->

<!-- plot(warm_precip_decomp) -->

<!-- warm_precip_full <- weather_full %>% -->

<!--   mutate(no_seasonal = as.numeric(warm_precip_decomp$trend) + as.numeric(warm_precip_decomp$random), -->

<!--          trend= as.numeric(warm_precip_decomp$trend)) -->

<!-- ggplot(warm_precip_full, aes(newdate, no_seasonal)) + -->

<!--   geom_line(alpha = .3)  + -->

<!--   geom_line(aes(y=trend)) -->

<!-- warm_precip_gam <- mgcv::gam(trend ~ s(as.numeric(newdate)), data = warm_precip_full) -->

<!-- warm_precip_full <- warm_precip_full %>% -->

<!--   gratia::add_fitted(warm_precip_gam) -->

<!-- ggplot(warm_precip_full, aes(newdate, no_seasonal)) + -->

<!--   geom_line(alpha = .1)  + -->

<!--   geom_line(aes(y=trend), alpha = .5) + -->

<!--   geom_line(aes(y = .value)) + -->

<!--   geom_vline(xintercept = as.Date("1996-01-01", format = "%Y-%m-%d"), linetype = 4) +   -->

<!--   geom_vline(xintercept = as.Date("2010-01-01", format = "%Y-%m-%d"), linetype = 4) -->

<!-- ``` -->

<!-- ### cool precip -->

<!-- ```{r} -->

<!-- cool_precip_ts <- ts(weather_full$cool_precip, start = weather_full$newdate[1], frequency = 12) -->

<!-- cool_precip_ts_interp <- imputeTS::na_interpolation(cool_precip_ts) -->

<!-- cool_precip_decomp <- decompose(cool_precip_ts_interp, type = "additive") -->

<!-- plot(cool_precip_decomp) -->

<!-- cool_precip_full <- weather_full %>% -->

<!--   mutate(no_seasonal = as.numeric(cool_precip_decomp$trend) + as.numeric(cool_precip_decomp$random), -->

<!--          trend= as.numeric(cool_precip_decomp$trend)) -->

<!-- ggplot(cool_precip_full, aes(newdate, no_seasonal)) + -->

<!--   geom_line(alpha = .3)  + -->

<!--   geom_line(aes(y=trend)) -->

<!-- cool_precip_gam <- mgcv::gam(trend ~ s(as.numeric(newdate)), data = cool_precip_full) -->

<!-- cool_precip_full <- cool_precip_full %>% -->

<!--   gratia::add_fitted(cool_precip_gam) -->

<!-- ggplot(cool_precip_full, aes(newdate, no_seasonal)) + -->

<!--   geom_line(alpha = .1)  + -->

<!--   geom_line(aes(y=trend), alpha = .5) + -->

<!--   geom_line(aes(y = .value)) + -->

<!--   geom_vline(xintercept = as.Date("1996-01-01", format = "%Y-%m-%d"), linetype = 4) +   -->

<!--   geom_vline(xintercept = as.Date("2010-01-01", format = "%Y-%m-%d"), linetype = 4) -->

<!-- ``` -->

## Temp

### Mean temp

``` r
meantemp_ts <- ts(weather_full$meantemp, start = weather_full$newdate[1], frequency = 12)

meantemp_ts_interp <- imputeTS::na_interpolation(meantemp_ts)

meantemp_decomp <- decompose(meantemp_ts_interp, type = "additive")

plot(meantemp_decomp)
```

![](precip_results_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
meantemp_full <- weather_full %>%
  mutate(no_seasonal = as.numeric(meantemp_decomp$trend) + as.numeric(meantemp_decomp$random),
         trend= as.numeric(meantemp_decomp$trend))

ggplot(meantemp_full, aes(newdate, no_seasonal)) +
  geom_line(alpha = .3)  +
  geom_line(aes(y=trend))
```

    ## Warning: Removed 12 row(s) containing missing values (geom_path).
    
    ## Warning: Removed 12 row(s) containing missing values (geom_path).

![](precip_results_files/figure-gfm/unnamed-chunk-5-2.png)<!-- -->

``` r
meantemp_gam <- mgcv::gam(trend ~ s(as.numeric(newdate)), data = meantemp_full)

meantemp_full <- meantemp_full %>%
  gratia::add_fitted(meantemp_gam)
ggplot(meantemp_full, aes(newdate, no_seasonal)) +
  geom_line(alpha = .1)  +
  geom_line(aes(y=trend), alpha = .5) +
  geom_line(aes(y = .value)) +
  geom_vline(xintercept = as.Date("1996-01-01", format = "%Y-%m-%d"), linetype = 4) +  
  geom_vline(xintercept = as.Date("2010-01-01", format = "%Y-%m-%d"), linetype = 4)
```

    ## Warning: Removed 12 row(s) containing missing values (geom_path).
    
    ## Warning: Removed 12 row(s) containing missing values (geom_path).

![](precip_results_files/figure-gfm/unnamed-chunk-5-3.png)<!-- -->

### max temp

``` r
maxtemp_ts <- ts(weather_full$maxtemp, start = weather_full$newdate[1], frequency = 12)

maxtemp_ts_interp <- imputeTS::na_interpolation(maxtemp_ts)

maxtemp_decomp <- decompose(maxtemp_ts_interp, type = "additive")

plot(maxtemp_decomp)
```

![](precip_results_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

``` r
maxtemp_full <- weather_full %>%
  mutate(no_seasonal = as.numeric(maxtemp_decomp$trend) + as.numeric(maxtemp_decomp$random),
         trend= as.numeric(maxtemp_decomp$trend))

ggplot(maxtemp_full, aes(newdate, no_seasonal)) +
  geom_line(alpha = .3)  +
  geom_line(aes(y=trend))
```

    ## Warning: Removed 12 row(s) containing missing values (geom_path).
    
    ## Warning: Removed 12 row(s) containing missing values (geom_path).

![](precip_results_files/figure-gfm/unnamed-chunk-6-2.png)<!-- -->

``` r
maxtemp_gam <- mgcv::gam(trend ~ s(as.numeric(newdate)), data = maxtemp_full)

maxtemp_full <- maxtemp_full %>%
  gratia::add_fitted(maxtemp_gam)
ggplot(maxtemp_full, aes(newdate, no_seasonal)) +
  geom_line(alpha = .1)  +
  geom_line(aes(y=trend), alpha = .5) +
  geom_line(aes(y = .value)) +
  geom_vline(xintercept = as.Date("1996-01-01", format = "%Y-%m-%d"), linetype = 4) +  
  geom_vline(xintercept = as.Date("2010-01-01", format = "%Y-%m-%d"), linetype = 4)
```

    ## Warning: Removed 12 row(s) containing missing values (geom_path).
    
    ## Warning: Removed 12 row(s) containing missing values (geom_path).

![](precip_results_files/figure-gfm/unnamed-chunk-6-3.png)<!-- -->

### min temp

``` r
mintemp_ts <- ts(weather_full$mintemp, start = weather_full$newdate[1], frequency = 12)

mintemp_ts_interp <- imputeTS::na_interpolation(mintemp_ts)

mintemp_decomp <- decompose(mintemp_ts_interp, type = "additive")

plot(mintemp_decomp)
```

![](precip_results_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

``` r
mintemp_full <- weather_full %>%
  mutate(no_seasonal = as.numeric(mintemp_decomp$trend) + as.numeric(mintemp_decomp$random),
         trend= as.numeric(mintemp_decomp$trend))

ggplot(mintemp_full, aes(newdate, no_seasonal)) +
  geom_line(alpha = .3)  +
  geom_line(aes(y=trend))
```

    ## Warning: Removed 12 row(s) containing missing values (geom_path).
    
    ## Warning: Removed 12 row(s) containing missing values (geom_path).

![](precip_results_files/figure-gfm/unnamed-chunk-7-2.png)<!-- -->

``` r
mintemp_gam <- mgcv::gam(trend ~ s(as.numeric(newdate)), data = mintemp_full)

mintemp_full <- mintemp_full %>%
  gratia::add_fitted(mintemp_gam)
ggplot(mintemp_full, aes(newdate, no_seasonal)) +
  geom_line(alpha = .1)  +
  geom_line(aes(y=trend), alpha = .5) +
  geom_line(aes(y = .value)) +
  geom_vline(xintercept = as.Date("1996-01-01", format = "%Y-%m-%d"), linetype = 4) +  
  geom_vline(xintercept = as.Date("2010-01-01", format = "%Y-%m-%d"), linetype = 4)
```

    ## Warning: Removed 12 row(s) containing missing values (geom_path).
    
    ## Warning: Removed 12 row(s) containing missing values (geom_path).

![](precip_results_files/figure-gfm/unnamed-chunk-7-3.png)<!-- -->