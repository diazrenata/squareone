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
meant_ts <- ts(weather_full$meantemp, start = weather_full$newdate[1], frequency = 12)

meant_ts_interp <- imputeTS::na_interpolation(meant_ts)

weather_full_drought <- weather_full %>%
  mutate(precip_interp = precip_ts_interp,
         temp_interp = meant_ts_interp) %>% 
  filter(year > 1988) %>%
  mutate(thorn = SPEI::thornthwaite(temp_interp, lat = 31.938908)) %>%
  mutate(cbal = precip_interp - thorn) %>%
  mutate(spei1 = spei(cbal, 1)$fitted, 
spei6 = spei(cbal, 6)$fitted, 
         spei12 = spei(cbal, 12)$fitted,
         spei60 = spei(cbal, 60)$fitted)


ggplot(weather_full_drought, aes(date, spei12)) + geom_line()
```

    ## Don't know how to automatically pick scale for object of type ts. Defaulting to continuous.

    ## Warning: Removed 19 row(s) containing missing values (geom_path).

![](drought_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->
