library(dplyr)
library(ggplot2)
library(mgcv)
theme_set(theme_bw())
source(here::here("scaffold", "R", "data.R"))
source(here::here("lore", "2019_switch", "FinalAnalysis", "analysis_functions.R"))
library(gratia)

load(here::here("randomplots_gams.RData"))

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

se_AICs <- lapply(list(se.gam, se.gam.noplot, se.gam.plotint, se.gam.randomplot, se.gam.randomplot.s), FUN = AIC)

exVars.d <- c('oPlot', paste0('s(numericdate):oPlot', unique(plot_totals$oPlot)))
preddat <- predict_treat_effect2(plot_totals, 500, se.gam, exVars.d) %>%
  select(censusdate, oPlot, oTreatment, numericdate)

se_diffs <- get_smooth_diffs(se.gam, preddat)
se_diffs_noplot <- get_smooth_diffs(se.gam.noplot, preddat)
se_diffs_random <- get_smooth_diffs(se.gam.randomplot, preddat)
se_diffs_randoms <- get_smooth_diffs(se.gam.randomplot.s, preddat)

se_preds <- predict_treat_effect2(plot_totals, 500, se.gam, exVars.d)
se_preds_noplot <- predict_treat_effect2(plot_totals, 500,se.gam.noplot, exVars.d)
se_preds_random <- predict_treat_effect2(plot_totals, 500,se.gam.randomplot, exVars.d)
se_preds_randoms <- predict_treat_effect2(plot_totals, 500,se.gam.randomplot.s, exVars.d)

ggplot(se_preds, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


ggplot(se_diffs, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 


ggplot(se_preds_random, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)

ggplot(se_diffs_random, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 


ggplot(se_preds_randoms, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)

ggplot(se_diffs_randoms, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 


ggplot(se_preds_noplot, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)

ggplot(se_diffs_noplot, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 



#### Total e ####
load(here::here("te_gams.RData"))

exVars.d <- c('oPlot', paste0('s(numericdate):oPlot', unique(plot_totals$oPlot)))
preddat <- predict_treat_effect2(plot_totals, 500, te.gam, exVars.d) %>%
  select(censusdate, oPlot, oTreatment, numericdate)

tediffs <- get_smooth_diffs(te.gam, preddat)
tediffs_noplot <- get_smooth_diffs(te.gam.noplot, preddat)
tediffs_random <- get_smooth_diffs(te.gam.randomplot, preddat)

ggplot(tediffs, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 


ggplot(tediffs_random, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 

ggplot(tediffs_noplot, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 



#### Tinygran e ####
load(here::here("tge_gams.RData"))

exVars.d <- c('oPlot', paste0('s(numericdate):oPlot', unique(plot_totals$oPlot)))
preddat <- predict_treat_effect2(plot_totals, 500, tge.gam, exVars.d) %>%
  select(censusdate, oPlot, oTreatment, numericdate)

tgediffs <- get_smooth_diffs(tge.gam, preddat)
tgediffs_noplot <- get_smooth_diffs(tge.gam.noplot, preddat)
tgediffs_random <- get_smooth_diffs(tge.gam.randomplot, preddat)

ggplot(tgediffs, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 


ggplot(tgediffs_random, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 

ggplot(tgediffs_noplot, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 

#### PB e ####
load(here::here("pbe_gams.RData"))

exVars.d <- c('oPlot', paste0('s(numericdate):oPlot', unique(plot_totals$oPlot)))
preddat <- predict_treat_effect2(pb_totals, 500, pbe.gam, exVars.d) %>%
  select(censusdate, oPlot, oTreatment, numericdate)

pbediffs <- get_smooth_diffs(pbe.gam, preddat)
pbediffs_noplot <- get_smooth_diffs(pbe.gam.noplot, preddat)
pbediffs_random <- get_smooth_diffs(pbe.gam.randomplot, preddat)

ggplot(pbediffs, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 


ggplot(pbediffs_random, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 

ggplot(pbediffs_noplot, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 

