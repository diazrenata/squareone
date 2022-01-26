# Script to explore how non-granivores respond to exclosure treatments over time.
# In response to question, differential predation pressure on plots?


library(dplyr)
library(portalr)
library(ggplot2)


# abundance data for all rodents from portalr
all_rodents <- abundance(level = "plot", time = "all")

library(soar)

# use soardat to get periods and plots to be consistent with data in this paper
soardat <- get_plot_totals()


all_rodents <- all_rodents %>% filter(plot %in% as.numeric(soardat$plot), period %in% soardat$period) %>% filter(plot != 19)


# break species into:
# rodents, not granivores
# granivores, not krats (to compare response to exclosure treatment)
rtable <- load_rodent_data()

not_granivores <- rtable$species_table %>% filter(rodent == 1, granivore == 0, censustarget == 1, unidentified == 0) %>% select(species, scientificname)

granivores <- rtable$species_table %>% filter(rodent == 1, granivore ==1, censustarget == 1, unidentified == 0) %>% select(species) %>% filter(!grepl("D", species))


not_granivore_abund <- all_rodents[, c("period", "censusdate", "treatment", "plot", not_granivores$species)]

not_granivore_abunds <- rowSums(not_granivore_abund[, 5:10])

not_granivore_abund <- not_granivore_abund %>%
  mutate(total_abundance = not_granivore_abunds) %>%
  group_by(period, treatment) %>%
  mutate(total_abundance = sum(total_abundance)) %>%
  ungroup()


ggplot(not_granivore_abund, aes(censusdate, total_abundance, color = treatment, group = as.factor(plot))) + geom_line()

ggplot(not_granivore_abund, aes(censusdate, treatmenttotal_abundance, color = treatment)) + geom_line()


granivore_abund <- all_rodents[, c("period", "censusdate", "treatment", "plot", granivores$species)]

granivore_abunds <- rowSums(granivore_abund[, 5:ncol(granivore_abund)])

granivore_abund <- granivore_abund %>%
  mutate(total_abundance = granivore_abunds) %>%
  group_by(period, treatment) %>%
  mutate(total_abundance = sum(total_abundance)) %>%
  ungroup()


# plot treatment effects for granivores (not-krats) vs. nongranivores
long_abund <- granivore_abund %>% mutate(rodents = "Granivores") %>%
  bind_rows(mutate(not_granivore_abund, rodents = "Nongranivores")) %>%
  group_by(treatment, rodents) %>%
  mutate(total_abundance_moving_average = maopts(total_abundance),
         Treatment = treatment)


ggplot(long_abund, aes(censusdate, total_abundance_moving_average, color = Treatment)) + geom_line() + facet_wrap(vars(rodents), scales = "free_y", nrow = 2) + theme_bw() + theme(legend.position = "bottom", legend.direction = "horizontal") + xlab("Census date") + ylab("Total abundance (6-mo moving average)") 
