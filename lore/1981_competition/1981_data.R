library(dplyr)

rats <- portalr::summarise_individual_rodents(clean = T, type = "Rodents", length = "all", unknowns = FALSE, time = "all", fillweight = T)

rats <- rats %>%
  filter(censusdate < "1980-07-01",
         censusdate > "1977-07-01") %>%
  filter(plot %in% c(3, 8, 11, 12, 14, 15, 19, 21)) %>%
  mutate(brown_trtmnt = ifelse(
    plot %in% c(8, 11, 12, 14),
    "dipo_present",
    "dipo_absent"
  ))

species <-  portalr::load_rodent_data()$species_table

rats <- rats %>%
  left_join(select(species, species, granivore))

rats <- rats %>% 
  mutate(omnivore = as.numeric(!granivore))

rats <- rats %>%
  mutate(small_granivore = species %in% c("PP", "PF", "PM", "RM"),
         small_omnivore = species %in% c("OL", "OT", "PE"),
         dipo = species %in% c("DM", "DO", "DS"))

rats <- rats %>%
  mutate(offset_year = ifelse(
    month >= 7,
    year,
    year - 1
  ))

rats <- rats %>%
  mutate(type = ifelse(
    dipo, "dipo", ifelse(
      small_granivore, "small_granivore",
      ifelse(
        small_omnivore, "small_omnivore", "other"
      )
    )
  ))

rats <- rats %>%
  mutate(energy = 5.69 * (wgt^0.75))

write.csv(rats, here::here("lore", "1981_competition", "1981_data_complete.csv"), row.names = F)

rats_totals <- rats %>%
  group_by(year, month, period, brown_trtmnt, type) %>%
  summarize(nind = dplyr::n(),
            biomass = sum(wgt, na.rm = T),
            energy = sum(energy, na.rm = T)) %>%
  ungroup()

rats_all_possible <- expand.grid(period = unique(rats$period), brown_trtmnt = unique(rats$brown_trtmnt), type = unique(rats$type)) 

rats_zeros <- left_join(rats_all_possible, select(rats_totals, period, year, month)) %>%
  distinct() %>%
  left_join(rats_totals) %>%
  mutate(nind = ifelse(is.na(nind), 0, nind),
         biomass = ifelse(is.na(biomass), 0, biomass),
         energy = ifelse(is.na(energy), 0, energy))

write.csv(rats_zeros, here::here("lore", "1981_competition", "1981_data_statevars.csv"), row.names = F)


rats <- read.csv(here::here("lore", "1981_competition", "1981_data_complete.csv"), stringsAsFactors = F) %>%
  mutate(plot = ordered(plot))

rat_plot_totals <- rats  %>%
  group_by(type, brown_trtmnt, period, plot) %>%
  summarize(nind = dplyr::n())


rats_all_possible <- expand.grid(period = unique(rat_plot_totals$period), type = unique(rat_plot_totals$type), plot = unique(rat_plot_totals$plot)) %>%
  ungroup() %>%
  left_join(distinct(select(rats, plot, brown_trtmnt)))

rats_plot_zeros <- rats_all_possible %>%
  left_join(rat_plot_totals) %>%
  mutate(nind = ifelse(is.na(nind), 0, nind)) %>%
  mutate(krat_treatment = ifelse(brown_trtmnt == "dipo_present", "control", "exclosure")) %>%
  mutate(okrat_treatment = ordered(krat_treatment))

write.csv(rats_plot_zeros, here::here("lore", "1981_competition", "1981_data_plot_totals.csv"), row.names = F)


