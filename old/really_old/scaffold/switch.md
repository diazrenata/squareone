Energy plots
================

``` r
use_christensen_plots <- F
use_pre_switch <- F
library(mgcv)
```

    ## Loading required package: nlme

    ## 
    ## Attaching package: 'nlme'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     collapse

    ## This is mgcv 1.8-33. For overview type 'help("mgcv-package")'.

``` r
source(here::here("scaffold", "R", "gams_fxns_generalized.R"))

plot_totals <- get_rodent_data(use_christensen_plots = use_christensen_plots, return_plot = T, use_pre_switch = use_pre_switch) 
```

    ## Loading in data version 2.49.0

    ## Joining, by = "plot"

    ## `summarise()` has grouped output by 'period', 'censusdate', 'era'. You can override using the `.groups` argument.

``` r
plot_annuals <- plot_totals %>%
  mutate(censusdate = as.Date(censusdate)) %>%
  mutate(censusyear = as.integer(format.Date(censusdate, "%Y"))) %>%
  group_by(censusyear, plot, plot_type, era) %>%
  summarize(annual_total_e = mean(total_e),
            annual_smgran_e = mean(smgran_e),
            annual_tinygran_e = mean(tinygran_e),
            nsamples = length(unique(period)),
            nrows = dplyr::n()) %>%
  ungroup()
```

    ## `summarise()` has grouped output by 'censusyear', 'plot', 'plot_type'. You can override using the `.groups` argument.

These data are for comparing the switches.

``` r
ggplot(plot_annuals, aes(censusyear, annual_total_e, color = plot_type, group = plot)) +
  geom_line() +
  facet_grid(cols = vars(era), scales = "free_x", space = "free") +
  theme(legend.position = "top") +
  ggtitle("total e")
```

![](switch_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
ggplot(plot_annuals, aes(censusyear, annual_smgran_e, color = plot_type, group = plot)) +
  geom_line()+
  facet_grid(cols = vars(era), scales = "free_x", space = "free") +
  theme(legend.position = "top") +
  ggtitle("smgran e")
```

![](switch_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->

``` r
ggplot(plot_annuals, aes(censusyear, annual_tinygran_e, color = plot_type, group = plot)) +
  geom_line()+
  facet_grid(cols = vars(era), scales = "free_x", space = "free") +
  theme(legend.position = "top") +
  ggtitle("tinygran e")
```

![](switch_files/figure-gfm/unnamed-chunk-2-3.png)<!-- -->

``` r
total_e_gam <- gam(total_e ~ oplottype + s(period, k = 50) + s(period, by = oplottype, k = 50) + s(plot, bs = "re"), data = plot_totals, family = "tw")

total_e_pdat <- make_pdat(plot_totals, comparison_variable = "oplottype")

total_e_diff_ce <-get_exclosure_diff(total_e_gam, total_e_pdat, "oplottype", exclude = "s(plot)", rod_type = "CE", reference_level = 1, comparison_level = 2)

total_e_diff_ec <-get_exclosure_diff(total_e_gam, total_e_pdat, "oplottype", exclude = "s(plot)", rod_type = "EC", reference_level = 1, comparison_level = 3)

total_e_diff_ee <-get_exclosure_diff(total_e_gam, total_e_pdat, "oplottype", exclude = "s(plot)", rod_type = "EE", reference_level = 1, comparison_level = 4)

total_e_diffs <- bind_rows(total_e_diff_ce, total_e_diff_ec,total_e_diff_ee)

ggplot(total_e_diffs, aes(period, fitted_dif, color = type, fill = type)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .2)
```

![](switch_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

``` r
total_e_pred <- get_predicted_vals(total_e_gam, total_e_pdat, exclude = "s(plot)")%>% 
  dplyr::mutate(era = NA) %>%
    dplyr::mutate(era = ifelse(period <= 216, "a_pre_ba",
                               ifelse(period <= 380, "b_pre_cpt",
                                      ifelse(period <= 434, "c_pre_switch", "d_post-switch")))) 

plot_fitted_pred(total_e_pred, "oplottype") +
  facet_grid(cols=  vars(era), scales = "free_x", space = "free")
```

![](switch_files/figure-gfm/unnamed-chunk-3-2.png)<!-- -->

``` r
smgran_e_gam <- gam(smgran_e ~ oplottype + s(period, k = 50) + s(period, by = oplottype, k = 50) + s(plot, bs = "re"), data = plot_totals, family = "tw")

smgran_e_pdat <- make_pdat(plot_totals, comparison_variable = "oplottype")

smgran_e_diff_ce <-get_exclosure_diff(smgran_e_gam, smgran_e_pdat, "oplottype", exclude = "s(plot)", rod_type = "CE", reference_level = 1, comparison_level = 2)

smgran_e_diff_ec <-get_exclosure_diff(smgran_e_gam, smgran_e_pdat, "oplottype", exclude = "s(plot)", rod_type = "EC", reference_level = 1, comparison_level = 3)

smgran_e_diff_ee <-get_exclosure_diff(smgran_e_gam, smgran_e_pdat, "oplottype", exclude = "s(plot)", rod_type = "EE", reference_level = 1, comparison_level = 4)

smgran_e_diffs <- bind_rows(smgran_e_diff_ce, smgran_e_diff_ec,smgran_e_diff_ee)

ggplot(smgran_e_diffs, aes(period, fitted_dif, color = type, fill = type)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .2)
```

![](switch_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
smgran_e_pred <- get_predicted_vals(smgran_e_gam, smgran_e_pdat, exclude = "s(plot)")%>% 
  dplyr::mutate(era = NA) %>%
    dplyr::mutate(era = ifelse(period <= 216, "a_pre_ba",
                               ifelse(period <= 380, "b_pre_cpt",
                                      ifelse(period <= 434, "c_pre_switch", "d_post-switch")))) 

plot_fitted_pred(smgran_e_pred, "oplottype") +
  facet_grid(cols=  vars(era), scales = "free_x", space = "free")
```

![](switch_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->

``` r
tinygran_e_gam <- gam(tinygran_e ~ oplottype + s(period, k = 50) + s(period, by = oplottype, k = 50) + s(plot, bs = "re"), data = plot_totals, family = "tw")

tinygran_e_pdat <- make_pdat(plot_totals, comparison_variable = "oplottype")

tinygran_e_diff_ce <-get_exclosure_diff(tinygran_e_gam, tinygran_e_pdat, "oplottype", exclude = "s(plot)", rod_type = "CE", reference_level = 1, comparison_level = 2)

tinygran_e_diff_ec <-get_exclosure_diff(tinygran_e_gam, tinygran_e_pdat, "oplottype", exclude = "s(plot)", rod_type = "EC", reference_level = 1, comparison_level = 3)

tinygran_e_diff_ee <-get_exclosure_diff(tinygran_e_gam, tinygran_e_pdat, "oplottype", exclude = "s(plot)", rod_type = "EE", reference_level = 1, comparison_level = 4)

tinygran_e_diffs <- bind_rows(tinygran_e_diff_ce, tinygran_e_diff_ec,tinygran_e_diff_ee)

ggplot(tinygran_e_diffs, aes(period, fitted_dif, color = type, fill = type)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .2)
```

![](switch_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
tinygran_e_pred <- get_predicted_vals(tinygran_e_gam, tinygran_e_pdat, exclude = "s(plot)")%>% 
  dplyr::mutate(era = NA) %>%
    dplyr::mutate(era = ifelse(period <= 216, "a_pre_ba",
                               ifelse(period <= 380, "b_pre_cpt",
                                      ifelse(period <= 434, "c_pre_switch", "d_post-switch")))) 

plot_fitted_pred(tinygran_e_pred, "oplottype") +
  facet_grid(cols=  vars(era), scales = "free_x", space = "free")
```

![](switch_files/figure-gfm/unnamed-chunk-5-2.png)<!-- -->

``` r
library(lme4) 
```

    ## Loading required package: Matrix

    ## 
    ## Attaching package: 'lme4'

    ## The following object is masked from 'package:nlme':
    ## 
    ##     lmList

``` r
library(emmeans)

plot_totals <- plot_totals %>%
  mutate(total_e_int = ceiling(total_e),
         smgran_e_int = ceiling(smgran_e),
         tinygran_e_int = ceiling(tinygran_e))
```

``` r
total_e_glm <- glmer(total_e_int ~ oplottype * era + (1 | plot), data = plot_totals, family = poisson)
```

    ## Warning in checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv, : Model is nearly unidentifiable: very large eigenvalue
    ##  - Rescale variables?

``` r
plot(pairs(emmeans(total_e_glm, ~ oplottype | era)))
```

![](switch_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

``` r
plot(regrid(emmeans(total_e_glm, ~ oplottype | era)))
```

![](switch_files/figure-gfm/unnamed-chunk-7-2.png)<!-- -->

``` r
smgran_e_glm <- glmer(smgran_e_int ~ oplottype * era + (1 | plot), data = plot_totals, family = poisson)

plot(pairs(emmeans(smgran_e_glm, ~ oplottype | era)))
```

![](switch_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

``` r
plot(regrid(emmeans(smgran_e_glm, ~ oplottype | era)))
```

![](switch_files/figure-gfm/unnamed-chunk-8-2.png)<!-- -->

``` r
tinygran_e_glm <- glmer(tinygran_e_int ~ oplottype * era + (1 | plot), data = plot_totals, family = poisson)

plot(pairs(emmeans(tinygran_e_glm, ~ oplottype | era)))
```

![](switch_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

``` r
plot(regrid(emmeans(tinygran_e_glm, ~ oplottype | era)))
```

![](switch_files/figure-gfm/unnamed-chunk-9-2.png)<!-- -->

``` r
plot_totals_short <- filter(plot_totals, era %in% c("c_pre_switch", "d_post-switch"))
```

``` r
total_e_short_gam <- gam(total_e ~ oplottype + s(period, k = 50) + s(period, by = oplottype, k = 50) + s(plot, bs = "re"), data = plot_totals_short, family = "tw")

total_e_short_pdat <- make_pdat(plot_totals_short, comparison_variable = "oplottype")

total_e_short_diff_ce <-get_exclosure_diff(total_e_short_gam, total_e_short_pdat, "oplottype", exclude = "s(plot)", rod_type = "CE", reference_level = 1, comparison_level = 2)

total_e_short_diff_ec <-get_exclosure_diff(total_e_short_gam, total_e_short_pdat, "oplottype", exclude = "s(plot)", rod_type = "EC", reference_level = 1, comparison_level = 3)

total_e_short_diff_ee <-get_exclosure_diff(total_e_short_gam, total_e_short_pdat, "oplottype", exclude = "s(plot)", rod_type = "EE", reference_level = 1, comparison_level = 4)

total_e_short_diffs <- bind_rows(total_e_short_diff_ce, total_e_short_diff_ec,total_e_short_diff_ee)

ggplot(total_e_short_diffs, aes(period, fitted_dif, color = type, fill = type)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .2)
```

![](switch_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

``` r
total_e_short_pred <- get_predicted_vals(total_e_short_gam, total_e_short_pdat, exclude = "s(plot)")%>% 
  dplyr::mutate(era = NA) %>%
    dplyr::mutate(era = ifelse(period <= 216, "a_pre_ba",
                               ifelse(period <= 380, "b_pre_cpt",
                                      ifelse(period <= 434, "c_pre_switch", "d_post-switch")))) 

plot_fitted_pred(total_e_short_pred, "oplottype") +
  facet_grid(cols=  vars(era), scales = "free_x", space = "free")
```

![](switch_files/figure-gfm/unnamed-chunk-11-2.png)<!-- -->

``` r
smgran_e_short_gam <- gam(smgran_e ~ oplottype + s(period, k = 50) + s(period, by = oplottype, k = 50) + s(plot, bs = "re"), data = plot_totals_short, family = "tw")

smgran_e_short_pdat <- make_pdat(plot_totals_short, comparison_variable = "oplottype")

smgran_e_short_diff_ce <-get_exclosure_diff(smgran_e_short_gam, smgran_e_short_pdat, "oplottype", exclude = "s(plot)", rod_type = "CE", reference_level = 1, comparison_level = 2)

smgran_e_short_diff_ec <-get_exclosure_diff(smgran_e_short_gam, smgran_e_short_pdat, "oplottype", exclude = "s(plot)", rod_type = "EC", reference_level = 1, comparison_level = 3)

smgran_e_short_diff_ee <-get_exclosure_diff(smgran_e_short_gam, smgran_e_short_pdat, "oplottype", exclude = "s(plot)", rod_type = "EE", reference_level = 1, comparison_level = 4)

smgran_e_short_diffs <- bind_rows(smgran_e_short_diff_ce, smgran_e_short_diff_ec,smgran_e_short_diff_ee)

ggplot(smgran_e_short_diffs, aes(period, fitted_dif, color = type, fill = type)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .2)
```

![](switch_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

``` r
smgran_e_short_pred <- get_predicted_vals(smgran_e_short_gam, smgran_e_short_pdat, exclude = "s(plot)")%>% 
  dplyr::mutate(era = NA) %>%
    dplyr::mutate(era = ifelse(period <= 216, "a_pre_ba",
                               ifelse(period <= 380, "b_pre_cpt",
                                      ifelse(period <= 434, "c_pre_switch", "d_post-switch")))) 

plot_fitted_pred(smgran_e_short_pred, "oplottype") +
  facet_grid(cols=  vars(era), scales = "free_x", space = "free")
```

![](switch_files/figure-gfm/unnamed-chunk-12-2.png)<!-- -->

``` r
tinygran_e_short_gam <- gam(tinygran_e ~ oplottype + s(period, k = 50) + s(period, by = oplottype, k = 50) + s(plot, bs = "re"), data = plot_totals_short, family = "tw")

tinygran_e_short_pdat <- make_pdat(plot_totals_short, comparison_variable = "oplottype")

tinygran_e_short_diff_ce <-get_exclosure_diff(tinygran_e_short_gam, tinygran_e_short_pdat, "oplottype", exclude = "s(plot)", rod_type = "CE", reference_level = 1, comparison_level = 2)

tinygran_e_short_diff_ec <-get_exclosure_diff(tinygran_e_short_gam, tinygran_e_short_pdat, "oplottype", exclude = "s(plot)", rod_type = "EC", reference_level = 1, comparison_level = 3)

tinygran_e_short_diff_ee <-get_exclosure_diff(tinygran_e_short_gam, tinygran_e_short_pdat, "oplottype", exclude = "s(plot)", rod_type = "EE", reference_level = 1, comparison_level = 4)

tinygran_e_short_diffs <- bind_rows(tinygran_e_short_diff_ce, tinygran_e_short_diff_ec,tinygran_e_short_diff_ee)

ggplot(tinygran_e_short_diffs, aes(period, fitted_dif, color = type, fill = type)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .2)
```

![](switch_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

``` r
tinygran_e_short_pred <- get_predicted_vals(tinygran_e_short_gam, tinygran_e_short_pdat, exclude = "s(plot)")%>% 
  dplyr::mutate(era = NA) %>%
    dplyr::mutate(era = ifelse(period <= 216, "a_pre_ba",
                               ifelse(period <= 380, "b_pre_cpt",
                                      ifelse(period <= 434, "c_pre_switch", "d_post-switch")))) 

plot_fitted_pred(tinygran_e_short_pred, "oplottype") +
  facet_grid(cols=  vars(era), scales = "free_x", space = "free")
```

![](switch_files/figure-gfm/unnamed-chunk-13-2.png)<!-- -->

``` r
total_e_short_glm <- glmer(total_e_int ~ oplottype * era + (1 | plot), data = plot_totals_short, family = poisson)

plot(pairs(emmeans(total_e_short_glm, ~ oplottype | era)))
```

![](switch_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

``` r
plot(regrid(emmeans(total_e_short_glm, ~ oplottype | era)))
```

![](switch_files/figure-gfm/unnamed-chunk-14-2.png)<!-- -->

``` r
smgran_e_short_glm <- glmer(smgran_e_int ~ oplottype * era + (1 | plot), data = plot_totals_short, family = poisson)

plot(pairs(emmeans(smgran_e_short_glm, ~ oplottype | era)))
```

![](switch_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

``` r
plot(regrid(emmeans(smgran_e_short_glm, ~ oplottype | era)))
```

![](switch_files/figure-gfm/unnamed-chunk-15-2.png)<!-- -->

``` r
tinygran_e_short_glm <- glmer(tinygran_e_int ~ oplottype * era + (1 | plot), data = plot_totals_short, family = poisson)

plot(pairs(emmeans(tinygran_e_short_glm, ~ oplottype | era)))
```

![](switch_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

``` r
plot(regrid(emmeans(tinygran_e_short_glm, ~ oplottype | era)))
```

![](switch_files/figure-gfm/unnamed-chunk-16-2.png)<!-- -->
