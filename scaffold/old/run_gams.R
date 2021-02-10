library(dplyr)
library(ggplot2)
library(mgcv)
theme_set(theme_bw())
source(here::here("scaffold", "R", "data.R"))

use_christensen_plots <- F

library(mgcv)
plot_totals <- get_rodent_data(use_christensen_plots = use_christensen_plots, return_plot = T) %>%
  mutate(tinygran_e = smgran_e - pb_e) %>%
  mutate(treatment = (plot_type),
         plot = (plot)) %>%
  mutate(censusdate = as.Date(censusdate)) %>%
  mutate(numericdate = as.numeric(censusdate) / 1000) %>%
  mutate(oTreatment = ordered(treatment, levels = c('CC','CE','EE')),
         oPlot      = ordered(plot),
         plot       = factor(plot))


te.gam <- gam(total_e ~ oPlot + oTreatment + s(numericdate, k = 40) +
                  s(numericdate, by = oTreatment, k = 40) +
                  s(numericdate, by = oPlot),
                data = plot_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))
te.gam.noplot <- gam(total_e ~ oTreatment + s(numericdate, k = 40) +
                  s(numericdate, by = oTreatment, k = 40) ,
                data = plot_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))
te.gam.randomplot <- gam(total_e ~ oTreatment + s(numericdate, k = 40) + s(numericdate, by = oTreatment, k = 40) + s(oPlot, bs = "re"), data = plot_totals, method = "REML", family = "tw", select = T, control = gam.control(nthreads = 4))

save.image("te_gams.RData")

rm(te.gam)
rm(te.gam.noplot)




se.gam <- gam(tinygran_e ~ oPlot + oTreatment + s(numericdate, k = 40) +
                s(numericdate, by = oTreatment, k = 40) +
                s(numericdate, by = oPlot),
              data = plot_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))
se.gam.noplot <- gam(smgran_e ~ oTreatment + s(numericdate, k = 40) +
                       s(numericdate, by = oTreatment, k = 40) ,
                     data = plot_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))

save.image("se_gams.RData")

rm(se.gam)
rm(se.gam.noplot)


tge.gam <- gam(tinygran_e ~ oPlot + oTreatment + s(numericdate, k = 40) +
                s(numericdate, by = oTreatment, k = 40) +
                s(numericdate, by = oPlot),
              data = plot_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))
tge.gam.noplot <- gam(smgran_e ~ oTreatment + s(numericdate, k = 40) +
                       s(numericdate, by = oTreatment, k = 40) ,
                     data = plot_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))

save.image("tge_gams.RData")

rm(tge.gam)
rm(tge.gam.noplot)

te.gamm <- gamm(total_e ~ oTreatment + s(numericdate, k = 10) + s(numericdate, by = oTreatment, k = 10), family = "tw", random = list(plot = ~1), correlation = corCAR1(form = ~ numericdate | plot), data = plot_totals)

te.gamm.pred <- gratia::add_fitted(data = distinct(select(plot_totals, numericdate, oTreatment)), model = te.gamm$gam)

ggplot(te.gamm.pred, aes(numericdate, .value, color = oTreatment)) + geom_line()

te.gamm.pdat <- select(plot_totals, numericdate, oTreatment) %>% distinct()

te.gamm.treatpred <- get_treatment_prediction(plot_totals, te.gamm.pdat, te.gamm$gam)

ggplot(te.gamm.treatpred, aes(numericdate, Fitted, color = oTreatment, fill = oTreatment)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha= .5)

te.gamm.diff <- get_treatment_diff(model = te.gamm$gam, newdata = te.gamm.pdat, "numericdate", 1, 2, "oTreatment")

save(te.gamm, file = "te_gamm.RData")
