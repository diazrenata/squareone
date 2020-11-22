New plots with 81 data
================

![](gams_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

``` r
load_mgcv()

rat_totals <- rat_totals %>%
  mutate(brown_trtmnt = as.factor(brown_trtmnt))

sg <- filter(rat_totals, type == "small_granivore")

n_gam <- gam(nind ~  brown_trtmnt + s(period, by = brown_trtmnt), data = sg, method = "REML", family = "poisson")

draw(n_gam)
```

![](gams_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
n_gam_fitted <- add_fitted(sg, n_gam, value = "fitted")

ggplot(n_gam_fitted, aes(period, nind, color = brown_trtmnt)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  geom_line(aes(period, fitted, color = brown_trtmnt), size = 2) +
  scale_color_viridis_d(end = .8)
```

![](gams_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->

``` r
fitted_ci <- function(gam_obj, ndraws = 500, df, seed = 1977) {
  
  sampled_vals <- fitted_samples(gam_obj, n = ndraws, newdata = df, seed = seed)
  
  sampled_vals <- sampled_vals %>%
    group_by(row) %>%
    summarize(
      meanfit = mean(fitted),
      lowerfit = quantile(fitted, probs = .025),
      upperfit= quantile(fitted, probs = .975)
    ) %>%
    ungroup()
  
  df <- df %>%
    mutate(row = dplyr::row_number()) %>%
    left_join(sampled_vals)
  
  df  
}

n_gam_ci_manual <- fitted_ci(n_gam, df= sg)
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

    ## Joining, by = "row"

``` r
ggplot(n_gam_ci_manual, aes(period, nind, color = brown_trtmnt)) +
  geom_line() +
  geom_line(aes(period, meanfit)) +
  geom_ribbon(aes(period, ymin = lowerfit, ymax = upperfit, fill = brown_trtmnt), alpha = .5) +
  theme_bw()
```

![](gams_files/figure-gfm/unnamed-chunk-2-3.png)<!-- -->

``` r
n_gam_diff <- difference_smooths(n_gam, smooth = "s(period)")

ggplot(n_gam_diff, aes(period, diff)) +
  geom_line() +
  geom_ribbon(aes(period, ymin = lower,ymax= upper), alpha = .5)
```

![](gams_files/figure-gfm/unnamed-chunk-2-4.png)<!-- -->

I’m not sure what the difference is between,

`nind ~ brown_trtmnt + s(period, by = brown_trtmnt)`

`nind ~ s(period, by = brown_trtmnt)`

and even more complicated models, like including effects for plot or
somehow fitting all 3 types (krats, small granivores, and omnivores)
within the same model.

In this vein, I’m taking as my model Erica’s 2019 plot switch paper.
Relevant scripts here:

<https://github.com/emchristensen/PlotSwitch/blob/master/FinalAnalysis/rodent-GAM-analyses.R>

and

<https://github.com/emchristensen/PlotSwitch/blob/master/FinalAnalysis/analysis_functions.R>

These *do not use gratia* but are working towards something similar to
what I’m looking at:

  - Comparing **no rodents –\> all rodents** and **no krats –\> all
    rodents** plots. The “treatment effect” is the difference in the
    smooths between the manipulated plots and the control plots. The
    effect the paper is interested in is the difference in **that**
    difference between the manipulation types.
  - Looking at **abundance** responses for two groups, **kangaroo rats**
    and **small granivores**.
  - Kangaroo rats (DM, DO, DS) in order to capture how long it took
    krats to colonize the newly available plots to match controls,
    depending on whether other rodents were present or not.
  - Small granivores “because we expected inferior competitors to be
    displaced by the invasion of kangaroo rats”.
  - Results are not shown in the main text but described. “Before the
    switch, sg abundances were higher on krat removals than on controls.
    After all plots were converted to controls, sg abundances on both
    plot types quickly converged to control levels within a few months.
    The rapid decline in non krats is consistent with previous research
    showing that krats are behaviorally dominant over other rodents.
    Because differences in treatments in non krat species disappeared
    quickly, seems unlikely that direct interference with non krats
    explains the delay in recovery of krats on plots that had rodents
    present.”
  - The “small granivores” species list is longer than it was in 1981, I
    think because more species showed up as time went on.

Without, or rather **before** getting into the specific questions being
asked/comparisons being made, the 2019 analysis illustrates that we can
use GAMs and the difference in GAM smooths to

  - compare two time series to find when they diverge/converge
  - without making assumptions about the *form* of the timeseries
  - and possibly make reference to a reference state.

additionally,

  - we can include effects for plot
