library(dplyr)
library(ggplot2)
library(nlme)
library(lme4)
theme_set(theme_bw())
source(here::here("scaffold", "R", "data.R"))

use_christensen_plots <- F

library(mgcv)
plot_totals <- get_rodent_data(use_christensen_plots = use_christensen_plots, return_plot = T) %>%
  mutate(treatment = (plot_type),
         plot = (plot)) %>%
  mutate(censusdate = as.Date(censusdate)) %>%
  mutate(numericdate = as.numeric(censusdate) / 1000) %>%
  mutate(oTreatment = ordered(treatment, levels = c('CC','CE','EE')),
         oPlot      = ordered(plot, levels = c(4, 2, 3, 8, 11, 14, 15, 17, 19, 22)),
         plot       = factor(plot))


gamdat <- plot_totals %>%
  mutate(total_e = ceiling(total_e),
         smgran_e = ceiling(smgran_e),
         tinygran_e = ceiling(tinygran_e),
         pb_e = ceiling(pb_e))


te.lme.ac <- lme(total_e ~ treatment * era, random = ~1|plot, data = plot_totals, correlation = corCAR1(form = ~ numericdate | plot))

te.lme <- lme(total_e ~ treatment * era, random = ~1|plot, data = plot_totals)

te.gls.ac <- gls(total_e ~ treatment * era, data = plot_totals, correlation = corCAR1(form = ~ numericdate | plot)) 

te.gls <- gls(total_e ~ treatment * era, data = plot_totals)

te.gam <- gam(total_e ~ treatment * era, data = gamdat, family = poisson)

te.glmer <- glmer(total_e ~ treatment * era + (1|plot), data = gamdat, family = poisson)

save.image("te_mods.RData")
