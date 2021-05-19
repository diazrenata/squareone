library(portalr)
library(dplyr)
library(ggplot2)
theme_set(theme_bw())

weather <- weather(level = "monthly", fill = T)

weather <- weather %>%
  dplyr::mutate(date = format(lubridate::parse_date_time(paste(month, year, sep=" "),
                                                         orders = c("m/Y")), "%m-%Y")) %>%
  dplyr::mutate(date = as.Date(paste("01",date,sep="-"), format="%d-%m-%Y"))  %>%
  mutate(numdate = as.numeric(date))


weather_full <- expand.grid(year = c(min(weather$year) : max(weather$year)),
                            month = c(1:12)
) %>%
  left_join(mutate(weather, month = as.numeric(month), year = as.numeric(year))) %>%
  mutate(datestr = paste0(year, "-01-", month)) %>%
  mutate(newdate = as.Date(datestr, format = "%Y-%d-%m")) %>%
  arrange(newdate)


### deseasonal weather

precip_ts <- ts(weather_full$precipitation, start = weather_full$newdate[1], frequency = 12)

precip_ts_interp <- imputeTS::na_interpolation(precip_ts)

precip_decomp <- decompose(precip_ts_interp, type = "additive")


meantemp_ts <- ts(weather_full$meantemp, start = weather_full$newdate[1], frequency = 12)

meantemp_ts_interp <- imputeTS::na_interpolation(meantemp_ts)

meantemp_decomp <- decompose(meantemp_ts_interp, type = "additive")



mintemp_ts <- ts(weather_full$mintemp, start = weather_full$newdate[1], frequency = 12)

mintemp_ts_interp <- imputeTS::na_interpolation(mintemp_ts)

mintemp_decomp <- decompose(mintemp_ts_interp, type = "additive")



maxtemp_ts <- ts(weather_full$maxtemp, start = weather_full$newdate[1], frequency = 12)

maxtemp_ts_interp <- imputeTS::na_interpolation(maxtemp_ts)

maxtemp_decomp <- decompose(maxtemp_ts_interp, type = "additive")

w_noseas <- weather_full %>%
  mutate(precip_no_seasonal = as.numeric(precip_decomp$trend) + as.numeric(precip_decomp$random),
         precip_trend= as.numeric(precip_decomp$trend),
         meantemp_no_seasonal = as.numeric(meantemp_decomp$trend) + as.numeric(meantemp_decomp$random),
         meantemp_trend= as.numeric(meantemp_decomp$trend),
         maxtemp_no_seasonal = as.numeric(maxtemp_decomp$trend) + as.numeric(maxtemp_decomp$random),
         maxtemp_trend= as.numeric(maxtemp_decomp$trend),
         mintemp_no_seasonal = as.numeric(mintemp_decomp$trend) + as.numeric(mintemp_decomp$random),
         mintemp_trend= as.numeric(mintemp_decomp$trend)) %>%
  mutate(era = ifelse(year < 1988, "a", ifelse(year < 1996, "b", ifelse(year < 2010, "c", "d")))) %>%
  mutate(fiveyr =(ceiling( (year - 1979) / 6)) * 6 + 1978) %>%
  mutate(fiveyr_f = ordered(fiveyr))

### plot of precip x temp

ggplot(w_noseas, aes(precip_trend, meantemp_trend, color = fiveyr_f)) +
  geom_point(size = 3) +
  scale_color_viridis_d() +
  facet_wrap(vars(fiveyr_f))


ggplot(w_noseas, aes(precip_trend, maxtemp_trend, color = fiveyr_f)) +
  geom_point(size = 3) +
  scale_color_viridis_d() +
  facet_wrap(vars(fiveyr_f))



ggplot(w_noseas, aes(precip_trend, mintemp_trend,  color = fiveyr_f)) +
  geom_point(size = 3) +
  scale_color_viridis_d() +
  facet_wrap(vars(fiveyr_f))


# IDK how informative those are.

### water year cv of precip


wateryr <- w_noseas %>%
  mutate(water_year = ifelse(month < 4, year - 1, year)) %>%
  filter(water_year %in% c(1981:2020)) %>% # only get compete years
  mutate(wateryr_fiveyr = ceiling((water_year - 1980) / 5) * 5 + 1978)

wateryr_cv <- wateryr %>%
  group_by(water_year, wateryr_fiveyr) %>%
  summarize(mean_precip = mean(precipitation),
            sd_precip = sd(precipitation),
            n_precip = dplyr::n(),
            mean_precip_noseas = mean(precip_no_seasonal),
            sd_precip_noseas = sd(precip_no_seasonal),
            n_precip_noseas = dplyr::n(),
            mean_precip_trend = mean(precip_trend),
            sd_precip_trend = sd(precip_trend),
            n_precip_trend = dplyr::n()) %>%
  ungroup() %>%
  mutate(cv_precip = sd_precip / mean_precip,
         cv_precip_noseas = sd_precip_noseas / mean_precip_noseas,
         cv_precip_trend = sd_precip_trend / mean_precip_trend)

wateryr_fiveyr_cv <- wateryr %>%
  group_by(wateryr_fiveyr) %>%
  summarize(mean_precip = mean(precipitation),
            sd_precip = sd(precipitation),
            n_precip = dplyr::n(),
            mean_precip_noseas = mean(precip_no_seasonal),
            sd_precip_noseas = sd(precip_no_seasonal),
            n_precip_noseas = dplyr::n(),
            mean_precip_trend = mean(precip_trend),
            sd_precip_trend = sd(precip_trend),
            n_precip_trend = dplyr::n()) %>%
  ungroup() %>%
  mutate(cv_precip = sd_precip / mean_precip,
         cv_precip_noseas = sd_precip_noseas / mean_precip_noseas,
         cv_precip_trend = sd_precip_trend / mean_precip_trend) %>%
  right_join(select(wateryr, water_year, wateryr_fiveyr))

ggplot(wateryr_fiveyr_cv, aes(wateryr_fiveyr, cv_precip)) +
  geom_line()

ggplot(wateryr_fiveyr_cv, aes(wateryr_fiveyr, mean_precip)) +
  geom_line()

ggplot(wateryr_cv, aes(water_year, cv_precip)) +
  geom_line() +
  geom_line(data = wateryr_fiveyr_cv, aes(y =cv_precip), inherit.aes = T, color = "green")

ggplot(wateryr_cv, aes(water_year, mean_precip)) +
  geom_line()


ggplot(wateryr_cv, aes(water_year, cv_precip_noseas)) +
  geom_line() 

ggplot(wateryr_cv, aes(water_year, mean_precip_noseas)) +
  geom_line() 


ggplot(wateryr_cv, aes(water_year, cv_precip_trend)) +
  geom_line() 

ggplot(wateryr_cv, aes(water_year, mean_precip_trend)) +
  geom_line() 



ggplot(wateryr_cv, aes(mean_precip, cv_precip, color = water_year)) +
  geom_point(size =3) +
  scale_color_viridis_c()


#### water year seasonal ####

wateryr_s_cv <- wateryr %>%
  mutate(season = ifelse(month %in% c(4:9), "summer", "winter")) %>%
  group_by(water_year, season) %>%
  summarize(mean_precip = mean(precipitation),
            sd_precip = sd(precipitation),
            n_precip = dplyr::n(),
            mean_precip_noseas = mean(precip_no_seasonal),
            sd_precip_noseas = sd(precip_no_seasonal),
            n_precip_noseas = dplyr::n(),
            mean_precip_trend = mean(precip_trend),
            sd_precip_trend = sd(precip_trend),
            n_precip_trend = dplyr::n()) %>%
  ungroup() %>%
  mutate(cv_precip = sd_precip / mean_precip,
         cv_precip_noseas = sd_precip_noseas / mean_precip_noseas,
         cv_precip_trend = sd_precip_trend / mean_precip_trend)

ggplot(wateryr_s_cv, aes(water_year, cv_precip, color = season)) +
  geom_line() +
  facet_wrap(vars(season), ncol = 1, scales = "free_y") 


ggplot(wateryr_s_cv, aes(water_year, mean_precip, color = season)) +
  geom_line() +
  facet_wrap(vars(season), ncol = 1, scales = "free_y")

  ggplot(wateryr_s_cv, aes(water_year, cv_precip_noseas, color = season)) +
  geom_line() +
  facet_wrap(vars(season), ncol = 1, scales = "free_y")

ggplot(wateryr_cv, aes(water_year, mean_precip_noseas)) +
  geom_line() 


ggplot(wateryr_s_cv, aes(water_year, cv_precip_trend, color = season)) +
  geom_line() +
  facet_wrap(vars(season), ncol = 1, scales = "free_y")


ggplot(wateryr_s_cv, aes(water_year, mean_precip_trend, color = season)) +
  geom_line() 
+
  facet_wrap(vars(season), ncol = 1, scales = "free_y")

