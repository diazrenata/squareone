New plots with 81 data
================

![](new_plots_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

## Biomass and energy use

``` r
ggplot(filter(rat_totals, type != "other"), aes(period, biomass, color = brown_trtmnt)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  scale_color_viridis_d(end = .8) +
  facet_wrap(vars(type),scales = "free_y", ncol = 1)
```

![](new_plots_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
ggplot(filter(rat_totals, type != "other"), aes(period, energy, color = brown_trtmnt)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  scale_color_viridis_d(end = .8) +
  facet_wrap(vars(type),scales = "free_y", ncol = 1)
```

![](new_plots_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->

### Plot totals

``` r
rat_plot_totals <- rats %>%
  group_by(plot, period) %>%
  mutate(nind = dplyr::n(),
         biomass = sum(wgt, na.rm = T),
         energy = sum(energy, na.rm = T)) %>%
  select(-day, -stake, -species, -sex, -hfl, -wgt, -tag, -ltag, -granivore, -omnivore, -small_granivore, -small_omnivore, -dipo, -type) %>%
  distinct()

rat_treatment_totals <- rats %>%
  group_by(brown_trtmnt, period) %>%
  summarize(nind = dplyr::n(),
         biomass = sum(wgt, na.rm = T),
         energy = sum(energy, na.rm = T))
```

    ## `summarise()` regrouping output by 'brown_trtmnt' (override with `.groups` argument)

``` r
ggplot(rat_plot_totals, aes(period, nind, group = plot, color = brown_trtmnt)) +
  geom_point() +
  geom_line() +
  scale_color_viridis_d(end = .8) +
  theme_bw() 
```

![](new_plots_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

``` r
ggplot(rat_treatment_totals, aes(period, nind, color = brown_trtmnt)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  scale_color_viridis_d(end = .8)
```

![](new_plots_files/figure-gfm/unnamed-chunk-3-2.png)<!-- -->

``` r
ggplot(rat_plot_totals, aes(period, biomass, group = plot, color = brown_trtmnt)) +
  geom_point() +
  geom_line() +
  scale_color_viridis_d(end = .8) +
  theme_bw() 
```

![](new_plots_files/figure-gfm/unnamed-chunk-3-3.png)<!-- -->

``` r
ggplot(rat_treatment_totals, aes(period, biomass, color = brown_trtmnt)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  scale_color_viridis_d(end = .8)
```

![](new_plots_files/figure-gfm/unnamed-chunk-3-4.png)<!-- -->

``` r
ggplot(rat_plot_totals, aes(period, energy, group = plot, color = brown_trtmnt)) +
  geom_point() +
  geom_line() +
  scale_color_viridis_d(end = .8) +
  theme_bw() 
```

![](new_plots_files/figure-gfm/unnamed-chunk-3-5.png)<!-- -->

``` r
ggplot(rat_treatment_totals, aes(period, energy, color = brown_trtmnt)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  scale_color_viridis_d(end = .8)
```

![](new_plots_files/figure-gfm/unnamed-chunk-3-6.png)<!-- -->
