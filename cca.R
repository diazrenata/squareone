library(dplyr)
library(ggplot2)
library(soar)
library(vegan)
winter <- portalr::plant_abundance(level = "Plot", type = "Winter Annuals")

winter <- winter %>%
  filter(season == "winter") %>%
  add_plot_types() %>%
  mutate(fplottype = as.factor(combined_trt)) %>%
  filter(fplottype %in% c("CC", "CE", "EE", "EC")) %>%
  mutate(era = ifelse(year < 1996, "a", ifelse(year < 2010, "b", "c"))) %>%
  mutate(sqrtabund= sqrt(abundance))

mean_winter <- winter %>%
  group_by(year, season, fplottype, species, era) %>%
  summarize(meanabund = mean(abundance)) %>%
  ungroup() %>%
  mutate(sqrtmeanabund = sqrt(meanabund))

winter_matrix <- winter %>%
  tidyr::pivot_wider(id_cols = c("year", "season", "fplottype", "era", "plot"), values_from = sqrtabund, names_from = species, values_fill = 0)

winter_vals <- winter_matrix %>%
  select(-year, -season, -fplottype, -era, -plot) %>%
  as.matrix()

winter_pca = princomp(winter_vals)

screeplot(winter_pca)

winter_pca_results <- data.frame(
  scores(winter_pca)[,1:2],
  year = winter_matrix$year,
  fplottype = winter_matrix$fplottype,
  era = winter_matrix$era,
  plot = winter_matrix$plot
)

ggplot(winter_pca_results, aes(Comp.1, Comp.2, color = era)) +
  geom_point() +
  facet_wrap(vars(fplottype))


ggplot(filter(winter_pca_results, era != "a"), aes(Comp.1, Comp.2, color = era)) +
  geom_point() +
  facet_wrap(vars(fplottype))

winter_cca <- cca(winter_vals ~ as.factor(winter_matrix$era) + Condition(winter_matrix$fplottype))

winter_results <- data.frame(
  scores(winter_cca, display = "sites", scaling = "sites"),
  year = winter_matrix$year,
  fplottype = winter_matrix$fplottype,
  era = winter_matrix$era
)


ggplot(winter_results, aes(CCA1, CCA2, color = era)) +
  geom_point() +
  facet_wrap(vars(fplottype))

plot(winter_cca, display = "reg")

# from erica
anova(winter_cca)
permutest(winter_cca,permutations=500) 
winter_cca$CCA$tot.chi/winter_cca$tot.chi

winter_propmatrix <- winter_vals / rowSums(winter_vals)

winter_propmatrix_long <- as.data.frame(winter_propmatrix) %>%
  mutate(year = winter_matrix$year,
         fplottype = winter_matrix$fplottype) %>%
  tidyr::pivot_longer(-c(year, fplottype), names_to = "species", values_to = "propabud")

ggplot(winter_propmatrix_long, aes(year, propabud, color = species)) +geom_line() +facet_wrap(vars(fplottype)) + theme(legend.position = "none") + geom_line(data = filter(winter_propmatrix_long, species == "erod cicu"), color = "black")


summer <- portalr::plant_abundance(level = "Plot", type = "Summer Annuals")
summer <- summer %>%
  filter(season == "summer") %>%
  add_plot_types() %>%
  mutate(fplottype = as.factor(combined_trt)) %>%
  filter(fplottype %in% c("CC", "CE", "EE", "EC")) %>%
  mutate(era = ifelse(year < 1996, "a", ifelse(year < 2010, "b", "c"))) %>%
  mutate(sqrtabund= sqrt(abundance))

mean_summer <- summer %>%
  group_by(year, season, fplottype, species, era) %>%
  summarize(meanabund = mean(abundance)) %>%
  ungroup() %>%
  mutate(sqrtmeanabund = sqrt(meanabund))

summer_matrix <- summer %>%
  tidyr::pivot_wider(id_cols = c("year", "season", "fplottype", "era", "plot"), values_from = sqrtabund, names_from = species, values_fill = 0)

summer_vals <- summer_matrix %>%
  select(-year, -season, -fplottype, -era, -plot) %>%
  as.matrix()

summer_pca = princomp(summer_vals)

screeplot(summer_pca)

summer_pca_results <- data.frame(
  scores(summer_pca)[,1:2],
  year = summer_matrix$year,
  fplottype = summer_matrix$fplottype,
  era = summer_matrix$era,
  plot = summer_matrix$plot
)

ggplot(summer_pca_results, aes(Comp.1, Comp.2, color = era)) +
  geom_point() +
  facet_wrap(vars(fplottype))


ggplot(filter(summer_pca_results, era != "a"), aes(Comp.1, Comp.2, color = era)) +
  geom_point() +
  facet_wrap(vars(fplottype))

summer_cca <- cca(summer_vals ~ as.factor(summer_matrix$era) + Condition(summer_matrix$fplottype))

summer_results <- data.frame(
  scores(summer_cca, display = "sites", scaling = "sites"),
  year = summer_matrix$year,
  fplottype = summer_matrix$fplottype,
  era = summer_matrix$era
)


ggplot(summer_results, aes(CCA1, CCA2, color = era)) +
  geom_point() +
  facet_wrap(vars(fplottype))

plot(summer_cca, display = "reg")

# from erica
anova(summer_cca)
permutest(summer_cca,permutations=500) 
summer_cca$CCA$tot.chi/summer_cca$tot.chi

