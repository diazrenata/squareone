Complete model results
================

  - [1. Versions](#versions)
  - [2. Energetic compensation GLS](#energetic-compensation-gls)
      - [Significance of terms](#significance-of-terms)
      - [Contrasts](#contrasts)
      - [Estimates](#estimates)
  - [3. Total energy ratio GLS](#total-energy-ratio-gls)
      - [Significance of effects](#significance-of-effects)
      - [Contrasts](#contrasts-1)
      - [Estimates](#estimates-1)
  - [4. Small granivore proportional energy use
    GLM](#small-granivore-proportional-energy-use-glm)
      - [Contrasts](#contrasts-2)
      - [Estimates](#estimates-2)
  - [5. C baileyi proportional abundance
    GLM](#c-baileyi-proportional-abundance-glm)
      - [Contrasts](#contrasts-3)
      - [Estimates](#estimates-3)
  - [6. E. ciculatum proportional abundance
    GLM](#e.-ciculatum-proportional-abundance-glm)
      - [Contrasts](#contrasts-4)
      - [Estimates](#estimates-4)

# 1\. Versions

All analyses were conducted in R version 4.0.3 on a MacBook Air running
macOS Catalina 10.15.7. Key statistical packages used are nlme 3.1-149
(Pinheiro et al. 2020) and emmeans 1.5.4 (Lenth 2021).

# 2\. Energetic compensation GLS

Compensation is calculated as `(SmallGranivoreEnergy_Exclosures -
SmallGranivoreEnergy_Controls) / KangarooRatEnergy_Controls` for each
census period.

Model call:

``` r
comp_gls <- gls(smgran_comp ~ era,  correlation = corCAR1(form = ~ period), data = compensation)
```

`period` refers to the census period.

## Significance of terms

Following
<https://stats.stackexchange.com/questions/13859/finding-overall-p-value-for-gls-model>,
we compare a version of the model with no fixed effect to the above
model. The two models are separated by 1 degree of freedom.

``` r
corValue <- intervals(comp_gls)$corStruct[2]

comp_int_gls <- gls(smgran_comp ~ 1, correlation = corCAR1(form = ~period, value = corValue, fixed = TRUE), data = compensation)

comp_gls_ml <- update(comp_gls, . ~ ., method = "ML")

comp_int_gls_ml <- update(comp_int_gls, . ~ ., method = "ML")

anova_table <- anova(comp_gls_ml, comp_int_gls_ml)

likR <- anova_table$L.Ratio[2]

# Likelihood ratio:

likR
```

    ## [1] 38.18461

``` r
# P value for the time period (era) effect:

pchisq(likR, 1, lower.tail = F)
```

    ## [1] 6.435788e-10

## Contrasts

``` r
comp_gls_emmeans <- emmeans(comp_gls, specs = ~ era)

comp_pairs <- as.data.frame(pairs(comp_gls_emmeans))

comp_pairs
```

<div class="kable-table">

| contrast                       |    estimate |        SE |       df |     t.ratio |   p.value |
| :----------------------------- | ----------: | --------: | -------: | ----------: | --------: |
| a\_pre\_pb - b\_pre\_reorg     | \-0.3596238 | 0.0644233 | 60.44042 | \-5.5822045 | 0.0000018 |
| a\_pre\_pb - c\_post\_reorg    | \-0.0296368 | 0.0691495 | 57.97849 | \-0.4285901 | 0.9038819 |
| b\_pre\_reorg - c\_post\_reorg |   0.3299870 | 0.0650229 | 62.66119 |   5.0749352 | 0.0000110 |

</div>

## Estimates

``` r
comp_estimates <- as.data.frame(comp_gls_emmeans)

comp_estimates
```

<div class="kable-table">

| era            |    emmean |        SE |       df |  lower.CL |  upper.CL |
| :------------- | --------: | --------: | -------: | --------: | --------: |
| a\_pre\_pb     | 0.1887873 | 0.0484923 | 56.08128 | 0.0916487 | 0.2859260 |
| b\_pre\_reorg  | 0.5484112 | 0.0432238 | 60.40971 | 0.4619628 | 0.6348595 |
| c\_post\_reorg | 0.2184241 | 0.0493101 | 59.73403 | 0.1197802 | 0.3170680 |

</div>

# 3\. Total energy ratio GLS

The ratio of total energy use on exclosure plots relative to controls,
calculated for each census period.

Model call:

``` r
totale_gls <- gls(total_e_rat ~  era,  correlation = corCAR1(form = ~ period), data = energy_ratio)
```

## Significance of effects

``` r
corValue <- intervals(totale_gls)$corStruct[2]

totale_int_gls <- gls(total_e_rat ~ 1, correlation = corCAR1(form = ~period, value = corValue, fixed = TRUE), data = energy_ratio)

totale_gls_ml <- update(totale_gls, . ~ ., method = "ML")

totale_int_gls_ml <- update(totale_int_gls, . ~ ., method = "ML")

anova_table <- anova(totale_gls_ml, totale_int_gls_ml)

likR <- anova_table$L.Ratio[2]

# Likelihood ratio:

likR
```

    ## [1] 40.28898

``` r
# P value for the time period (era) effect:

pchisq(likR, 1, lower.tail = F)
```

    ## [1] 2.190414e-10

## Contrasts

``` r
totale_gls_emmeans <- emmeans(totale_gls, specs = ~ era)

totale_contrasts <- as.data.frame(pairs(totale_gls_emmeans))

totale_contrasts
```

<div class="kable-table">

| contrast                       |    estimate |        SE |       df |    t.ratio |   p.value |
| :----------------------------- | ----------: | --------: | -------: | ---------: | --------: |
| a\_pre\_pb - b\_pre\_reorg     | \-0.3881293 | 0.0605211 | 40.83178 | \-6.413128 | 0.0000003 |
| a\_pre\_pb - c\_post\_reorg    | \-0.1666183 | 0.0655510 | 37.48394 | \-2.541812 | 0.0396518 |
| b\_pre\_reorg - c\_post\_reorg |   0.2215110 | 0.0608245 | 41.78673 |   3.641807 | 0.0020966 |

</div>

## Estimates

``` r
totale_pred <- as.data.frame(totale_gls_emmeans)

totale_pred
```

<div class="kable-table">

| era            |    emmean |        SE |       df |  lower.CL |  upper.CL |
| :------------- | --------: | --------: | -------: | --------: | --------: |
| a\_pre\_pb     | 0.2955610 | 0.0461672 | 36.54729 | 0.2019781 | 0.3891438 |
| b\_pre\_reorg  | 0.6836903 | 0.0407429 | 38.89409 | 0.6012729 | 0.7661077 |
| c\_post\_reorg | 0.4621793 | 0.0465896 | 38.01610 | 0.3678648 | 0.5564937 |

</div>

# 4\. Small granivore proportional energy use GLM

Energy use by small granivores as a proportion of treatment-level energy
use in each census period.

Model call:

``` r
smgran_glm <- glm(smgran_prop ~ oera * oplottype, family = quasibinomial(), data= smgran_dat)
```

`oera` is the time period, and `oplottype` is treatment.

``` r
summary(smgran_glm)
```

    ## 
    ## Call:
    ## glm(formula = smgran_prop ~ oera * oplottype, family = quasibinomial(), 
    ##     data = smgran_dat)
    ## 
    ## Deviance Residuals: 
    ##      Min        1Q    Median        3Q       Max  
    ## -1.43532  -0.24132   0.08354   0.39955   1.04138  
    ## 
    ## Coefficients:
    ##                    Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)         0.56734    0.05530  10.260  < 2e-16 ***
    ## oera.L              0.60675    0.09777   6.206 9.47e-10 ***
    ## oera.Q             -0.45238    0.09375  -4.826 1.73e-06 ***
    ## oplottype.L         2.78683    0.07820  35.636  < 2e-16 ***
    ## oera.L:oplottype.L -0.69768    0.13827  -5.046 5.80e-07 ***
    ## oera.Q:oplottype.L  0.18833    0.13258   1.421    0.156    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for quasibinomial family taken to be 0.1838797)
    ## 
    ##     Null deviance: 537.12  on 682  degrees of freedom
    ## Residual deviance: 121.81  on 677  degrees of freedom
    ##   (1 observation deleted due to missingness)
    ## AIC: NA
    ## 
    ## Number of Fisher Scoring iterations: 5

<!-- ## Significance of effects -->

<!-- ```{r} -->

<!-- smgran_nointeraction_glm<- glm(smgran_prop ~ oera + oplottype, family = quasibinomial(), data= smgran_dat) -->

<!-- smgran_era_glm<- glm(smgran_prop ~ oera, family = quasibinomial(), data= smgran_dat) -->

<!-- smgran_time_glm<- glm(smgran_prop ~ oera, family = quasibinomial(), data= smgran_dat) -->

<!-- smgran_intercept_glm<- glm(smgran_prop ~ 1, family = quasibinomial(), data= smgran_dat) -->

<!-- (anova(smgran_glm, smgran_nointeraction_glm, test = "Chisq")) -->

<!-- (anova(smgran_glm, smgran_era_glm, test = "Chisq")) -->

<!-- (anova(smgran_glm, smgran_time_glm, test = "Chisq")) -->

<!-- (anova(smgran_glm, smgran_intercept_glm, test = "Chisq")) -->

<!-- ``` -->

## Contrasts

``` r
smgran_emmeans <- (emmeans(smgran_glm, specs = ~ oera | oplottype))

smgran_contrasts <- as.data.frame(pairs(smgran_emmeans))
smgran_contrasts
```

<div class="kable-table">

| contrast                       | oplottype |    estimate |        SE |  df |     z.ratio |   p.value |
| :----------------------------- | :-------- | ----------: | --------: | --: | ----------: | --------: |
| a\_pre\_pb - b\_pre\_reorg     | CC        | \-1.4950249 | 0.1690498 | Inf | \-8.8436974 | 0.0000000 |
| a\_pre\_pb - c\_post\_reorg    | CC        | \-1.5557527 | 0.1741513 | Inf | \-8.9333383 | 0.0000000 |
| b\_pre\_reorg - c\_post\_reorg | CC        | \-0.0607279 | 0.1260275 | Inf | \-0.4818620 | 0.8798965 |
| a\_pre\_pb - b\_pre\_reorg     | EE        | \-0.4711439 | 0.2155610 | Inf | \-2.1856643 | 0.0736226 |
| a\_pre\_pb - c\_post\_reorg    | EE        | \-0.1603938 | 0.2148034 | Inf | \-0.7467004 | 0.7356211 |
| b\_pre\_reorg - c\_post\_reorg | EE        |   0.3107501 | 0.2297173 | Inf |   1.3527498 | 0.3660145 |

</div>

## Estimates

Estimates from `emmeans` differ numerically (in the far decimals) from
estimates obtained via `predict()` and back transformation. Below are
estimates from `emmeans`, because those are what are used for contrasts.
Estimates given on the response (not link) scale.

``` r
smgran_estimates <- as.data.frame(regrid(smgran_emmeans))

smgran_estimates
```

<div class="kable-table">

| oera           | oplottype |      prob |        SE |  df | asymp.LCL | asymp.UCL |
| :------------- | :-------- | --------: | --------: | --: | --------: | --------: |
| a\_pre\_pb     | CC        | 0.0816472 | 0.0109974 | Inf | 0.0600928 | 0.1032017 |
| b\_pre\_reorg  | CC        | 0.2839099 | 0.0170898 | Inf | 0.2504146 | 0.3174052 |
| c\_post\_reorg | CC        | 0.2964165 | 0.0195829 | Inf | 0.2580348 | 0.3347982 |
| a\_pre\_pb     | EE        | 0.9111217 | 0.0114288 | Inf | 0.8887217 | 0.9335218 |
| b\_pre\_reorg  | EE        | 0.9425976 | 0.0088160 | Inf | 0.9253185 | 0.9598767 |
| c\_post\_reorg | EE        | 0.9232823 | 0.0114700 | Inf | 0.9008015 | 0.9457631 |

</div>

Estimates from `predict`:

``` r
smgran_glm_se <- est_glm_ilink(smgran_glm, smgran_dat) %>%
  dplyr::select(-period, -censusdate) %>%
  dplyr::distinct()
```

    ## Joining, by = c("period", "oplottype")

``` r
smgran_glm_se
```

<div class="kable-table">

|         fit |    se.fit | residual.scale |       est |     lower |     upper | oplottype | oera           |
| ----------: | --------: | -------------: | --------: | --------: | --------: | :-------- | :------------- |
| \-2.4201739 | 0.1466690 |       0.428812 | 0.0816472 | 0.0621807 | 0.1065157 | CC        | a\_pre\_pb     |
|   2.3274089 | 0.1411329 |       0.428812 | 0.9111217 | 0.8854559 | 0.9314816 | EE        | a\_pre\_pb     |
| \-0.9251490 | 0.0840597 |       0.428812 | 0.2839099 | 0.2510033 | 0.3192915 | CC        | b\_pre\_reorg  |
|   2.7985528 | 0.1629357 |       0.428812 | 0.9425976 | 0.9222044 | 0.9578890 | EE        | b\_pre\_reorg  |
| \-0.8644212 | 0.0938983 |       0.428812 | 0.2964165 | 0.2587994 | 0.3370151 | CC        | c\_post\_reorg |
|   2.4878027 | 0.1619321 |       0.428812 | 0.9232823 | 0.8969641 | 0.9433030 | EE        | c\_post\_reorg |

</div>

# 5\. C baileyi proportional abundance GLM

Energy use by *C. baileyi* as a proportion of treatment-level energy use
in each census period. Because *C. baileyi* was absent from 1977-1996,
restricted to the second two time periods (July 1997-2020)

Model call:

``` r
pb_glm <- glm(pb_prop ~ oera * oplottype, family = quasibinomial(), data= pb_nozero)
```

`oera` is the time period, and `oplottype` is treatment.

``` r
summary(pb_glm)
```

    ## 
    ## Call:
    ## glm(formula = pb_prop ~ oera * oplottype, family = quasibinomial(), 
    ##     data = pb_nozero)
    ## 
    ## Deviance Residuals: 
    ##      Min        1Q    Median        3Q       Max  
    ## -0.77785  -0.23751  -0.07486   0.18362   1.66203  
    ## 
    ## Coefficients:
    ##                    Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)         -2.0044     0.1601 -12.523  < 2e-16 ***
    ## oera.L              -2.0922     0.2263  -9.243  < 2e-16 ***
    ## oplottype.L          2.7474     0.2263  12.138  < 2e-16 ***
    ## oera.L:oplottype.L   0.8987     0.3201   2.807  0.00521 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for quasibinomial family taken to be 0.1092629)
    ## 
    ##     Null deviance: 242.507  on 454  degrees of freedom
    ## Residual deviance:  51.407  on 451  degrees of freedom
    ##   (1 observation deleted due to missingness)
    ## AIC: NA
    ## 
    ## Number of Fisher Scoring iterations: 8

<!-- ## Significance of effects -->

<!-- ```{r} -->

<!-- pb_nointeraction_glm<- glm(pb_prop ~ oera + oplottype, family = quasibinomial(), data= pb_nozero) -->

<!-- pb_era_glm<- glm(pb_prop ~ oera, family = quasibinomial(), data= pb_nozero) -->

<!-- pb_time_glm<- glm(pb_prop ~ oera, family = quasibinomial(), data= pb_nozero) -->

<!-- pb_intercept_glm<- glm(pb_prop ~ 1, family = quasibinomial(), data= pb_nozero) -->

<!-- (anova(pb_glm, pb_nointeraction_glm, test = "Chisq")) -->

<!-- (anova(pb_glm, pb_era_glm, test = "Chisq")) -->

<!-- (anova(pb_glm, pb_time_glm, test = "Chisq")) -->

<!-- (anova(pb_glm, pb_intercept_glm, test = "Chisq")) -->

<!-- ``` -->

## Contrasts

``` r
pb_emmeans <- (emmeans(pb_glm, specs = ~ oera | oplottype))

pb_contrasts <- as.data.frame(pairs(pb_emmeans))
pb_contrasts
```

<div class="kable-table">

| contrast                       | oplottype | estimate |        SE |  df |   z.ratio | p.value |
| :----------------------------- | :-------- | -------: | --------: | --: | --------: | ------: |
| b\_pre\_reorg - c\_post\_reorg | CC        | 3.857543 | 0.6322409 | Inf |  6.101382 |       0 |
| b\_pre\_reorg - c\_post\_reorg | EE        | 2.060214 | 0.1007264 | Inf | 20.453577 |       0 |

</div>

## Estimates

Estimates from `emmeans` differ numerically (in the far decimals) from
estimates obtained via `predict()` and back transformation. Below are
estimates from `emmeans`, because those are what are used for contrasts.
Estimates given on the response (not link) scale.

``` r
pb_estimates <- as.data.frame(regrid(pb_emmeans))

pb_estimates
```

<div class="kable-table">

| oera           | oplottype |      prob |        SE |  df |   asymp.LCL | asymp.UCL |
| :------------- | :-------- | --------: | --------: | --: | ----------: | --------: |
| b\_pre\_reorg  | CC        | 0.1172888 | 0.0094009 | Inf |   0.0988634 | 0.1357142 |
| c\_post\_reorg | CC        | 0.0027984 | 0.0017460 | Inf | \-0.0006237 | 0.0062206 |
| b\_pre\_reorg  | EE        | 0.7248069 | 0.0130485 | Inf |   0.6992323 | 0.7503815 |
| c\_post\_reorg | EE        | 0.2512829 | 0.0144098 | Inf |   0.2230401 | 0.2795256 |

</div>

Estimates from `predict`:

``` r
pb_glm_se <- est_glm_ilink(pb_glm, pb_nozero) %>%
  dplyr::select(-period, -censusdate) %>%
  dplyr::distinct()
```

    ## Joining, by = c("period", "oplottype")

``` r
pb_glm_se
```

<div class="kable-table">

|         fit |    se.fit | residual.scale |       est |     lower |     upper | oplottype | oera           |
| ----------: | --------: | -------------: | --------: | --------: | --------: | :-------- | :------------- |
| \-2.0183586 | 0.0908017 |      0.3305494 | 0.1172888 | 0.0997539 | 0.1374355 | CC        | b\_pre\_reorg  |
|   0.9684323 | 0.0654186 |      0.3305494 | 0.7248069 | 0.6979585 | 0.7501232 | EE        | b\_pre\_reorg  |
| \-5.8759020 | 0.6256866 |      0.3305494 | 0.0027984 | 0.0008023 | 0.0097130 | CC        | c\_post\_reorg |
| \-1.0917821 | 0.0765911 |      0.3305494 | 0.2512829 | 0.2235731 | 0.2811833 | EE        | c\_post\_reorg |

</div>

# 6\. E. ciculatum proportional abundance GLM

*E. ciculatum* abundance as a proportion of total plant abundance for
each winter census.

Model call - note that an interaction between plot type and era is not
significant, so we drop it:

``` r
erod_glm <- glm(erod_treatment_prop_abundance ~ oplottype * oera, data = erodium_treatments_noz, family = quasibinomial())

summary(erod_glm)
```

    ## 
    ## Call:
    ## glm(formula = erod_treatment_prop_abundance ~ oplottype * oera, 
    ##     family = quasibinomial(), data = erodium_treatments_noz)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -1.0510  -0.2145  -0.1153   0.2447   0.8881  
    ## 
    ## Coefficients:
    ##                    Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)         -1.8645     0.2778  -6.711 1.86e-08 ***
    ## oplottype.L          1.1271     0.3929   2.869  0.00607 ** 
    ## oera.L               0.9523     0.5746   1.657  0.10384    
    ## oera.Q              -2.4553     0.3647  -6.732 1.72e-08 ***
    ## oplottype.L:oera.L  -0.1200     0.8126  -0.148  0.88321    
    ## oplottype.L:oera.Q   0.6096     0.5158   1.182  0.24292    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for quasibinomial family taken to be 0.1630108)
    ## 
    ##     Null deviance: 26.0828  on 54  degrees of freedom
    ## Residual deviance:  8.8253  on 49  degrees of freedom
    ## AIC: NA
    ## 
    ## Number of Fisher Scoring iterations: 7

``` r
erod_glm_nointeraction <-  glm(erod_treatment_prop_abundance ~ oplottype + oera, data = erodium_treatments_noz, family = quasibinomial())

(anova(erod_glm, erod_glm_nointeraction, test = "Chisq"))
```

<div class="kable-table">

| Resid. Df | Resid. Dev |  Df |    Deviance | Pr(\>Chi) |
| --------: | ---------: | --: | ----------: | --------: |
|        49 |   8.825256 |  NA |          NA |        NA |
|        51 |   9.125314 | \-2 | \-0.3000576 | 0.3983751 |

</div>

``` r
summary(erod_glm_nointeraction)
```

    ## 
    ## Call:
    ## glm(formula = erod_treatment_prop_abundance ~ oplottype + oera, 
    ##     family = quasibinomial(), data = erodium_treatments_noz)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -0.9996  -0.2698  -0.1459   0.1637   0.9504  
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  -1.7058     0.1990  -8.574 1.86e-11 ***
    ## oplottype.L   0.8185     0.2233   3.666 0.000587 ***
    ## oera.L        0.8626     0.3876   2.225 0.030516 *  
    ## oera.Q       -2.2667     0.2798  -8.100 1.01e-10 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for quasibinomial family taken to be 0.1646958)
    ## 
    ##     Null deviance: 26.0828  on 54  degrees of freedom
    ## Residual deviance:  9.1253  on 51  degrees of freedom
    ## AIC: NA
    ## 
    ## Number of Fisher Scoring iterations: 6

## Contrasts

``` r
erod_emmeans <- (emmeans(erod_glm_nointeraction, specs = ~ oera | oplottype))

erod_contrasts <- as.data.frame(pairs(erod_emmeans))

erod_contrasts
```

<div class="kable-table">

| contrast                       | oplottype |   estimate |        SE |  df |    z.ratio |   p.value |
| :----------------------------- | :-------- | ---------: | --------: | --: | ---------: | --------: |
| a\_pre\_pb - b\_pre\_reorg     | CC        | \-3.386130 | 0.5001406 | Inf | \-6.770356 | 0.0000000 |
| a\_pre\_pb - c\_post\_reorg    | CC        | \-1.219893 | 0.5482135 | Inf | \-2.225215 | 0.0669914 |
| b\_pre\_reorg - c\_post\_reorg | CC        |   2.166237 | 0.3674864 | Inf |   5.894741 | 0.0000000 |
| a\_pre\_pb - b\_pre\_reorg     | EE        | \-3.386130 | 0.5001406 | Inf | \-6.770356 | 0.0000000 |
| a\_pre\_pb - c\_post\_reorg    | EE        | \-1.219893 | 0.5482135 | Inf | \-2.225215 | 0.0669914 |
| b\_pre\_reorg - c\_post\_reorg | EE        |   2.166237 | 0.3674864 | Inf |   5.894741 | 0.0000000 |

</div>

## Estimates

Estimates from `emmeans` differ numerically (in the far decimals) from
estimates obtained via `predict()` and back transformation. Below are
estimates from `emmeans`, because those are what are used for contrasts.
Estimates given on the response (not link) scale.

``` r
erod_estimates <- as.data.frame(regrid(erod_emmeans))

erod_estimates
```

<div class="kable-table">

| oera           | oplottype |      prob |        SE |  df | asymp.LCL | asymp.UCL |
| :------------- | :-------- | --------: | --------: | --: | --------: | --------: |
| a\_pre\_pb     | CC        | 0.0214594 | 0.0107953 | Inf | 0.0003010 | 0.0426177 |
| b\_pre\_reorg  | CC        | 0.3932264 | 0.0578821 | Inf | 0.2797796 | 0.5066733 |
| c\_post\_reorg | CC        | 0.0691380 | 0.0243978 | Inf | 0.0213192 | 0.1169568 |
| a\_pre\_pb     | EE        | 0.0652294 | 0.0280600 | Inf | 0.0102329 | 0.1202260 |
| b\_pre\_reorg  | EE        | 0.6734300 | 0.0551609 | Inf | 0.5653165 | 0.7815435 |
| c\_post\_reorg | EE        | 0.1911589 | 0.0495320 | Inf | 0.0940780 | 0.2882398 |

</div>

Estimates from `predict`:

``` r
erod_glm_se <- est_glm_ilink(erod_glm, mutate(erodium_treatments_noz, period = year, censusdate = year)) %>%
  dplyr::select(-period, -censusdate) %>%
  dplyr::distinct()
```

    ## Joining, by = c("period", "oplottype")

``` r
erod_glm_se
```

<div class="kable-table">

|         fit |    se.fit | residual.scale |       est |     lower |     upper | oplottype | oera           |
| ----------: | --------: | -------------: | --------: | --------: | --------: | :-------- | :------------- |
| \-4.5732911 | 1.3382018 |      0.4037459 | 0.0102184 | 0.0007099 | 0.1304612 | CC        | a\_pre\_pb     |
| \-2.5073243 | 0.4837128 |      0.4037459 | 0.0753463 | 0.0300393 | 0.1765500 | EE        | a\_pre\_pb     |
| \-0.3048107 | 0.2583227 |      0.4037459 | 0.4243819 | 0.3054547 | 0.5527615 | CC        | b\_pre\_reorg  |
|   0.5852501 | 0.2663624 |      0.4037459 | 0.6422745 | 0.5131283 | 0.7536129 | EE        | b\_pre\_reorg  |
| \-3.1065053 | 0.7049325 |      0.4037459 | 0.0428397 | 0.0108105 | 0.1549046 | CC        | c\_post\_reorg |
| \-1.2805469 | 0.3460368 |      0.4037459 | 0.2174572 | 0.1221077 | 0.3569852 | EE        | c\_post\_reorg |

</div>
