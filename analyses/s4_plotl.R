library(dplyr)
library(ggplot2)
library(soar)
pt <- soar::get_plot_totals()

excl_plots <- list_plot_types()
excl_plots <- excl_plots %>% filter(plot_type == "EE")

set.seed(1977)
excl_plot_out <- sample(excl_plots$plot, 1, F)
excl_plot_out <- 19 # there is a little bit of dependence on which plot you remove --> whether a - c is significant for compensaiton. if you remove plot 19, c > a (but still not to match total e). if you remove any other plot, c !> a, with varying degrees of difference. :shrug: because there are only 5 options for the plot to remove, and because dropping the plot like that is kind of a weird thing to do (reviewer suggestion), I'm inclined to try all of them and be clear eyed about the dependence there. 

control_means <- pt %>%
  filter(plot_type == "CC") %>%
  group_by(period) %>%
  summarize(mean_total_e = mean(total_e),
            mean_dipo_e = mean(dipo_e),
            mean_smgran_e = mean(smgran_e)) %>%
  ungroup() 

pt_vars <- pt %>%
  left_join(control_means) %>%
  mutate(energy_ratio = total_e / mean_total_e,
         compensation = (smgran_e - mean_smgran_e) / mean_dipo_e,
         dipo_ratio = dipo_e / total_e,
         pb_ratio = pb_e / total_e)


ggplot(filter(pt_vars, plot_type == "EE", oera == "c_post_reorg"), aes(censusdate, compensation, group = fplot)) + geom_line() + facet_wrap(vars(fplot), scales = "free_x")



pt_vars_filtered <- pt_vars %>%
  filter(plot != excl_plot_out, oplottype == "EE")

library(nlme)

erat_lme <- lme(energy_ratio ~ oera , random = ~1|fplot, data = pt_vars_filtered)
erat_lm <- lm(energy_ratio ~ oera , data = pt_vars_filtered)

AIC(erat_lme)
AIC(erat_lm)

library(emmeans)

erat_emmeans <- emmeans(erat_lme, specs = ~ oera )

erat_emmeans

pairs(erat_emmeans)

erat_pred <- pt_vars_filtered %>% mutate(preds = predict(erat_lme, level = 0))

ggplot(erat_pred, aes(censusdate, preds)) + geom_point() + ylim(0, 1.1)


comp_lme <- lme(compensation ~ oera , random = ~1|fplot, data = pt_vars_filtered)
comp_lm <- lm(compensation ~ oera , data = pt_vars_filtered)

AIC(comp_lme)
AIC(comp_lm)


library(emmeans)

comp_emmeans <- emmeans(comp_lme, specs = ~ oera )

comp_emmeans

pairs(comp_emmeans)


comp_pred <- pt_vars_filtered %>% mutate(preds = predict(comp_lme, level = 0))

ggplot(comp_pred, aes(censusdate, preds, color = fplot)) + geom_point()
# 
# ggplot(filter(pt_vars, plot_type == "EE", plot != 19), aes(censusdate, compensation, color = fplot)) + geom_point() 


