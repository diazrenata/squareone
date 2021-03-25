library(dplyr)
library(ggplot2)
library(mgcv)
theme_set(theme_bw())
source(here::here("scaffold", "R", "data.R"))
source(here::here("lore", "2019_switch", "FinalAnalysis", "analysis_functions.R"))
source(here::here("manual_link_pred.R"))
library(gratia)

load(here::here("se_gams.RData"))
#
# plotfixed_fitted <- gratia::add_fitted(data = plot_totals, se.gam.plotint)
#
# ggplot(plotfixed_fitted, aes(censusdate, .value, color = oTreatment, group = plot)) +
#   geom_line()
#
# plotfixed_eff_noex <- predict_treat_effect2(plot_totals, 500, se.gam.plotint, exVars = NULL)
#
# ggplot(plotfixed_eff_noex, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
#   geom_line() +
#   geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)
#
#
# exVars.d <- c('oPlot', paste0('s(numericdate):oPlot', unique(plot_totals$oPlot)),
#               names(coefficients(se.gam.plotint)[ which(grepl("oPlot", names(coefficients(se.gam.plotint))))]))
#
# plotfixed_eff_explot <- predict_treat_effect2(plot_totals, 500, se.gam.plotint, exVars = exVars.d)
#
# all.equal(plotfixed_eff_noex, plotfixed_eff_explot)
#
# ggplot(plotfixed_eff_explot, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
#   geom_line() +
#   geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)
#
# # So the plot as a FIXED INTERCEPT is not sensitive to whether you exclude oPlot, if all values of oPlot are 4.
#
# # Giving it 3 levels of oPlot:
#
# plotfixed_eff_noex2 <- predict_treat_effect3(plot_totals, 500, se.gam.plotint, exVars = NULL)
#
# ggplot(plotfixed_eff_noex2, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
#   geom_line() +
#   geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)
#
#
# exVars.d <- c('oPlot', paste0('s(numericdate):oPlot', unique(plot_totals$oPlot)),
#               names(coefficients(se.gam.plotint)[ which(grepl("oPlot", names(coefficients(se.gam.plotint))))]))
#
# plotfixed_eff_explot2 <- predict_treat_effect3(plot_totals, 500, se.gam.plotint, exVars = exVars.d)
#
# all.equal(plotfixed_eff_noex2, plotfixed_eff_explot2)
#
# ggplot(plotfixed_eff_explot2, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
#   geom_line() +
#   geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)
#
# noex_comp <- data.frame(censusdate = plotfixed_eff_noex2$censusdate, oPlot = plotfixed_eff_noex2$oPlot, est1 = plotfixed_eff_noex2$Fitted, est2 = plotfixed_eff_noex$Fitted, oTreatment = plotfixed_eff_noex2$oTreatment)
#
# ggplot(noex_comp, aes(est1, est2, color = est1 == est2)) +
#   geom_point() +
#  geom_abline(slope = 1, intercept =  0) +
#   facet_wrap(vars(oTreatment))

# Giving it 3 levels of oPlot, you still get the same thing whether exVars are provided or not. However you get different predictions than if you provided all the same level of oPlot.


# What if you try and just not give it oPlot?
# You can't, it refuses to run.

# What about with one with plot as a smooth?


plotsmooth_fitted <- gratia::add_fitted(data = plot_totals, se.gam)

ggplot(plotsmooth_fitted, aes(censusdate, .value, color = oTreatment, group = plot)) +
  geom_line()

plotsmooth_eff_noex <- predict_treat_effect2(plot_totals, 500, se.gam, exVars = NULL)

ggplot(plotsmooth_eff_noex, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


exVars.d <- c(names(coefficients(se.gam.plotint)[ which(grepl("oPlot", names(coefficients(se.gam.plotint))))]))

plotsmooth_eff_explot <- predict_treat_effect2(plot_totals, 500, se.gam, exVars = exVars.d)

all.equal(plotsmooth_eff_noex, plotsmooth_eff_explot)

plotsmooth_eff_manualex <- predict_treat_effect_manual(plot_totals, 500, se.gam, exVars.d)
all.equal(as.numeric(plotsmooth_eff_explot$Fitted), as.numeric(plotsmooth_eff_manualex$Fitted))

ggplot(plotsmooth_eff_manualex, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


treatEff_multipleplots <- predict_treat_effect3(plot_totals, 500, se.gam, exVars = NULL) %>%
  select(-fit, -se.fit, -Fitted, -Upper, -Lower)

plotsmooth_eff_manualex2 <- predict_treat_effect_manual(plot_totals, 500, se.gam, exVars.d, treatEff = treatEff_multipleplots)
all.equal(as.numeric(plotsmooth_eff_manualex2$Fitted), as.numeric(plotsmooth_eff_manualex$Fitted))

# WTF even manually zeroing out the smooth is STILL SENSITIVE TO IF YOU INCLUDED PLOT


treatEff_allplots <- predict_treat_effect4(plot_totals, 500, se.gam, exVars = NULL) %>%
  select(-fit, -se.fit, -Fitted, -Upper, -Lower)

plotsmooth_eff_manualex3 <- predict_treat_effect_manual(plot_totals, 500, se.gam, exVars.d, treatEff = treatEff_allplots)

ggplot(plotsmooth_eff_manualex3, aes(censusdate, Fitted, color = oTreatment, group = oPlot)) + 
  geom_line()


plotsmooth_eff_manualex4 <- predict_treat_effect_manual(plot_totals, 500, se.gam, NULL, treatEff = treatEff_allplots)

ggplot(plotsmooth_eff_manualex4, aes(censusdate, Fitted, color = oTreatment, group = oPlot)) + 
  geom_line()

### Plot as FIXED

plotfixed_fitted <- gratia::add_fitted(data = plot_totals, se.gam.plotint)

ggplot(plotfixed_fitted, aes(censusdate, .value, color = oTreatment, group = plot)) +
  geom_line()

plotfixed_eff_noex <- predict_treat_effect2(plot_totals, 500, se.gam.plotint, exVars = NULL)

ggplot(plotfixed_eff_noex, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


exVars.d <- c(names(coefficients(se.gam.plotint)[ which(grepl("oPlot", names(coefficients(se.gam.plotint))))]))

plotfixed_eff_explot <- predict_treat_effect2(plot_totals, 500, se.gam.plotint, exVars = exVars.d)

all.equal(plotfixed_eff_noex, plotfixed_eff_explot)

plotfixed_eff_manualex <- predict_treat_effect_manual(plot_totals, 500, se.gam.plotint, exVars.d)
all.equal(as.numeric(plotfixed_eff_explot$Fitted), as.numeric(plotfixed_eff_manualex$Fitted))

ggplot(plotfixed_eff_manualex, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


treatEff_multipleplots <- predict_treat_effect3(plot_totals, 500, se.gam.plotint, exVars = NULL) %>%
  select(-fit, -se.fit, -Fitted, -Upper, -Lower)

plotfixed_eff_manualex2 <- predict_treat_effect_manual(plot_totals, 500, se.gam.plotint, exVars.d, treatEff = treatEff_multipleplots)
all.equal(as.numeric(plotfixed_eff_manualex2$Fitted), as.numeric(plotfixed_eff_manualex$Fitted))

# If it is not a smooth it is not sensitive to having different levels of plot


treatEff_allplots <- predict_treat_effect4(plot_totals, 500, se.gam.plotint, exVars = NULL) %>%
  select(-fit, -se.fit, -Fitted, -Upper, -Lower)

plotfixed_eff_manualex3 <- predict_treat_effect_manual(plot_totals, 500, se.gam.plotint, exVars.d, treatEff = treatEff_allplots)

ggplot(plotfixed_eff_manualex3, aes(censusdate, Fitted, color = oTreatment, group = oPlot)) + 
  geom_line()

plotfixed_eff_manualex4 <- predict_treat_effect_manual(plot_totals, 500, se.gam.plotint, NULL, treatEff = treatEff_allplots)

ggplot(plotfixed_eff_manualex4, aes(censusdate, Fitted, color = oTreatment, group = oPlot)) + 
  geom_line()


### Plot as RANDOM

plotrandom_fitted <- gratia::add_fitted(data = plot_totals, se.gam.randomplot)

ggplot(plotrandom_fitted, aes(censusdate, .value, color = oTreatment, group = plot)) +
  geom_line()

plotrandom_eff_noex <- predict_treat_effect2(plot_totals, 500, se.gam.randomplot, exVars = NULL)

ggplot(plotrandom_eff_noex, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


exVars.d <- c(names(coefficients(se.gam.randomplot)[ which(grepl("oPlot", names(coefficients(se.gam.randomplot))))]))

plotrandom_eff_explot <- predict_treat_effect2(plot_totals, 500, se.gam.randomplot, exVars = exVars.d)

all.equal(plotrandom_eff_noex, plotrandom_eff_explot)

plotrandom_eff_manualex <- predict_treat_effect_manual(plot_totals, 500, se.gam.randomplot, exVars.d)
all.equal(as.numeric(plotrandom_eff_explot$Fitted), as.numeric(plotrandom_eff_manualex$Fitted))

ggplot(plotrandom_eff_manualex, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


treatEff_multipleplots <- predict_treat_effect3(plot_totals, 500, se.gam.randomplot, exVars = NULL) %>%
  select(-fit, -se.fit, -Fitted, -Upper, -Lower)

plotrandom_eff_manualex2 <- predict_treat_effect_manual(plot_totals, 500, se.gam.randomplot, exVars.d, treatEff = treatEff_multipleplots)
all.equal(as.numeric(plotrandom_eff_manualex2$Fitted), as.numeric(plotrandom_eff_manualex$Fitted))

# If it is a random smooth it is not sensitive to having different levels of plot but it is sensitive to whether you exclude variables

treatEff_allplots <- predict_treat_effect4(plot_totals, 500, se.gam.randomplot, exVars = NULL) %>%
  select(-fit, -se.fit, -Fitted, -Upper, -Lower)

plotrandom_eff_manualex3 <- predict_treat_effect_manual(plot_totals, 500, se.gam.randomplot, exVars.d, treatEff = treatEff_allplots)

ggplot(plotrandom_eff_manualex3, aes(censusdate, Fitted, color = oTreatment, group = oPlot)) + 
  geom_line()

plotrandom_eff_manualex4 <- predict_treat_effect_manual(plot_totals, 500, se.gam.randomplot, NULL, treatEff = treatEff_allplots)

ggplot(plotrandom_eff_manualex4, aes(censusdate, Fitted, color = oTreatment, group = oPlot)) + 
  geom_line()
