
add_intercept <- function(val, fact_val) {
  if(fact_val == "dipo_absent") {
    return(val + n_gam$coefficients["(Intercept)"])
  } else {
    return(val)
  }
}

n_gam_confint <- confint(n_gam, "s(period)") %>%
  group_by_all() %>%
  mutate(est = add_intercept(est, fact_val = brown_trtmnt),
         upper = add_intercept(upper, fact_val = brown_trtmnt),
         lower = add_intercept(lower, fact_val = brown_trtmnt)) #%>%
#mutate_at(vars(est, upper, lower), .funs = n_gam$family$linkinv)


ggplot(n_gam_confint, aes(period, est, color = brown_trtmnt)) +
  geom_line() +
  theme_bw() +
  scale_color_viridis_d(end = .8) +
  scale_fill_viridis_d(end = .8) +
  #geom_point(data = n_gam_fitted, aes(period, fitted, color = brown_trtmnt)) +
  geom_ribbon(aes(period, ymin = lower, ymax = upper, fill =brown_trtmnt), alpha = .5)


n_gam_confint_noint <- confint(n_gam, "s(period)") 


ggplot(n_gam_confint_noint, aes(period, est, color = brown_trtmnt)) +
  geom_line() +
  theme_bw() +
  scale_color_viridis_d(end = .8) +
  scale_fill_viridis_d(end = .8) +
  geom_ribbon(aes(period, ymin = lower, ymax = upper, fill =brown_trtmnt), alpha = .5)

