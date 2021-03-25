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

#exVars.d = names(coefficients(se.gam))[ which(grepl("oPlot", names(coefficients(se.gam))))]
exVars.d <- c('oPlot', paste0('s(numericdate):oPlot', unique(plot_totals$oPlot)))
se.gam.pred <- predict_treat_effect2(plot_totals, 500, se.gam, exVars.d)


ggplot(se.gam.pred, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


diff_preddat <- se.gam.pred %>%
  select(censusdate, oPlot, oTreatment, numericdate)

diffs_eria <- get_smooth_diffs(se.gam, diff_preddat)

ggplot(diffs_eria, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 

diff_preddat_multipleplots <- as.data.frame(
  expand.grid(censusdate = seq(min(plot_totals$censusdate), max(plot_totals$censusdate), length = 500),
              oPlot = unique(plot_totals$oPlot)))

diff_preddat_multipleplots <- diff_preddat_multipleplots %>%
  filter(oPlot %in% c(2, 3, 4)) %>%
  left_join(distinct(select(plot_totals, oPlot, oTreatment))) %>%
  mutate(numericdate =as.numeric(censusdate) / 1000)


diffs_multplots <- get_smooth_diffs(se.gam, diff_preddat_multipleplots)

ggplot(diffs_multplots, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 

all.equal(diffs_multplots$se, diffs_eria$se)

### So diffs are NOT sensitive to having multiple plots using Erica's code and plot smooths


#### Random plot
se.gam.randomplot.pred <- predict_treat_effect2(plot_totals, 500, se.gam.randomplot, exVars.d)


ggplot(se.gam.randomplot.pred, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


diff_preddat_random <- se.gam.randomplot.pred %>%
  select(censusdate, oPlot, oTreatment, numericdate)

diffs_eria_random <- get_smooth_diffs(se.gam.randomplot, diff_preddat_random)

ggplot(diffs_eria_random, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 

diff_preddat_multipleplots_random <- as.data.frame(
  expand.grid(censusdate = seq(min(plot_totals$censusdate), max(plot_totals$censusdate), length = 500),
              oPlot = unique(plot_totals$oPlot)))

diff_preddat_multipleplots_random <- diff_preddat_multipleplots_random %>%
  filter(oPlot %in% c(2, 3, 4)) %>%
  left_join(distinct(select(plot_totals, oPlot, oTreatment))) %>%
  mutate(numericdate =as.numeric(censusdate) / 1000)


diffs_multplots_random <- get_smooth_diffs(se.gam.randomplot, diff_preddat_multipleplots_random)

ggplot(diffs_multplots_random, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 

all.equal(diffs_multplots_random$se, diffs_eria_random$se)

### So diffs are NOT sensitive to having multiple plots using Erica's code and random effect of plot


#### Fixed plot
se.gam.plotint.pred <- predict_treat_effect2(plot_totals, 500, se.gam.plotint, exVars.d)


ggplot(se.gam.plotint.pred, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


diff_preddat_fixed <- se.gam.plotint.pred %>%
  select(censusdate, oPlot, oTreatment, numericdate)

diffs_eria_fixed <- get_smooth_diffs(se.gam.plotint, diff_preddat_fixed)

ggplot(diffs_eria_fixed, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 

diff_preddat_multipleplots_fixed <- as.data.frame(
  expand.grid(censusdate = seq(min(plot_totals$censusdate), max(plot_totals$censusdate), length = 500),
              oPlot = unique(plot_totals$oPlot)))

diff_preddat_multipleplots_fixed <- diff_preddat_multipleplots_fixed %>%
  filter(oPlot %in% c(2, 3, 4)) %>%
  left_join(distinct(select(plot_totals, oPlot, oTreatment))) %>%
  mutate(numericdate =as.numeric(censusdate) / 1000)


diffs_multplots_fixed <- get_smooth_diffs(se.gam.plotint, diff_preddat_multipleplots_fixed)

ggplot(diffs_multplots_fixed, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 

all.equal(diffs_multplots_fixed$se, diffs_eria_fixed$se)

### So diffs are NOT sensitive to having multiple plots using Erica's code and fixed effect of plot


#### No plot
se.gam.noplot.pred <- predict_treat_effect2(plot_totals, 500, se.gam.noplot, exVars.d)


ggplot(se.gam.noplot.pred, aes(censusdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = .5)


diff_preddat_no <- se.gam.noplot.pred %>%
  select(censusdate, oPlot, oTreatment, numericdate)

diffs_eria_no <- get_smooth_diffs(se.gam.noplot, diff_preddat_no)

ggplot(diffs_eria_no, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 

diff_preddat_multipleplots_no <- as.data.frame(
  expand.grid(censusdate = seq(min(plot_totals$censusdate), max(plot_totals$censusdate), length = 500),
              oPlot = unique(plot_totals$oPlot)))

diff_preddat_multipleplots_no <- diff_preddat_multipleplots_no %>%
  filter(oPlot %in% c(2, 3, 4)) %>%
  left_join(distinct(select(plot_totals, oPlot, oTreatment))) %>%
  mutate(numericdate =as.numeric(censusdate) / 1000)


diffs_multplots_no <- get_smooth_diffs(se.gam.noplot, diff_preddat_multipleplots_no)

ggplot(diffs_multplots_no, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) 

all.equal(diffs_multplots_no$se, diffs_eria_no$se)

### So diffs are NOT sensitive to having multiple plots using Erica's code and no effect of plot

se_AICs <- lapply(list(se.gam, se.gam.noplot, se.gam.plotint, se.gam.randomplot), FUN = AIC)
se_AICs

# Winner by AIC is having plot as a fixed smooth.


ggplot(diffs_eria, aes(censusdate, diff, color = compare_trt, fill = compare_trt)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) +
  geom_hline(yintercept = 0)
