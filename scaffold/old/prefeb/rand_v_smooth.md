GAM
================

### Small gran

    ## Joining, by = c("oPlot", "oTreatment")

    ## Joining, by = c("censusdate", "compare_trt")
    ## Joining, by = c("censusdate", "compare_trt")
    ## Joining, by = c("censusdate", "compare_trt")
    ## Joining, by = c("censusdate", "compare_trt")

    ## Joining, by = c("oPlot", "oTreatment")
    ## Joining, by = c("oPlot", "oTreatment")
    ## Joining, by = c("oPlot", "oTreatment")
    ## Joining, by = c("oPlot", "oTreatment")

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning -
    ## Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-1-2.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-1-3.png)<!-- -->

The predictions here are misleading. Absent the plot-level smoothers,
you end up with Ce exceeding EE ca. 2008 (for example). I believe this
is because this model is able to use the plot smooths to correct for
these weird offsets and get back to accurate fitted values. However, I
worry this also makes the **difference** smooths also potentially
suspect. For example, for comparing EE to the control, we cross 0 from
2005-2010. The **fitted values** are different, but the treatment effect
smooths are crossing.

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-2-3.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-2-4.png)<!-- -->

More so, for this same time period, CE and CC ostensibly DO NOT OVERLAP.
However the **fitted values** with plot do, and so do the real data.
More than EE and CC do\!

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-3-2.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-3-3.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-3-4.png)<!-- -->

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning -
    ## Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-4-3.png)<!-- -->

This is a random-intercept plot model, and it does not have the same
weird behaviors.

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-5-2.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning -
    ## Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-5-3.png)<!-- -->

Again, I’m not sure about this because it sure **looks** like the plot
is being used to refine a very **vague** prediction. But at least it’s
not getting things dramatically wrong, like the rank order. (It really
stands out having CE \>\> EE, as in the one with plot as a smooth)

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning -
    ## Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-6-2.png)<!-- -->

Not including plot at all is pretty anti-conservative w.r.t. finding
differences \>0.

    ## Warning: Removed 500 row(s) containing missing values (geom_path).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning -
    ## Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).
    
    ## Warning: no non-missing arguments to max; returning -Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-7-2.png)<!-- -->

Having the random plot effect, compared to no plot effect, gives a
similar story but quite different CIs.

  - EE exceeds CC by quite a bit in the 1980s-1990s, declining to zero
    or near zero by the 2010s. With no plot, the smooths never actually
    cross; with plot, they cross about 2010.
  - CE tracks CC more closely at first, but from 1995-around 2010 and
    from 2015 onwards, CE also exceeds CC.

### Total E

    ## Joining, by = c("oPlot", "oTreatment")

    ## Joining, by = c("censusdate", "compare_trt")
    ## Joining, by = c("censusdate", "compare_trt")
    ## Joining, by = c("censusdate", "compare_trt")
    ## Joining, by = c("censusdate", "compare_trt")

    ## Joining, by = c("oPlot", "oTreatment")
    ## Joining, by = c("oPlot", "oTreatment")
    ## Joining, by = c("oPlot", "oTreatment")
    ## Joining, by = c("oPlot", "oTreatment")

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning -
    ## Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-8-2.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-8-3.png)<!-- -->

Whoa, here it is again. The **actual** fits for CE don’t wildly exceed
CC and EE at any point, but absent the plot smooths they do.

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning -
    ## Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-9-2.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-9-3.png)<!-- -->

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-10-2.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning -
    ## Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-10-3.png)<!-- -->

Again, the random smooths are weird…

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning -
    ## Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-11-2.png)<!-- -->

No plot is anticonservative.

    ## Warning: Removed 500 row(s) containing missing values (geom_path).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning -
    ## Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).
    
    ## Warning: no non-missing arguments to max; returning -Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-12-2.png)<!-- -->

Again, having no plot vs. having the random plot effect tells a similar
trend but with narrower/broader CIs.

  - EE is well below the controls except for brief moments in the 2000s.
  - CE is closer to the controls until 2015, when it jumps down to meet
    or nearly meet EE.

### Tinygran E

    ## Joining, by = c("oPlot", "oTreatment")

    ## Joining, by = c("censusdate", "compare_trt")
    ## Joining, by = c("censusdate", "compare_trt")
    ## Joining, by = c("censusdate", "compare_trt")
    ## Joining, by = c("censusdate", "compare_trt")

    ## Joining, by = c("oPlot", "oTreatment")
    ## Joining, by = c("oPlot", "oTreatment")
    ## Joining, by = c("oPlot", "oTreatment")
    ## Joining, by = c("oPlot", "oTreatment")

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning -
    ## Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-13-2.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-13-3.png)<!-- -->

I am absolutely not convinced that what we shoudl take from these data
is that EE is **below** controls from 2007-2017\!

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-14-2.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-14-3.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-14-4.png)<!-- -->

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning -
    ## Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-15-2.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-15-3.png)<!-- -->

I have no…objections here.

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-16-2.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning -
    ## Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-16-3.png)<!-- -->

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->![](rand_v_smooth_files/figure-gfm/unnamed-chunk-17-2.png)<!-- -->

These fits confuse me. The fitted values have CC strongly above CE and
EE for this time period, but they’re…not.

THIS IS BECAUSE THIS MODEL IS FIT WITH TOTAL E NOT TG E.

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning -
    ## Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-18-2.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).

    ## Warning in max(ids, na.rm = TRUE): no non-missing arguments to max; returning -
    ## Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

    ## Warning: Removed 500 row(s) containing missing values (geom_path).
    
    ## Warning: no non-missing arguments to max; returning -Inf

![](rand_v_smooth_files/figure-gfm/unnamed-chunk-19-2.png)<!-- -->

These differ a bit.

  - EE way exceeds controls at the beginning, then **under** controls
    2005-2010, then **over** again pretty quickly. With the random int
    the under/overs are not sig.
  - CE tracks controls until either 2005-2010, when it too under
    performs, and then begins to exceed controls after 2015.
