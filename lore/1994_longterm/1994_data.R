library(dplyr)

rats <- portalr::summarise_individual_rodents(clean = T, type = "Rodents", length = "all", unknowns = FALSE, time = "all", fillweight = T)

rats <- rats %>%
  filter(censusdate < "1991-02-01",
         censusdate > "1977-07-01") %>%
  filter(plot %in% c(3, 8, 11, 12, 14, 15, 19, 21, 6, 13, 18, 20)) %>%
  mutate(heske_trtmnt = ifelse(
    plot %in% c(8, 11, 12, 14),
    "control",
    ifelse(plot %in% c(3, 15, 19, 21),
    "exclosure_1977",
    "exclosure_1988"
  )))

species <-  portalr::load_rodent_data()$species_table

rats <- rats %>%
  left_join(select(species, species, granivore))

rats <- rats %>% 
  mutate(omnivore = as.numeric(!granivore))

rats <- rats %>%
  mutate(small_granivore = species %in% c("PP", "PF", "PM", "RM", "PE"),
         grasshopper = species %in% c("OL", "OT"),
         dipo = species %in% c("DM", "DO", "DS"))

rats <- rats %>%
  mutate(type = ifelse(
    dipo, "dipo", ifelse(
      small_granivore, "small_granivore",
      ifelse(
        grasshopper, "grasshopper", "other"
      )
    )
  ))

rats <- rats %>%
  mutate(energy = 5.69 * (wgt^0.75))

write.csv(rats, here::here("lore", "1994_longterm", "1994_data_complete.csv"), row.names = F)

rats_totals <- rats %>%
  group_by(year, month, period, heske_trtmnt, type) %>%
  summarize(nind = dplyr::n(),
            biomass = sum(wgt, na.rm = T),
            energy = sum(energy, na.rm = T)) %>%
  ungroup()

rats_all_possible <- expand.grid(period = unique(rats$period), heske_trtmnt = unique(rats$heske_trtmnt), type = unique(rats$type)) 

rats_zeros <- left_join(rats_all_possible, select(rats_totals, period, year, month)) %>%
  distinct() %>%
  left_join(rats_totals) %>%
  mutate(nind = ifelse(is.na(nind), 0, nind),
         biomass = ifelse(is.na(biomass), 0, biomass),
         energy = ifelse(is.na(energy), 0, energy))

write.csv(rats_zeros, here::here("lore", "1994_longterm", "1994_data_statevars.csv"), row.names = F)


rats <- read.csv(here::here("lore", "1994_longterm", "1994_data_complete.csv"), stringsAsFactors = F) %>%
  mutate(plot = ordered(plot))

rat_plot_totals <- rats  %>%
  group_by(type, heske_trtmnt, period, plot) %>%
  summarize(nind = dplyr::n())


rats_all_possible <- expand.grid(period = unique(rat_plot_totals$period), type = unique(rat_plot_totals$type), plot = unique(rat_plot_totals$plot)) %>%
  ungroup() %>%
  left_join(distinct(select(rats, plot, heske_trtmnt)))

rats_plot_zeros <- rats_all_possible %>%
  left_join(rat_plot_totals) %>%
  mutate(nind = ifelse(is.na(nind), 0, nind)) 

write.csv(rats_plot_zeros, here::here("lore", "1994_longterm", "1994_data_plot_totals.csv"), row.names = F)


