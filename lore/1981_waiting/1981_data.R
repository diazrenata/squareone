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

write.csv(rats, here::here("lore", "waiting", "1981_data_complete.csv"), row.names = F)

rats_totals <- rats %>%
  group_by(year, month, period, brown_trtmnt, type) %>%
  summarize(nind = dplyr::n(),
            biomass = sum(wgt, na.rm = T)) %>%
  ungroup()

rats_all_possible <- expand.grid(period = unique(rats$period), brown_trtmnt = unique(rats$brown_trtmnt), type = unique(rats$type)) 

rats_zeros <- left_join(rats_all_possible, select(rats_totals, period, year, month)) %>%
  distinct() %>%
  left_join(rats_totals) %>%
  mutate(nind = ifelse(is.na(nind), 0, nind),
         biomass = ifelse(is.na(biomass), 0, biomass))

write.csv(rats_zeros, here::here("lore", "waiting", "1981_data_statevars.csv"), row.names = F)

