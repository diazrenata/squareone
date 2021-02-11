library(dplyr)
library(ggplot2)
library(mgcv)
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


te.gam <- gam(total_e ~ oPlot + oTreatment + s(numericdate, k = 40) +
                  s(numericdate, by = oTreatment, k = 40) +
                  s(numericdate, by = oPlot),
                data = plot_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))
te.gam.plotint <- gam(total_e ~ oPlot + oTreatment + s(numericdate, k = 40) +
                        s(numericdate, by = oTreatment, k = 40),
                      data = plot_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))

te.gam.noplot <- gam(total_e ~ oTreatment + s(numericdate, k = 40) +
                  s(numericdate, by = oTreatment, k = 40) ,
                data = plot_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))
te.gam.randomplot <- gam(total_e ~ oTreatment + s(numericdate, k = 40) + s(numericdate, by = oTreatment, k = 40) + s(oPlot, bs = "re"), data = plot_totals, method = "REML", family = "tw", select = T, control = gam.control(nthreads = 4))



save.image("te_gams.RData")

rm(te.gam)
rm(te.gam.plotint)
rm(te.gam.noplot)
rm(te.gam.randomplot)



se.gam <- gam(smgran_e ~ oPlot + oTreatment + s(numericdate, k = 40) +
                s(numericdate, by = oTreatment, k = 40) +
                s(numericdate, by = oPlot),
              data = plot_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))
se.gam.noplot <- gam(smgran_e ~ oTreatment + s(numericdate, k = 40) +
                       s(numericdate, by = oTreatment, k = 40) ,
                     data = plot_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))
se.gam.randomplot <- gam(smgran_e ~ oTreatment + s(numericdate, k = 40) + s(numericdate, by = oTreatment, k = 40) + s(oPlot, bs = "re"), data = plot_totals, method = "REML", family = "tw", select = T, control = gam.control(nthreads = 4))

se.gam.plotint <- gam(smgran_e ~ oPlot + oTreatment + s(numericdate, k = 40) +
                        s(numericdate, by = oTreatment, k = 40),
                      data = plot_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))

save.image("se_gams.RData")

rm(se.gam)
rm(se.gam.noplot)
rm(se.gam.plotint)
rm(se.gam.randomplot)



tge.gam <- gam(tinygran_e ~ oPlot + oTreatment + s(numericdate, k = 40) +
                s(numericdate, by = oTreatment, k = 40) +
                s(numericdate, by = oPlot),
              data = plot_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))

tge.gam.plotint <- gam(tinygran_e ~ oPlot + oTreatment + s(numericdate, k = 40) +
                 s(numericdate, by = oTreatment, k = 40),
               data = plot_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))
tge.gam.noplot <- gam(tinygran_e ~ oTreatment + s(numericdate, k = 40) +
                       s(numericdate, by = oTreatment, k = 40) ,
                     data = plot_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))
tge.gam.randomplot <- gam(tinygran_e ~ oTreatment + s(numericdate, k = 40) + s(numericdate, by = oTreatment, k = 40) + s(oPlot, bs = "re"), data = plot_totals, method = "REML", family = "tw", select = T, control = gam.control(nthreads = 4))

save.image("tge_gams.RData")

rm(tge.gam)
rm(tge.gam.plotint)
rm(tge.gam.noplot)
rm(tge.gam.randomplot)


pb_totals <- filter(plot_totals, era != "a_pre_ba")


pbe.gam <- gam(pb_e ~ oPlot + oTreatment + s(numericdate, k = 40) +
                 s(numericdate, by = oTreatment, k = 40) +
                 s(numericdate, by = oPlot),
               data = pb_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))


pbe.gam.plotint <- gam(pb_e ~ oPlot + oTreatment + s(numericdate, k = 40) +
                 s(numericdate, by = oTreatment, k = 40),
               data = pb_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))
pbe.gam.noplot <- gam(pb_e ~ oTreatment + s(numericdate, k = 40) +
                        s(numericdate, by = oTreatment, k = 40) ,
                      data = pb_totals, method = 'REML', family = "tw", select = TRUE, control = gam.control(nthreads = 4))
pbe.gam.randomplot <- gam(pb_e ~ oTreatment + s(numericdate, k = 40) + s(numericdate, by = oTreatment, k = 40) + s(oPlot, bs = "re"), data = pb_totals, method = "REML", family = "tw", select = T, control = gam.control(nthreads = 4))

save.image("pbe_gams.RData")

rm(pbe.gam)
rm(pbe.gam.noplot)
rm(pbe.gam.plotint)
rm(pbe.gam.randomplot)



te.gam.randomplot.s <- gam(total_e ~ oTreatment + s(numericdate, k = 40) + s(numericdate, by = oTreatment, k = 40) + s(oPlot, bs = "re") + s(oPlot, numericdate, bs = "re"), data = plot_totals, method = "REML", family = "tw", select = T, control = gam.control(nthreads = 4))


se.gam.randomplot.s <- gam(smgran_e ~ oTreatment + s(numericdate, k = 40) + s(numericdate, by = oTreatment, k = 40) + s(oPlot, bs = "re") + s(oPlot, numericdate, bs = "re"), data = plot_totals, method = "REML", family = "tw", select = T, control = gam.control(nthreads = 4))



tge.gam.randomplot.s <- gam(tinygran_e ~ oTreatment + s(numericdate, k = 40) + s(numericdate, by = oTreatment, k = 40) + s(oPlot, bs = "re") + s(oPlot, numericdate, bs = "re"), data = plot_totals, method = "REML", family = "tw", select = T, control = gam.control(nthreads = 4))

pb_totals <- filter(plot_totals, era != "a_pre_ba")


pbe.gam.randomplot.s <- gam(total_e ~ oTreatment + s(numericdate, k = 40) + s(numericdate, by = oTreatment, k = 40) + s(oPlot, bs = "re") + s(oPlot, numericdate, bs = "re"), data = pb_totals, method = "REML", family = "tw", select = T, control = gam.control(nthreads = 4))


save.image("randomplots_gams.RData")