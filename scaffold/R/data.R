get_rodent_data <- function(use_christensen_plots = F, return_plot = F) {
  
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
  
  write.csv(plot_level_totals, row.names = F, here::here("scaffold", "Data", which_dir,  "plot_total_e.csv"))
  
  
  treatment_means <- plot_level_totals %>%
    dplyr::group_by(period, censusdate, era, plot_type) %>%
    dplyr::summarize(total_e = mean(total_e),
                     dipo_e = mean(dipo_e),
                     smgran_e = mean(smgran_e),
                     pb_e = mean(pb_e),
                     pp_e = mean(pp_e),
                     nplots = dplyr::n()) %>%
    dplyr::ungroup() 
  
  
  write.csv(treatment_means, row.names = F, here::here("scaffold", "Data", which_dir, "treatment_mean_e.csv"))
  
  if(return_plot) {
    return(plot_level_totals) 
  }
  return(treatment_means)
}

get_total_energy_ratios <- function(treatment_data) {
  
  control_values <- dplyr::filter(treatment_data, plot_type == "CC") %>%
    select(period, total_e) %>%
    rename(total_e_c = total_e)
    
  treatment_data <- left_join(treatment_data, control_values)
  
  treatment_of_control <- treatment_data %>% 
    left_join(control_values) %>%
    mutate(total_e_of_c = total_e / total_e_c) %>%
    select(period, censusdate, era, plot_type, total_e_of_c)

  }