get_rodent_data <- function(use_christensen_plots = F, return_plot = F, save_csv = F) {
  
  plot_level <- portalr::energy(clean = T,
                                level = "Plot",
                                type = "Granivores", # this removes NA, OL, OT, ...cotton rats, perhaps?
                                plots = "all",
                                unknowns = F,
                                shape = "crosstab",
                                time = "all",
                                na_drop = T,
                                zero_drop = F,
                                min_traps = 45, # allow partially trapped plots - 45 or 47, of 49, plots. Necessary bc apparently plot 24 was often trapped to 47 for the 2010s.
                                min_plots = 24,
                                effort = T
  ) %>%
    
    dplyr::mutate(era = NA) %>%
    dplyr::mutate(era = ifelse(period <= 216, "a_pre_ba",
                               ifelse(period <= 356, "b_pre_cpt",
                                      ifelse(period <= 434, "c_pre_switch", "d_post-switch")))) 
  
  
  
  if(use_christensen_plots) {
    which_plots <-  c(5,6,7,11,13,14,17,18,24)
    which_dir <- "Ch2019"
  } else {
    which_plots <- c(2,3,4,8,11,14,15,17,19,22)
    which_dir <- "Diaz"
  }
  
  
  
  if(use_christensen_plots) {
    plot_level <- plot_level %>%
      dplyr::filter(plot %in% which_plots,
                    period > 118) %>%
      dplyr::mutate(plot_type =
                      ifelse(plot %in% c(5, 7, 24), "XC", # removal -> control
                             ifelse(plot %in% c(6, 13, 18), "EC", # exclosure -> control
                                    ifelse(plot %in% c(11, 14, 17), "CC", NA)))) # control 
  } else {
    plot_level <- plot_level %>%
      dplyr::filter(plot %in% which_plots) %>%
      dplyr::mutate(plot_type = 
                      ifelse(plot %in% c(2, 8, 22), "CE", # control -> exclosure
                             ifelse(plot %in% c(3, 15, 19, 21), "EE", # exclosure
                                    ifelse(plot %in% c(4, 11, 14, 17), "CC", NA))))  # control
  }
  
  
  rodent_names <- c('BA','DM','DO','DS','PB','PE','PF','PH','PI','PL','PM','PP','RF','RM','RO')
  dipo_names <- c('DM', 'DO', 'DS')
  smgran_names <- c('BA','PB','PE','PF','PH','PI','PL','PM','PP','RF','RM','RO')
  
  plot_level_totals <- plot_level %>%
    dplyr::mutate(total_e = rowSums(.[rodent_names]),
                  dipo_e = rowSums(.[dipo_names]),
                  smgran_e = rowSums(.[smgran_names]),
                  pb_e = PB,
                  pp_e = PP) %>%
    dplyr::select(period, censusdate, era, plot, plot_type, total_e, dipo_e, smgran_e, pb_e, pp_e) %>%
    dplyr::mutate(censusdate = as.Date(censusdate),
    )
  
  
  treatment_means <- plot_level_totals %>%
    dplyr::group_by(period, censusdate, era, plot_type) %>%
    dplyr::summarize(total_e = mean(total_e),
                     dipo_e = mean(dipo_e),
                     smgran_e = mean(smgran_e),
                     pb_e = mean(pb_e),
                     pp_e = mean(pp_e),
                     nplots = dplyr::n()) %>%
    dplyr::ungroup() 
  
  if(save_csv) {
    write.csv(plot_level_totals, row.names = F, here::here("scaffold", "Data", which_dir,  "plot_total_e.csv"))
    
    write.csv(treatment_means, row.names = F, here::here("scaffold", "Data", which_dir, "treatment_mean_e.csv"))
  }
  if(return_plot) {
    return(plot_level_totals) 
  }
  return(treatment_means)
}

get_total_energy_ratios <- function(treatment_data) {
  
  control_values <- dplyr::filter(treatment_data, plot_type == "CC") %>%
    select(period, total_e) %>%
    rename(total_e_c = total_e)
  
  treatment_of_control <- treatment_data %>% 
    left_join(control_values) %>%
    mutate(total_e_of_c = total_e / total_e_c) 
  
}

get_unique_inds <- function(use_christensen_plots = F, return_plot = F, save_csv = F){

  inds <- portalr::summarise_individual_rodents(clean = T,
                                                type = "Granivores",
                                                length = "all",
                                                unknowns = F,
                                                time = "all",
                                                fillweight = TRUE,
                                                min_plots = 24,
                                                min_traps = 45) %>%
    filter(!is.na(species)) %>%
    mutate(censusmonth = as.integer(format.Date(censusdate, "%m")),
           censusyear = as.integer(format.Date(censusdate, "%Y"))) %>%
    mutate(wateryear = ifelse(censusmonth %in% c(4:12), censusyear, censusyear - 1)) 
  
  inds_unique <- inds %>%
    group_by(treatment, plot, species, wateryear, tag, period) %>%
    mutate(nas_each_period = sum(is.na(tag))) %>%
    ungroup() %>%
    group_by(treatment, plot, species, wateryear, tag) %>%
    summarize(ncaptures = dplyr::n(),
              mean_wgt = mean(wgt),
              max_nas = max(nas_each_period)) %>%
    ungroup() %>%
    group_by(treatment, plot, species, wateryear) %>%
    mutate(ntags = length(unique(tag))) %>%
    ungroup() %>%
    filter(wateryear != 2012) # see github, 2012 has a period when non-krats are not being tagged

  plot_energy <- inds_unique %>%
    mutate(energy = 5.69 * (mean_wgt ^ .75)) %>%
    mutate(tag_total_energy = ifelse(is.na(tag), max_nas * energy, energy)) %>%
    group_by(treatment, plot, species, wateryear) %>%
    summarize(energy = sum(tag_total_energy)) %>%
    ungroup() 
 
  all_plots_all_years <- expand.grid(plot = c(1:24), wateryear = unique(inds$wateryear)) %>%
    filter(wateryear != 2012) %>%
    left_join(distinct(select(plot_energy, plot, wateryear, treatment)))
  
  
  plot_energy_allyears <- right_join(plot_energy, all_plots_all_years) %>%
    tidyr::pivot_wider(id_cols = c(treatment, plot, wateryear), names_from = species, values_from = energy, values_fill = 0) %>% 
    dplyr::mutate(era = NA) %>%
    dplyr::mutate(era = ifelse(wateryear <= 1995, "a_pre_ba",
                               ifelse(wateryear <= 2009, "b_pre_cpt",
                                      ifelse(wateryear <= 2014, "c_pre_switch", "d_post-switch")))) 
  
  
  
  if(use_christensen_plots) {
    which_plots <-  c(5,6,7,11,13,14,17,18,24)
    which_dir <- "Ch2019"
  } else {
    which_plots <- c(2,3,4,8,11,14,15,17,19,22)
    which_dir <- "Diaz"
  }
  
  
  
  if(use_christensen_plots) {
    plot_energy_allyears <- plot_energy_allyears %>%
      dplyr::filter(plot %in% which_plots,
                    period > 118) %>%
      dplyr::mutate(plot_type =
                      ifelse(plot %in% c(5, 7, 24), "XC", # removal -> control
                             ifelse(plot %in% c(6, 13, 18), "EC", # exclosure -> control
                                    ifelse(plot %in% c(11, 14, 17), "CC", NA)))) # control 
  } else {
    plot_energy_allyears <- plot_energy_allyears %>%
      dplyr::filter(plot %in% which_plots) %>%
      dplyr::mutate(plot_type = 
                      ifelse(plot %in% c(2, 8, 22), "CE", # control -> exclosure
                             ifelse(plot %in% c(3, 15, 19, 21), "EE", # exclosure
                                    ifelse(plot %in% c(4, 11, 14, 17), "CC", NA))))  # control
  }
  
  
  rodent_names <- c('BA','DM','DO','DS','PB','PE','PF','PH','PI','PL','PM','PP','RF','RM','RO')
  dipo_names <- c('DM', 'DO', 'DS')
  smgran_names <- c('BA','PB','PE','PF','PH','PI','PL','PM','PP','RF','RM','RO')
  
  plot_level_totals <- plot_energy_allyears %>%
    dplyr::mutate(total_e = rowSums(.[rodent_names]),
                  dipo_e = rowSums(.[dipo_names]),
                  smgran_e = rowSums(.[smgran_names]),
                  pb_e = PB,
                  pp_e = PP) %>%
    dplyr::select(wateryear, era, plot, plot_type, total_e, dipo_e, smgran_e, pb_e, pp_e)
  
  
  treatment_means <- plot_level_totals %>%
    dplyr::group_by(wateryear, era, plot_type) %>%
    dplyr::summarize(total_e = mean(total_e),
                     dipo_e = mean(dipo_e),
                     smgran_e = mean(smgran_e),
                     pb_e = mean(pb_e),
                     pp_e = mean(pp_e),
                     nplots = dplyr::n()) %>%
    dplyr::ungroup() 
  
  if(save_csv) {
    write.csv(plot_level_totals, row.names = F, here::here("scaffold", "Data", which_dir,  "uniqueind_plot_total_e.csv"))
    
    write.csv(treatment_means, row.names = F, here::here("scaffold", "Data", which_dir, "uniqueind_treatment_mean_e.csv"))
  }
  if(return_plot) {
    return(plot_level_totals) 
  }
  return(treatment_means)
}