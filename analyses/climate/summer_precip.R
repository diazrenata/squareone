library(portalr)
library(ggplot2)
library(dplyr)


weather <- weather()
summer <- filter(weather, month %in% c(4:9)) %>%
  group_by(year) %>%
  filter(!is.na(precipitation)) %>%
  summarize(total_precip = sum(precipitation),
            mean_precip = mean(precipitation),
            n_records = dplyr::n()) %>%
  ungroup() %>%
  mutate(era = ifelse(year < 1996, "a_pre_ba", ifelse(year < 2010, "b_ba", "c_post_ba"))) %>%
  filter(year < 2021)

ggplot(summer, aes(year, mean_precip)) +
  geom_line() +
  facet_grid(cols = vars(era), scales = "free_x", space = "free_x")

summer %>%
  group_by(era) %>%
  summarize(mean_precip = mean(mean_precip))
