PB
================
Renata Diaz
2021-04-01

  - [models](#models)

``` r
plot_ps <- get_plot_totals(use_pre_switch = F)
```

    ## Loading in data version 2.49.0

    ## Joining, by = "plot"

``` r
treat_ps <- get_treatment_means(use_pre_switch = F) 
```

    ## Loading in data version 2.49.0
    ## Joining, by = "plot"

``` r
ggplot(filter(plot_ps), aes(censusdate, pb_e_ma,group = plot, color = oplottype)) +
  geom_line() +
  facet_wrap(vars(oplottype)) +
  ggtitle("PB - all time")
```

![](pb_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
ggplot(filter(plot_ps, as.numeric(oera) > 2), aes(censusdate, pb_e_ma,group = plot, color = oplottype)) +
  geom_line() +
  facet_wrap(vars(oplottype)) +
  ggtitle("PB - since 2010ish")
```

![](pb_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->

``` r
ggplot(filter(plot_ps), aes(censusdate, pb_e_ma/total_e_ma,group = plot, color = oplottype)) +
  geom_line() +
  facet_wrap(vars(oplottype)) +
  ggtitle("PB as percent of plot energy - all time") +
  geom_line(data = filter(treat_ps), aes(censusdate, pb_e_ma/total_e_ma, color = oplottype), inherit.aes = F, size = 2)
```

![](pb_files/figure-gfm/unnamed-chunk-2-3.png)<!-- -->

``` r
ggplot(filter(plot_ps, as.numeric(oera) > 2), aes(censusdate, pb_e_ma / total_e_ma,group = plot, color = oplottype)) +
  geom_line() +
  facet_wrap(vars(oplottype)) +
  ggtitle("PB as percent of plot energy - since 2010ish") +
  geom_line(data = filter(treat_ps, as.numeric(oera) > 2), aes(censusdate, pb_e_ma/total_e_ma, color = oplottype), inherit.aes = F, size = 2)
```

![](pb_files/figure-gfm/unnamed-chunk-2-4.png)<!-- -->

### models

``` r
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
library(gratia)
library(emmeans)

plot_ps_pb <- plot_ps %>%
  mutate(pb_prop = pb_e / total_e) %>%
  filter(as.numeric(oera) > 1) %>%
  mutate(pb_prop = ifelse(is.nan(pb_prop), 0, pb_prop),
         row = dplyr::row_number())

qbin_int_gam <- gam(pb_prop ~ oera * oplottype + s(fplot, bs = "re"), family = quasibinomial(), data= plot_ps_pb)

qbin_int_gam_fit <- plot_ps_pb %>%
  add_fitted(qbin_int_gam, exclude = "s(fplot)")

ggplot(qbin_int_gam_fit, aes(censusdate, .value, color = oplottype)) +
  geom_line()
```

![](pb_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

``` r
pairs(emmeans(qbin_int_gam, specs = ~ oera | oplottype))
```

    ## NOTE: A nesting structure was detected in the fitted model:
    ##     fplot %in% oplottype

    ## oplottype = CC:
    ##  contrast                       estimate      SE   df t.ratio p.value
    ##  b_pre_cpt - c_pre_switch        3.20256       1 3502  5.021  <.0001 
    ##  b_pre_cpt - (d_post-switch)    32.45665 3331977 3502  0.000  1.0000 
    ##  c_pre_switch - (d_post-switch) 29.25409 3331977 3502  0.000  1.0000 
    ## 
    ## oplottype = CE:
    ##  contrast                       estimate      SE   df t.ratio p.value
    ##  b_pre_cpt - c_pre_switch        1.71143       0 3502  9.758  <.0001 
    ##  b_pre_cpt - (d_post-switch)     1.71531       0 3502  8.588  <.0001 
    ##  c_pre_switch - (d_post-switch)  0.00387       0 3502  0.016  0.9999 
    ## 
    ## oplottype = EC:
    ##  contrast                       estimate      SE   df t.ratio p.value
    ##  b_pre_cpt - c_pre_switch        2.02833       0 3502 14.071  <.0001 
    ##  b_pre_cpt - (d_post-switch)     4.67326       0 3502  9.930  <.0001 
    ##  c_pre_switch - (d_post-switch)  2.64493       0 3502  5.465  <.0001 
    ## 
    ## oplottype = EE:
    ##  contrast                       estimate      SE   df t.ratio p.value
    ##  b_pre_cpt - c_pre_switch        2.12053       0 3502 17.582  <.0001 
    ##  b_pre_cpt - (d_post-switch)     2.38736       0 3502 16.380  <.0001 
    ##  c_pre_switch - (d_post-switch)  0.26682       0 3502  1.578  0.2551 
    ## 
    ## Results are averaged over the levels of: fplot 
    ## Results are given on the log odds ratio (not the response) scale. 
    ## P value adjustment: tukey method for comparing a family of 3 estimates

``` r
plot(regrid(emmeans(qbin_int_gam, specs = ~ oera | oplottype)))
```

    ## NOTE: A nesting structure was detected in the fitted model:
    ##     fplot %in% oplottype

![](pb_files/figure-gfm/unnamed-chunk-3-2.png)<!-- -->

GLM:

``` r
qbin_glm <- glm(pb_prop ~ oera * oplottype, family = quasibinomial(), data= plot_ps_pb)

summary(qbin_glm)
```

    ## 
    ## Call:
    ## glm(formula = pb_prop ~ oera * oplottype, family = quasibinomial(), 
    ##     data = plot_ps_pb)
    ## 
    ## Deviance Residuals: 
    ##      Min        1Q    Median        3Q       Max  
    ## -1.39247  -0.47842  -0.09665   0.39033   2.11078  
    ## 
    ## Coefficients:
    ##                    Estimate Std. Error t value Pr(>|t|)
    ## (Intercept)         -3.1642    16.6790  -0.190    0.850
    ## oera.L              -4.2092    35.3813  -0.119    0.905
    ## oera.Q              -0.6505    20.4279  -0.032    0.975
    ## oplottype.L          4.9195    44.7544   0.110    0.912
    ## oplottype.Q         -3.0243    33.3580  -0.091    0.928
    ## oplottype.C          1.7550    14.9186   0.118    0.906
    ## oera.L:oplottype.L   5.7965    94.9378   0.061    0.951
    ## oera.Q:oplottype.L   2.7201    54.8136   0.050    0.960
    ## oera.L:oplottype.Q  -3.9881    70.7627  -0.056    0.955
    ## oera.Q:oplottype.Q  -1.7008    40.8558  -0.042    0.967
    ## oera.L:oplottype.C   3.5343    31.6469   0.112    0.911
    ## oera.Q:oplottype.C   1.5858    18.2721   0.087    0.931
    ## 
    ## (Dispersion parameter for quasibinomial family taken to be 0.3992711)
    ## 
    ##     Null deviance: 2558.1  on 3524  degrees of freedom
    ## Residual deviance: 1530.8  on 3513  degrees of freedom
    ## AIC: NA
    ## 
    ## Number of Fisher Scoring iterations: 16

The above GLM struggles, I think because the controls in d are literally
all 0. One could either remove just that time period for controls, or
remove controls wholesale.

``` r
qbin_glm_noctrl <- glm(pb_prop ~ oera * oplottype, family = quasibinomial(), data= filter(plot_ps_pb, oplottype != "CC"))

qbin_glm_nocd <- glm(pb_prop ~ oera * oplottype, family = quasibinomial(), data= filter(plot_ps_pb, paste0(oplottype, oera) != "CCd_post-switch"))

plot(pairs(emmeans(qbin_glm_noctrl, specs = ~ oera | oplottype)))
```

![](pb_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
plot(pairs(emmeans(qbin_glm_nocd, specs = ~ oera | oplottype)))
```

    ## Warning: Removed 2 rows containing missing values (geom_point).

    ## Warning: Removed 2 rows containing missing values (geom_segment).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](pb_files/figure-gfm/unnamed-chunk-5-2.png)<!-- -->

It literally doesn’t matter which you do, so I’m gonna go with no
controls at all because the piecewise removal creeps me out.

``` r
ilink <- qbin_glm$family$linkinv

qbin_glm_se <- predict(qbin_glm_noctrl, type = "link", se.fit = T, newdata = filter(plot_ps_pb, oplottype != "CC")) %>%
  as.data.frame() %>%
  mutate(est = ilink(fit),
         lower = ilink(fit - 2*se.fit),
         upper = ilink(fit + 2*se.fit),
         period = filter(plot_ps_pb, oplottype != "CC")$period,
         oplottype = filter(plot_ps_pb, oplottype != "CC")$oplottype)


ggplot(qbin_glm_se, aes(period, est, color = oplottype, fill = oplottype)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax= upper), alpha = .3)
```

![](pb_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

``` r
qbin_glm_se <- qbin_glm_se %>%
  right_join(select(plot_ps_pb, oera, oplottype, period))
```

    ## Joining, by = c("period", "oplottype")

``` r
qbin_glm_se %>%
  select(oera, oplottype, est, lower, upper) %>%
  distinct() %>%
  arrange(oplottype, oera)
```

<div class="kable-table">

| oera           | oplottype |       est |     lower |     upper |
| :------------- | :-------- | --------: | --------: | --------: |
| b\_pre\_cpt    | CC        |        NA |        NA |        NA |
| c\_pre\_switch | CC        |        NA |        NA |        NA |
| d\_post-switch | CC        |        NA |        NA |        NA |
| b\_pre\_cpt    | CE        | 0.3773377 | 0.3456416 | 0.4101188 |
| c\_pre\_switch | CE        | 0.1081368 | 0.0782210 | 0.1476612 |
| d\_post-switch | CE        | 0.1077759 | 0.0740331 | 0.1543347 |
| b\_pre\_cpt    | EC        | 0.6207243 | 0.5879197 | 0.6524612 |
| c\_pre\_switch | EC        | 0.1793774 | 0.1407084 | 0.2258798 |
| d\_post-switch | EC        | 0.0153667 | 0.0054865 | 0.0422832 |
| b\_pre\_cpt    | EE        | 0.5917202 | 0.5661429 | 0.6168103 |
| c\_pre\_switch | EE        | 0.1768627 | 0.1464487 | 0.2120239 |
| d\_post-switch | EE        | 0.1436942 | 0.1122944 | 0.1820731 |

</div>

``` r
treat_ps %>%
  group_by(oera, oplottype) %>%
  summarize(mean_pb_prop = mean(pb_e / total_e, na.rm = T)) %>%
  ungroup() %>%
  arrange(oplottype, oera)
```

    ## `summarise()` has grouped output by 'oera'. You can override using the `.groups` argument.

<div class="kable-table">

| oera           | oplottype | mean\_pb\_prop |
| :------------- | :-------- | -------------: |
| a\_pre\_ba     | CC        |      0.0000000 |
| b\_pre\_cpt    | CC        |      0.1046083 |
| c\_pre\_switch | CC        |      0.0046035 |
| d\_post-switch | CC        |      0.0000000 |
| a\_pre\_ba     | CE        |      0.0004537 |
| b\_pre\_cpt    | CE        |      0.3667359 |
| c\_pre\_switch | CE        |      0.1072642 |
| d\_post-switch | CE        |      0.1273288 |
| a\_pre\_ba     | EC        |      0.0009833 |
| b\_pre\_cpt    | EC        |      0.6523698 |
| c\_pre\_switch | EC        |      0.2174779 |
| d\_post-switch | EC        |      0.0148593 |
| a\_pre\_ba     | EE        |      0.0000000 |
| b\_pre\_cpt    | EE        |      0.6541999 |
| c\_pre\_switch | EE        |      0.2246082 |
| d\_post-switch | EE        |      0.2481597 |

</div>

KKKK, the above code is a mess, but things I think I’m learning…

  - PB has declined sitewide, raw and as a proportion of total energy
    use.
  - It is now totally absent on control plots.
  - There are a lot of modeling options and none of them are perfect.
    Some notes on the considerations: -\~ The GAMs fit with a smooth for
    period and a random effect for plot were doing a really bad job;
    they’d fit control higher than any other treatment even though
    that’s just Wrong. This might be fixable by increasing the k for
    the period smooth, but I haven’t gone deep in there because models
    with high k take a while to run and this isn’t exactly what I’m
    trying to learn right now.\~ I think this is because I wasn’t
    including a parametric term for the factor.
      - I’ve been working with both betar() and quasibinomial() as
        GAM/GLM families. I think they give essentially the same results
        in this application, but haven’t tested extensively.

What I really wanted to know was,

how much energy is PB using *now* on exclosures vs. when it was more
dominant? And that looks like, an estimate now of about 14-18% post-2010
compared to about 60% pre-2010. If you don’t take into account plot
variation, and work just with the treatment means, that’s about 24%
post-2010. Compared to, essentially none on control plots. (Although
note, oddly enough, it was more abundant on C –\> E plots prior to the
switch than on C –\> C plots. I see this a bunch and I think it means we
can’t use those plots to get at priority effects.)

Since I’ve been working with GLS (allows for autocorr) in the ratios…

``` r
library(nlme)

treat_ps <- treat_ps %>%
  mutate(pb_prop = pb_e / total_e) %>%
  group_by_all() %>%
  mutate(pb_prop = ifelse(is.na(pb_prop), 0, pb_prop)) %>%
  ungroup()

pb_treat <- filter(treat_ps, as.numeric(oera) != 1) %>%
  filter(oplottype != "CC")

pb_gls <- gls(pb_prop ~ plot_type * era, correlation = corAR1(form = ~ period | plot_type), data = pb_treat)

plot(emmeans(pb_gls, specs = ~ era | plot_type))
```

![](pb_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

``` r
plot(pairs(emmeans(pb_gls, specs = ~ era | plot_type)))
```

![](pb_files/figure-gfm/unnamed-chunk-7-2.png)<!-- -->

The GLS makes some negative predictions for near zero values. It pushes
the contrast for c-d for EC to not sig.

The directly comparable model would be a GLM on treatment means. Again,
including controls in d makes the CIs huge.

``` r
pb_treat <- filter(treat_ps, as.numeric(oera) != 1) %>%
  filter(paste0(oplottype, oera) != "CCd_post-switch")  %>%
  group_by(oplottype) %>%
  mutate(pb_prop_ma = maopts(pb_prop)) %>%
  ungroup()

glm_treat <- glm(pb_prop ~ oera * oplottype, family = quasibinomial(), data= pb_treat)

plot(pairs(emmeans(glm_treat, specs = ~ oera | oplottype)))
```

    ## Warning: Removed 2 rows containing missing values (geom_point).

    ## Warning: Removed 2 rows containing missing values (geom_segment).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](pb_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

``` r
plot(regrid(emmeans(glm_treat, specs = ~ oera | oplottype)))
```

    ## Warning: Removed 1 rows containing missing values (geom_point).

    ## Warning: Removed 1 rows containing missing values (geom_segment).

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](pb_files/figure-gfm/unnamed-chunk-8-2.png)<!-- -->

``` r
ilink <- glm_treat$family$linkinv

glm_treat_se <- predict(glm_treat, type = "link", se.fit = T, newdata = pb_treat) %>%
  as.data.frame() %>%
  mutate(est = ilink(fit),
         lower = ilink(fit - 2*se.fit),
         upper = ilink(fit + 2*se.fit),
         period = filter(pb_treat)$period,
         oplottype = filter(pb_treat)$oplottype)
```

    ## Warning in predict.lm(object, newdata, se.fit, scale = residual.scale, type = if
    ## (type == : prediction from a rank-deficient fit may be misleading

``` r
ggplot(glm_treat_se, aes(period, est, color = oplottype, fill = oplottype)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax= upper), alpha = .3)
```

![](pb_files/figure-gfm/unnamed-chunk-8-3.png)<!-- -->

``` r
glm_treat_se <- glm_treat_se %>%
  right_join(select(pb_treat, oera, oplottype, period, censusdate, pb_prop_ma))
```

    ## Joining, by = c("period", "oplottype")

``` r
ggplot(glm_treat_se, aes(censusdate, est, color = oplottype, fill = oplottype)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax= upper), alpha = .3) +
  geom_line(aes(y = pb_prop_ma)) +
  facet_grid(cols = vars(oera), space = "free_x", scales = "free_x") +
  ylab("PB % of energy use") +
  ggtitle("PB ratio over time") +
  theme(legend.position = "top")
```

![](pb_files/figure-gfm/unnamed-chunk-8-4.png)<!-- -->
