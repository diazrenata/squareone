Replicating GAMS from 2019 paper
================

Messing with Erica’s analyses to improve my understanding of difference
smooths with by factors; also additional parametric terms.

Working only with krats - the point here is not interpretation, just
improving my familarity with the tools.

## Erica’s analysis

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
library(mgcv)
```

    ## Warning: package 'mgcv' was built under R version 4.0.3

    ## Loading required package: nlme

    ## 
    ## Attaching package: 'nlme'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     collapse

    ## This is mgcv 1.8-33. For overview type 'help("mgcv-package")'.

``` r
library(ggplot2)
library(cowplot)
```

    ## Warning: package 'cowplot' was built under R version 4.0.3

``` r
source(here::here("lore", "2020_switch", "FinalAnalysis", 'analysis_functions.R'))
theme_set(theme_bw())
#cbPalette <- c( "#e19c02","#999999", "#56B4E9", "#0072B2", "#D55E00", "#F0E442", "#009E73", "#CC79A7")
cbbPalette <- c("#000000", "#009E73", "#e79f00", "#9ad0f3", "#0072B2", "#D55E00", 
                "#CC79A7", "#F0E442")


# ==========================================================================================
# Number of dipodomys
dipo <- read.csv(here::here("lore", "2020_switch", "Data", "Dipo_counts.csv"))
dipo$censusdate <-as.Date(dipo$censusdate)

# create variables needed for GAM
dipo <- dplyr::mutate(dipo,
                 oTreatment = ordered(treatment, levels = c('CC','EC','XC')),
                 oPlot      = ordered(plot),
                 plot       = factor(plot))

# GAM model --- includes plot-specific smooths
dipo.gam <- gam(n ~ oPlot + oTreatment + s(numericdate, k = 20) +
                  s(numericdate, by = oTreatment, k = 15) +
                  s(numericdate, by = oPlot),
                data = dipo, method = 'REML', family = poisson, select = TRUE, control = gam.control(nthreads = 4))

# Look at the treatment effect smooths on count scale. 
# terms to exclude; must be named exactly as printed in `summary(model)` output
exVars.d <- c('oPlot', paste0('s(numericdate):oPlot', c(5,6,7,11,13,14,17,18,24)))
treatPred.dipo <- predict_treat_effect(dipo, np = 500, MODEL=dipo.gam, exVars.d)

# plot GAM fit and data
d.plt <- plot_gam_prediction(treatPred.dipo, dipo, Palette=cbbPalette[c(6,1,4)], ylab='Count')
d.plt
```

![](replication_offroad_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

``` r
#ggsave('Figures/dipo-treatment-effects.png', d.plt,width=6,height=2.5)

# Compute pairwise treatment diffs if we leave *in* the parametric Treatment terms
d1 <- osmooth_diff(dipo.gam, treatPred.dipo, "numericdate", "CC", "EC", var = "oTreatment", removePara = FALSE)
d2 <- osmooth_diff(dipo.gam, treatPred.dipo, "numericdate", "CC", "XC", var = "oTreatment", removePara = FALSE)
diffs.dipo <- rbind(d1, d2)

## difference of smooths
diffPlt <- plot_smooth_diff(diffs.dipo, Palette=cbbPalette[c(1,4)])
diffPlt
```

![](replication_offroad_files/figure-gfm/unnamed-chunk-1-2.png)<!-- -->

``` r
## Cowplot grid
dipo_plot = plot_grid(d.plt, diffPlt, labels = "AUTO", ncol = 1, align = 'v')
dipo_plot
```

![](replication_offroad_files/figure-gfm/unnamed-chunk-1-3.png)<!-- -->

``` r
library(gratia)
```

    ## Warning: package 'gratia' was built under R version 4.0.3

``` r
dipo <- dipo %>%
  mutate(treatment = as.factor(treatment))

dipo.gam.noplot <- gam(n ~ treatment + s(numericdate, by = treatment), data = dipo, family = "poisson")

draw(dipo.gam.noplot)
```

![](replication_offroad_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
dipo.gam.confint <- confint(dipo.gam.noplot, parm = "numericdate")

dipo.gam.diff <- difference_smooths(dipo.gam.noplot, smooth = "s(numericdate)")

ggplot(filter(dipo.gam.diff, level_1 != "EC"), aes(numericdate, diff, color = level_2, fill = level_2)) +
  geom_line() +
  geom_ribbon(aes(numericdate, ymin = lower, ymax = upper, fill = level_2), alpha = .5) +
  theme_bw() +
  scale_color_viridis_d(end = .8) +
  geom_hline(yintercept = 0)
```

![](replication_offroad_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->
