library(dplyr)

rats <- portalr::summarise_individual_rodents(clean = T, type = "Rodents", length = "all", unknowns = FALSE, time = "all", fillweight = T)

rats <- rats %>%
  filter(censusdate < "1991-02-01",
         censusdate > "1977-07-01") %>%
  filter(plot %in% c(3, 8, 11, 12, 14, 15, 19, 21, 6, 13, 18, 20, 2, 4, 17, 22)) %>%
  mutate(trtmnt_1977 = ifelse(
    plot %in% c(8, 11, 12, 14),
    "control",
    ifelse(plot %in% c(3, 15, 19, 21),
           "exclosure",
           NA)),
    trtmnt_1988 = ifelse(
      plot %in% c(6, 13, 18, 20),
      "exclosure",
      ifelse(plot %in% c(2, 4, 17, 22),
             "control",
             NA)))

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

orig_rats_totals <- rats %>%
  filter(!is.na(trtmnt_1977)) %>%
  group_by(censusdate, period, type, trtmnt_1977) %>%
  summarize(nind = dplyr::n(),
            biomass = sum(wgt, na.rm = T),
            energy = sum(energy, na.rm = T)) %>%
  ungroup()

orig_rats_all_possible <- expand.grid(period = unique(rats$period), trtmnt_1977 = unique(orig_rats_totals$trtmnt_1977), type = unique(rats$type)) 

orig_rats_zeros <- left_join(orig_rats_all_possible, select(orig_rats_totals, period, censusdate)) %>%
  distinct() %>%
  left_join(orig_rats_totals) %>%
  mutate(nind = ifelse(is.na(nind), 0, nind),
         biomass = ifelse(is.na(biomass), 0, biomass),
         energy = ifelse(is.na(energy), 0, energy))

write.csv(orig_rats_zeros, here::here("lore", "1994_longterm", "1994_data_statevars_1977.csv"), row.names = F)

repeat_rats_totals <- rats %>%
  filter(!is.na(trtmnt_1988)) %>%
  group_by(censusdate, period, type, trtmnt_1988) %>%
  summarize(nind = dplyr::n(),
            biomass = sum(wgt, na.rm = T),
            energy = sum(energy, na.rm = T)) %>%
  ungroup()


repeat_rats_all_possible <- expand.grid(period = unique(rats$period), trtmnt_1988 = unique(repeat_rats_totals$trtmnt_1988), type = unique(rats$type)) 

repeat_rats_zeros <- left_join(repeat_rats_all_possible, select(repeat_rats_totals, period, censusdate)) %>%
  distinct() %>%
  left_join(repeat_rats_totals) %>%
  mutate(nind = ifelse(is.na(nind), 0, nind),
         biomass = ifelse(is.na(biomass), 0, biomass),
         energy = ifelse(is.na(energy), 0, energy))

write.csv(repeat_rats_zeros, here::here("lore", "1994_longterm", "1994_data_statevars_1988.csv"), row.names = F)

rats <- read.csv(here::here("lore", "1994_longterm", "1994_data_complete.csv"), stringsAsFactors = F) 

rat_plot_totals <- rats  %>%
  group_by(plot, period, type) %>%
  summarize(nind = dplyr::n(),
            biomass = sum(wgt, na.rm= T),
            energy = sum(energy, na.rm = T)) %>%
  ungroup()


rats_all_possible <- expand.grid(period = unique(rat_plot_totals$period), type = unique(rat_plot_totals$type), plot = unique(rat_plot_totals$plot))

rats_plot_zeros <- rats_all_possible %>%
  left_join(rat_plot_totals) %>%
  mutate(nind = ifelse(is.na(nind), 0, nind),
         biomass = ifelse(is.na(biomass), 0, biomass),
         energy = ifelse(is.na(energy), 0, energy))

rats_plot_types <- rats %>%
  select(plot, trtmnt_1977, trtmnt_1988) %>%
  distinct() %>%
  mutate(plot_type = ifelse(trtmnt_1977 == "exclosure", "orig_exclosure",
    ifelse(trtmnt_1977 == "control", "orig_control", NA))) %>%
  mutate(plot_type = ifelse(is.na(plot_type), ifelse(trtmnt_1988 == "exclosure", "second_exclosure",
                                                     ifelse(trtmnt_1988 == "control", "second_control", NA)), plot_type)) %>%
  select(plot, plot_type)


rats_plot_zeros <- left_join(rats_plot_zeros, rats_plot_types)

write.csv(rats_plot_zeros, here::here("lore", "1994_longterm", "1994_data_plot_totals.csv"), row.names = F)


