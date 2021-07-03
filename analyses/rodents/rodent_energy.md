Rodent energy use results
================

  - [Overview of compositonal shift](#overview-of-compositonal-shift)
  - [Energy variables](#energy-variables)
      - [PB over time](#pb-over-time)
      - [Smgran over time](#smgran-over-time)
      - [Compensation](#compensation)
      - [Treatment:control total E
        ratio](#treatmentcontrol-total-e-ratio)

# Overview of compositonal shift

![](rodent_energy_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

Small granivore (gold) and PB (blue) energy use as a proportion of the
total energy use, all on control plots. The remainder is kangaroo rats.

1.  PB is now essentially absent on controls.
2.  Small granivores now account for a greater proportion of total
    energy use on control plots than prior to PB’s establishment, even
    now that PB has declined.

# Energy variables

Lines are 6-month moving averages. Horizontal lines + ribbons are means
and SE or CL from GLM or GLS.

## PB over time

PB energy use as a proportion of treatment-level totals on controls and
exclosures.

    ## Joining, by = c("period", "oplottype")
    ## Joining, by = c("period", "oplottype")

![](rodent_energy_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

Means and SE for each time period, calculated from GLM fit:

<div class="kable-table">

| oera             |       est |     lower |     upper | oplottype |
| :--------------- | --------: | --------: | --------: | :-------- |
| b\_pre\_drought  | 0.1172888 | 0.0997539 | 0.1374355 | CC        |
| b\_pre\_drought  | 0.7248069 | 0.6979585 | 0.7501232 | EE        |
| c\_post\_drought | 0.0027984 | 0.0008023 | 0.0097130 | CC        |
| c\_post\_drought | 0.2512829 | 0.2235731 | 0.2811833 | EE        |

</div>

Significance of contrasts comparing each time period (within each
treatment), from GLM:

<div class="kable-table">

| contrast                           | oplottype | p.value |
| :--------------------------------- | :-------- | ------: |
| b\_pre\_drought - c\_post\_drought | CC        |       0 |
| b\_pre\_drought - c\_post\_drought | EE        |       0 |

</div>

## Smgran over time

Smgran energy use as a proportion of treatment-level totals on controls
and exclosures.

    ## Joining, by = c("period", "oplottype")
    ## Joining, by = c("period", "oplottype")

![](rodent_energy_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

Means and SE for each time period, calculated from GLM fit:

<div class="kable-table">

| oera             | oplottype |       est |     lower |     upper |
| :--------------- | :-------- | --------: | --------: | --------: |
| a\_pre\_pb       | CC        | 0.0816472 | 0.0621807 | 0.1065157 |
| a\_pre\_pb       | EE        | 0.9111217 | 0.8854559 | 0.9314816 |
| b\_pre\_drought  | CC        | 0.2839099 | 0.2510033 | 0.3192915 |
| b\_pre\_drought  | EE        | 0.9425976 | 0.9222044 | 0.9578890 |
| c\_post\_drought | CC        | 0.2964165 | 0.2587994 | 0.3370151 |
| c\_post\_drought | EE        | 0.9232823 | 0.8969641 | 0.9433030 |

</div>

Significance of contrasts comparing each time period (within each
treatment), from GLM:

<div class="kable-table">

| contrast                           | oplottype |   p.value |
| :--------------------------------- | :-------- | --------: |
| a\_pre\_pb - b\_pre\_drought       | CC        | 0.0000000 |
| a\_pre\_pb - c\_post\_drought      | CC        | 0.0000000 |
| b\_pre\_drought - c\_post\_drought | CC        | 0.8798965 |
| a\_pre\_pb - b\_pre\_drought       | EE        | 0.0736226 |
| a\_pre\_pb - c\_post\_drought      | EE        | 0.7356211 |
| b\_pre\_drought - c\_post\_drought | EE        | 0.3660145 |

</div>

## Compensation

Compensatory gains in energy use by small granivores on exclosure plots
relative to controls. Calculated as
\(\frac{SmgranExclosure - SmgranControl}{DipoControl}\).

    ## Joining, by = "era"

![](rodent_energy_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

Time period means + CL, from GLS fit with autocorrelation:

<div class="kable-table">

| oera             |    emmean |  lower.CL |  upper.CL |
| :--------------- | --------: | --------: | --------: |
| a\_pre\_pb       | 0.1887873 | 0.0916487 | 0.2859260 |
| b\_pre\_drought  | 0.5484112 | 0.4619628 | 0.6348595 |
| c\_post\_drought | 0.2184241 | 0.1197802 | 0.3170680 |

</div>

Significance of time period comparisons, from GLS:

<div class="kable-table">

| contrast                           |    estimate |        SE |       df |     t.ratio | p.value |
| :--------------------------------- | ----------: | --------: | -------: | ----------: | ------: |
| a\_pre\_pb - b\_pre\_drought       | \-0.3596238 | 0.0644233 | 60.44042 | \-5.5822045 |   0.000 |
| a\_pre\_pb - c\_post\_drought      | \-0.0296368 | 0.0691495 | 57.97849 | \-0.4285901 |   0.904 |
| b\_pre\_drought - c\_post\_drought |   0.3299870 | 0.0650229 | 62.66119 |   5.0749352 |   0.000 |

</div>

## Treatment:control total E ratio

Total energy use on exclosures relative to total energy use on controls.

    ## Joining, by = "era"

![](rodent_energy_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

Time period means and CL from GLS fit with autocorrelation:

<div class="kable-table">

| oera             | oplottype |    emmean |  lower.CL |  upper.CL |
| :--------------- | :-------- | --------: | --------: | --------: |
| a\_pre\_pb       | EE        | 0.2955610 | 0.2019781 | 0.3891438 |
| b\_pre\_drought  | EE        | 0.6836903 | 0.6012729 | 0.7661077 |
| c\_post\_drought | EE        | 0.4621793 | 0.3678648 | 0.5564937 |

</div>

Significance of time period comparisons:

<div class="kable-table">

| contrast                           | p.value |
| :--------------------------------- | ------: |
| a\_pre\_pb - b\_pre\_drought       |   0.000 |
| a\_pre\_pb - c\_post\_drought      |   0.040 |
| b\_pre\_drought - c\_post\_drought |   0.002 |

</div>
