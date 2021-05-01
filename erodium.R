library(dplyr)
library(ggplot2)

winter <- portalr::plant_abundance(level = "Plot", type = "Winter Annuals", length = "all")

head(winter)

winter <- winter %>%
  filter(season == "winter") %>%
  soar::add_plot_types() %>%
  filter(combined_trt %in% c("CC", "EE", "CE", "EC")) %>%
  mutate(plot_type = combined_trt) %>%
  mutate(ftrt = as.factor(combined_trt))

ggplot(filter(winter, species == "erod cicu"), aes(year, abundance, color = treatment, group = plot)) +
  geom_line() +
  facet_wrap(vars(combined_trt))

winter_props <- winter %>%
  group_by(year, plot) %>%
  mutate(total_abund = sum(abundance)) %>%
  ungroup() %>%
  filter(species == "erod cicu") %>%
  mutate(prop_abund = abundance / total_abund) %>%
  mutate(censusdate = as.Date(paste0(year, "-03-15"), origin =  "%Y-%m-%d")) 

tms <- soar::get_treatment_means() 




ggplot(winter_props, aes(censusdate, prop_abund, color = treatment, group = plot)) +
  geom_line() +
  geom_point() +
  facet_wrap(vars(combined_trt))




ggplot(filter(winter_props, ftrt %in% c("CC", "CE")), aes(censusdate, prop_abund, color = combined_trt, group = plot)) +
  geom_line() +
  geom_point()

library(gratia)
library(mgcv)

erod_prop_gam <- gam(winter_props, formula = abundance ~ ftrt + s(year, k = 20) + s(year, by = ftrt, k = 20) + s(plot, bs = "re"), family = poisson)

erod_prop_fit <- winter_props %>%
  select(year, censusdate, ftrt, plot) %>%
  distinct() %>%
  add_fitted(erod_prop_gam, value = "fitted")

ggplot(erod_prop_fit, aes(censusdate, fitted, color = ftrt, group = plot)) +
  geom_line()



tms2 <- tms %>%
  mutate(year = as.integer(format.Date(censusdate, "%Y"))) %>%
  left_join(select(winter_props, year, abundance, prop_abund, plot_type)) %>%
  group_by(year, plot_type) %>%
  summarize(mean_pb = mean(pb_e),
            mean_pb_prop = mean(pb_e / total_e),
            prop_abund = mean(prop_abund)) %>%
  ungroup()

ggplot(tms2, aes(prop_abund, mean_pb_prop, color = plot_type)) +
  geom_point() +
  geom_smooth(method = "glm", method.args = list(family = quasibinomial()))
