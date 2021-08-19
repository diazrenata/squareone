Covariates of rodent community change
================

  - [Figure S1](#figure-s1)
  - [References](#references)

<!-- # Total rodent abundance -->

<!-- # NDVI -->

<!-- # Drought (SPEI index) -->

    ## Loading required package: lmomco

    ## Loading required package: parallel

    ## # Package SPEI (1.7) loaded [try SPEINews()].

    ## Joining, by = c("year", "month")

    ## Registered S3 method overwritten by 'quantmod':
    ##   method            from
    ##   as.zoo.data.frame zoo

    ## Joining, by = "year"

# Figure S1

    ## Setting row to 1

    ## Setting column to 1

    ## Setting row to 2

    ## Setting column to 1

    ## Setting row to 3

    ## Setting column to 1

    ## Warning: Removed 22 rows containing missing values (position_stack).

    ## Warning: Removed 1 rows containing missing values (geom_col).

![](s2_covariates_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

Changes in overall community energy use (A), NDVI (B), and local climate
(C) surrounding the 2010 shift in rodent community composition. As
documented in Christensen et al. (2018), the 2010 transition followed a
period of low abundance community-wide (A) and low plant productivity
(B). Since 2010, the site has experienced two periods of drought (C)
interspersed with an unusually wet period.

Total rodent energy use (A) is calculated as the total energy use of all
granviores on control plots (\(Etot_C\)) in each census period. The
anomaly (shown) is calculated as the differene between the total energy
use in each census period and the long-term mean of total energy use.
Vertical dashed lines mark the dates of major transitions in the rodent
community. NDVI anomaly (B) is calculated as the difference between
monthly NDVI and the long-term mean for that month. NDVI data were
obtained from Landsat 5, 7, and 8 using the `ndvi` function in the R
package `portalr` (Maesk et al. 2006; Vermote et al. 2016; Christensen
et al. 2019). Drought (C) was calculated using a 12-month Standardized
Precipitation Evapotranspiraiton index (SPEI) for all months from
1989-2020, using the Thornthwaite method to estimate potential
evapotranspiration (using the R package `SPEI`, Beguería and
Vicente-Serrano 2017; Slette et al. 2019; Cárdenas et al. 2021). Values
greater than 0 (blue) indicate wetter than average conditions, and
values less than 0 (red) indicate drier conditions. Values between -1
and 1 (horizontal lines) are considered within normal variability for a
system, while values \< -1 constitute drought (Slette et al. 2019).

# References

Beguería, S., and S. M. Vicente-Serrano. 2017. SPEI: Calculation of the
Standardised Precipitation-Evapotranspiration Index.

Cárdenas, P. A., E. Christensen, S. K. M. Ernest, D. C. Lightfoot, R. L.
Schooley, P. Stapp, and J. A. Rudgers. 2021. Declines in rodent
abundance and diversity track regional climate variability in North
American drylands. Global Change Biology:gcb.15672.

Christensen, E. M., D. J. Harris, and S. K. M. Ernest. 2018. Long-term
community change through multiple rapid transitions in a desert rodent
community. Ecology 99:1523–1529.

Christensen, E. M., G. M. Yenni, H. Ye, J. L. Simonis, E. K. Bledsoe, R.
M. Diaz, S. D. Taylor, E. P. White, and S. K. M. Ernest. 2019. portalr:
an R package for summarizing and using the Portal Project Data. Journal
of Open Source Software 4:1098.

Masek, J.G., Vermote, E.F., Saleous, N., Wolfe, R., Hall, F.G.,
Huemmrich, F., Gao, F., Kutler, J., and Lim, T.K. (2006). A Landsat
surface reflectance data set for North America, 1990-100, IEEE
Geoscience and Remote Sensing Letters. 3:68-72.

Slette, I. J., A. K. Post, M. Awad, T. Even, A. Punzalan, S. Williams,
M. D. Smith, and A. K. Knapp. 2019. How ecologists define drought, and
why we should do better. Global Change Biology 25:3193–3200.

Vermote, E., Justice, C., Claverie, M., & Franch, B. (2016). Preliminary
analysis of the performance of the Landsat 8/OLI land surface
reflectance product. Remote Sensing of Environment, 185, 46-56.
