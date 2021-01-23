library(dplyr)

rats <- portalr::summarise_individual_rodents(clean = T, type = "Rodents", length = "all", unknowns = FALSE, time = "all", fillweight = T)

rats <- rats %>%
  filter(censusdate < "2015-01-01",
         censusdate > "1977-07-01") %>%
  filter(plot %in% c(2,3,4,8,11,14,15,17,19,21,22)) %>%
  mutate(treatment = ifelse(
    plot %in% c(2,8,22), "new_exclosure",
    ifelse(
      plot %in% c(3, 15, 19, 21), "orig_exclosure",
      ifelse(plot %in% c(4,11,14,17), "control", NA)
    )
  ))

species <-  portalr::load_rodent_data()$species_table

rats <- rats %>%
  mutate(small_granivore = species %in% c("BA", "PB", "PP", "PF", "PE", "PL", "PM", "RF", "RM", "RO"),
         dipo = species %in% c("DM", "DO", "DS"))

rats <- rats %>%
  mutate(type = ifelse(
    dipo, "dipo", ifelse(
      small_granivore, "small_granivore",
     "other"
      )
    )
  )

rats <- rats %>%
  mutate(energy = 5.69 * (wgt^0.75))

write.csv(rats, here::here("lore", "2020_redux", "2020_data_complete.csv"), row.names = F)


rats <- portalr::summarise_individual_rodents(clean = T, type = "Rodents", length = "all", unknowns = FALSE, time = "all", fillweight = T)

rats <- rats %>%
  filter(         censusdate > "1977-07-01") %>%
  filter(plot %in% c(5,6,7,11,13,14,17,18,24)) %>%
  mutate(treatment = ifelse(
    plot %in% c(6, 13, 18), "EC",
    ifelse(
      plot %in% c(5, 7, 24), "XC",
      ifelse(plot %in% c(11,14,17), "CC", NA)
    )
  ))

species <-  portalr::load_rodent_data()$species_table

rats <- rats %>%
  mutate(small_granivore = species %in% c("BA", "PB", "PP", "PF", "PE", "PL", "PM", "RF", "RM", "RO"),
         dipo = species %in% c("DM", "DO", "DS"))

rats <- rats %>%
  mutate(type = ifelse(
    dipo, "dipo", ifelse(
      small_granivore, "small_granivore",
      "other"
    )
  )
  )

rats <- rats %>%
  mutate(energy = 5.69 * (wgt^0.75))

write.csv(rats, here::here("lore", "2020_redux", "christensen_plots.csv"), row.names = F)

