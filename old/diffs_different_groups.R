library(dplyr)
library(ggplot2)
library(mgcv)
theme_set(theme_bw())
source(here::here("scaffold", "R", "data.R"))
source(here::here("lore", "2019_switch", "FinalAnalysis", "analysis_functions.R"))
library(gratia)


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

#### Smgran ####
load(here::here("se_gams.RData"))
load(here::here("se_gams.RData"))

se_AICs <- lapply(list(se.gam, se.gam.noplot, se.gam.plotint, se.gam.randomplot, se.gam.randomplot.s), FUN = AIC)
se_AICs

#exVars.d = names(coefficients(se.gam.randomplot))[ which(grepl("oPlot", names(coefficients(se.gam.randomplot))))]
exVars.d <- c('oPlot', paste0('s(numericdate):oPlot', unique(plot_totals$oPlot)))
se.gam.randomplot.pred <- predict_treat_effect2(plot_totals, 500, se.gam.randomplot, exVars.d)


ggplot(se.gam.randomplot.pred, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)

se.gam.randomplot.s.pred <- predict_treat_effect2(plot_totals, 500, se.gam.randomplot.s, exVars.d)


ggplot(se.gam.randomplot.s.pred, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5) # again hella wonky

se.gam.randomplot.s.fitted <- gratia::add_fitted(plot_totals,se.gam.randomplot.s)

ggplot(se.gam.randomplot.s.fitted, aes(censusdate, .value, color = oTreatment, group = oPlot)) +
  geom_line()

se.gam.pred <- predict_treat_effect2(plot_totals, 500, se.gam, exVars.d)


ggplot(se.gam.pred, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


diff_preddat <- se.gam.randomplot.pred %>%
  select(censusdate, oPlot, oTreatment, numericdate)

diffs_eria <- get_smooth_diffs(se.gam.randomplot, diff_preddat)

ggplot(diffs_eria, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 

#### Total E ####

load(here::here("te_gams.RData"))

te_AICs <- lapply(list(te.gam, te.gam.noplot, te.gam.plotint, te.gam.randomplot), FUN = AIC)
te_AICs

#exVars.d = names(coefficients(te.gam.randomplot))[ which(grepl("oPlot", names(coefficients(te.gam.randomplot))))]
exVars.d <- c('oPlot', paste0('s(numericdate):oPlot', unique(plot_totals$oPlot)))
te.gam.randomplot.pred<- predict_treat_effect2(plot_totals, 500, te.gam.randomplot, exVars.d)

ggplot(te.gam.randomplot.pred, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)

te.gam.randomplot.fitted <- gratia::add_fitted(plot_totals, te.gam.randomplot)

ggplot(te.gam.randomplot.fitted, aes(censusdate, .value, color = oTreatment, group = oPlot)) +
  geom_line()

## something is wonky about the predictions here - see how high CE is in the predictions. this is not the case for the fit. my guess is that this model is using plot to fix a weird offset its' giving to treatment. :(

diff_preddat_te <- te.gam.randomplot.pred %>%
  select(censusdate, oPlot, oTreatment, numericdate)

diffs_eria_te <- get_smooth_diffs(te.gam.randomplot, diff_preddat)

ggplot(diffs_eria_te, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 

