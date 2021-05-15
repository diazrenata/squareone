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

# Plot level

``` r
winter <- winter %>%
  filter(season == "winter") %>%
  soar::add_plot_types() %>%
  filter(combined_trt %in% c("CC", "EE")) %>%
  mutate(plot_type = combined_trt) %>%
  mutate(era = ifelse(year < 1996, "a", ifelse(year < 2010, "b", "c"))) %>%
  filter(year >= 1988)  %>%
  mutate(oera = as.ordered(era))
```

    ## Joining, by = "plot"

``` r
ggplot(filter(winter, species == "erod cicu"), aes(year, abundance, color = treatment, group = plot)) +
  geom_line() +
  facet_wrap(vars(combined_trt), ncol = 1) + geom_vline(xintercept = c(1996, 2010)) + both_scale
```

![](erodium_results_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
winter_plot_props <- winter %>%
  group_by(year, plot) %>%
  mutate(total_abund = sum(abundance)) %>%
  ungroup() %>%
  filter(species == "erod cicu") %>%
  mutate(prop_abund = abundance / total_abund) %>%
  mutate(censusdate = as.Date(paste0(year, "-03-15"), origin =  "%Y-%m-%d"))

ggplot(winter_plot_props, aes(year, prop_abund, color = treatment, group = plot)) +
  geom_line() +
  facet_wrap(vars(combined_trt), ncol = 1) + geom_vline(xintercept = c(1996, 2010)) + both_scale
```

![](erodium_results_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->
