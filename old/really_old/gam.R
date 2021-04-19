library(dplyr)
library(ggplot2)
library(mgcv)
theme_set(theme_bw())
source(here::here("scaffold", "R", "data.R"))
source(here::here("lore", "2019_switch", "FinalAnalysis", "analysis_functions.R"))
library(gratia)

load(here::here("se_gams.RData"))

get_smooth_diffs <- function(MODEL, dat) {
  
  cc_ce <- osmooth_diff(MODEL, dat, "numericdate", "CC", "CE", "oTreatment")
  cc_ee <- osmooth_diff(MODEL, dat, "numericdate", "CC", "EE", "oTreatment")
  
  diffs <- bind_rows(cc_ce, cc_ee) %>%
    mutate(diff_overlaps_zero = (upper * lower) < 0) %>%
    mutate(compare_trt = substr(pair, 4, 5)) 
  
  dat <- dat %>%
    mutate(compare_trt = as.character(oTreatment)) %>%
    left_join(diffs)
  
  return(dat)
}

plotfixed_fitted <- gratia::add_fitted(data = plot_totals, se.gam.plotint)

ggplot(plotfixed_fitted, aes(censusdate, .value, color = oTreatment, group = plot)) +
  geom_line()

plotfixed_eff_noex <- predict_treat_effect2(plot_totals, 500, se.gam.plotint, exVars = NULL)

ggplot(plotfixed_eff_noex, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


exVars.d <- c('oPlot', paste0('s(numericdate):oPlot', unique(plot_totals$oPlot)),
              names(coefficients(se.gam.plotint)[ which(grepl("oPlot", names(coefficients(se.gam.plotint))))]))

plotfixed_eff_explot <- predict_treat_effect2(plot_totals, 500, se.gam.plotint, exVars = exVars.d)

all.equal(plotfixed_eff_noex, plotfixed_eff_explot)

ggplot(plotfixed_eff_explot, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)

# So the plot as a FIXED INTERCEPT is not sensitive to whether you exclude oPlot, if all values of oPlot are 4.

# Giving it 3 levels of oPlot:

plotfixed_eff_noex2 <- predict_treat_effect3(plot_totals, 500, se.gam.plotint, exVars = NULL)

ggplot(plotfixed_eff_noex2, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


exVars.d <- c('oPlot', paste0('s(numericdate):oPlot', unique(plot_totals$oPlot)),
              names(coefficients(se.gam.plotint)[ which(grepl("oPlot", names(coefficients(se.gam.plotint))))]))

plotfixed_eff_explot2 <- predict_treat_effect3(plot_totals, 500, se.gam.plotint, exVars = exVars.d)

all.equal(plotfixed_eff_noex2, plotfixed_eff_explot2)

ggplot(plotfixed_eff_explot2, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)

noex_comp <- data.frame(censusdate = plotfixed_eff_noex2$censusdate, oPlot = plotfixed_eff_noex2$oPlot, est1 = plotfixed_eff_noex2$Fitted, est2 = plotfixed_eff_noex$Fitted, oTreatment = plotfixed_eff_noex2$oTreatment)

ggplot(noex_comp, aes(est1, est2, color = est1 == est2)) +
  geom_point() +
 geom_abline(slope = 1, intercept =  0) +
  facet_wrap(vars(oTreatment))

# Giving it 3 levels of oPlot, you still get the same thing whether exVars are provided or not. However you get different predictions than if you provided all the same level of oPlot. 


# What if you try and just not give it oPlot?
# You can't, it refuses to run.

# What about with one with plot as a smooth?


plotsmooth_fitted <- gratia::add_fitted(data = plot_totals, se.gam.plotint)

ggplot(plotsmooth_fitted, aes(censusdate, .value, color = oTreatment, group = plot)) +
  geom_line()

plotsmooth_eff_noex <- predict_treat_effect2(plot_totals, 500, se.gam, exVars = NULL)

ggplot(plotsmooth_eff_noex, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


exVars.d <- c('oPlot', paste0('s(numericdate):oPlot', unique(plot_totals$oPlot)),
              names(coefficients(se.gam.plotint)[ which(grepl("oPlot", names(coefficients(se.gam.plotint))))]))

plotsmooth_eff_explot <- predict_treat_effect2(plot_totals, 500, se.gam, exVars = exVars.d)

all.equal(plotsmooth_eff_noex, plotsmooth_eff_explot)

ggplot(plotsmooth_eff_explot, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)

# So the plot as a smooth is not sensitive to whether you exclude oPlot, if all values of oPlot are 4.

# Giving it 3 levels of oPlot:

plotsmooth_eff_noex2 <- predict_treat_effect3(plot_totals, 500, se.gam, exVars = NULL)

ggplot(plotsmooth_eff_noex2, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


exVars.d <- c('oPlot', paste0('s(numericdate):oPlot', unique(plot_totals$oPlot)),
              names(coefficients(se.gam.plotint)[ which(grepl("oPlot", names(coefficients(se.gam.plotint))))]))

plotsmooth_eff_explot2 <- predict_treat_effect3(plot_totals, 500, se.gam, exVars = exVars.d)

all.equal(plotsmooth_eff_noex2, plotsmooth_eff_explot2)


multipleplots_smooth_comp <- data.frame(censusdate = plotsmooth_eff_noex2$censusdate, oPlot = plotsmooth_eff_noex2$oPlot, est1 = plotsmooth_eff_noex2$Fitted, est2 = plotsmooth_eff_explot2$Fitted, oTreatment = plotsmooth_eff_noex2$oTreatment)

ggplot(multipleplots_smooth_comp, aes(est1, est2, color = est1 == est2)) +
  geom_point() +
  geom_abline(slope = 1, intercept =  0) +
  facet_wrap(vars(oTreatment))

# If you provide different values of plot, if you exclude plot you get different values than if you don't exclude plot for the treatments.

noex_smooth_comp <- data.frame(censusdate = plotsmooth_eff_noex2$censusdate, oPlot = plotsmooth_eff_noex2$oPlot, est1 = plotsmooth_eff_noex2$Fitted, est2 = plotsmooth_eff_noex$Fitted, oTreatment = plotsmooth_eff_noex2$oTreatment)

ggplot(noex_smooth_comp, aes(est1, est2, color = est1 == est2)) +
  geom_point() +
  geom_abline(slope = 1, intercept =  0) +
  facet_wrap(vars(oTreatment))
# If you don't exclude plot, you get different values when you provide different plots


explot_smooth_comp <- data.frame(censusdate = plotsmooth_eff_explot2$censusdate, oPlot = plotsmooth_eff_explot2$oPlot, est1 = plotsmooth_eff_explot2$Fitted, est2 = plotsmooth_eff_explot$Fitted, oTreatment = plotsmooth_eff_explot2$oTreatment)

ggplot(explot_smooth_comp, aes(est1, est2, color = est1 == est2)) +
  geom_point() +
  geom_abline(slope = 1, intercept =  0) +
  facet_wrap(vars(oTreatment))

# EVEN IF YOU DO EXCLUDE PLOT you get different values when you provide different plots as opposed to having all plots = 4
