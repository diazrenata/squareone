library(dplyr)
library(ggplot2)
library(soar)
pt <- soar::get_plot_totals()

all_plots <- list_plot_types()
excl_plots <- all_plots %>% filter(plot_type == "EE")
set.seed(1977)
exclosure_to_remove <- sample(excl_plots$plot, size = 1)

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
         pb_ratio = pb_e / total_e) %>%
  filter(plot != exclosure_to_remove)


ggplot(filter(pt_vars, plot_type == "EE", oera == "c_post_reorg"), aes(censusdate, compensation, group = fplot)) + geom_line() + facet_wrap(vars(fplot), scales = "free_x")



pt_vars_filtered <- pt_vars %>%
  filter(oplottype == "EE")

library(nlme)

erat_lme <- lme(energy_ratio ~ oera , random = ~1|fplot, correlation = corCAR1(form = ~ period | fplot), data = pt_vars_filtered)
erat_lme1 <- lme(energy_ratio ~ oera , random = ~1|fplot, correlation = corCAR1(form = ~ period), data = pt_vars_filtered)

AIC(erat_lme)
AIC(erat_lme1)

library(emmeans)

erat_emmeans <- emmeans(erat_lme, specs = ~ oera )

erat_emmeans

pairs(erat_emmeans)

erat_pred <- as.data.frame(erat_emmeans) %>%
  mutate(oera = ordered(oera)) %>%
  right_join(distinct(select(pt_vars, period, censusdate, oera)))

ggplot(erat_pred, aes(censusdate, emmean)) + geom_line() + geom_ribbon(aes(ymin = lower.CL, ymax = upper.CL), alpha = .1)

comp_lme <- lme(compensation ~ oera , random = ~1|fplot,  correlation = corCAR1(form = ~ period | fplot), data = pt_vars_filtered)


comp_lme1 <- lme(compensation ~ oera , random = ~1|fplot,  correlation = corCAR1(form = ~ period), data = pt_vars_filtered)


library(emmeans)

comp_emmeans <- emmeans(comp_lme, specs = ~ oera )

comp_emmeans

pairs(comp_emmeans)

comp_mean_pred <-  as.data.frame(comp_emmeans) %>%
  mutate(oera = ordered(oera)) %>%
  right_join(distinct(select(pt_vars, period, censusdate, oera)))

ggplot(comp_mean_pred, aes(censusdate, emmean)) + geom_line() + geom_ribbon(aes(ymin = lower.CL, ymax = upper.CL), alpha = .1)

library(lme4)

pt_vars_nozero_pbs <- filter(pt_vars, as.numeric(oera) > 1)

pb_glm <- glmer(pb_ratio ~ oera + oplottype + (1|fplot), data = pt_vars_nozero_pbs, family = binomial)

summary(pb_glm)

pb_emmeans <- regrid(emmeans(pb_glm, specs = ~ oera | oplottype))
pb_emmeans

pairs(pb_emmeans)

pb_pred <- pt_vars_nozero_pbs %>% mutate(preds = predict(pb_glm, newdata = pt_vars_nozero_pbs, re.form =NA, type = "response")) 

ggplot(pb_pred, aes(censusdate, preds, color = fplot)) + geom_point()


dipo_dat <- filter(pt_vars, oplottype == "CC")

dipo_glm <- glmer(dipo_ratio ~ oera + (1|fplot), data = dipo_dat, family = binomial)

summary(dipo_glm)

dipo_emmeans <- regrid(emmeans(dipo_glm, specs = ~ oera))
dipo_emmeans

pairs(dipo_emmeans)

dipo_pred <- pt_vars %>% mutate(preds = predict(dipo_glm, newdata = pt_vars, re.form =NA, type = "response")) 

ggplot(dipo_pred, aes(censusdate, preds, color = fplot)) + geom_point()
