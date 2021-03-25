make_pdat <- function(orig_dat, np = 500, include_plot = F) {
  
  pdat <- as.data.frame(expand.grid(period = seq(min(orig_dat$period), max(orig_dat$period), length.out= np), okrat_treatment = levels(orig_dat$okrat_treatment))) 
  
  pdat$type <- orig_dat$type[1]
  
  if(include_plot) {
    pdat$oplot <- levels(orig_dat$oplot)[1]
  }
  
  return(pdat)
}

get_predicted_vals <- function(mod, pdat) {
  linkpred <- predict(mod, newdata = pdat, type = "link", se.fit = T)
  
  pdat.pred <- pdat %>%
    mutate(link = linkpred$fit,
           se_link = linkpred$se.fit) %>%
    mutate(invlink_fit = mod$family$linkinv(link),
           invlink_upper = mod$family$linkinv(link + (2 * se_link)),
           invlink_lower = mod$family$linkinv(link - (2 * se_link)),
           link_upper = link + (2 * se_link),
           link_lower = link - (2 * se_link))
  
  return(pdat.pred)
}

get_exclosure_diff <- function(mod, pdat) {
  
  modlp <- predict(mod, newdata = pdat, type = "lpmatrix")
  
  ctrl_rows <- which(pdat$okrat_treatment == "control")
  
  exclosure_rows <- which(pdat$okrat_treatment == "exclosure")
  
  moddiff <- modlp[ctrl_rows, ] - modlp[exclosure_rows, ]
  
  diffvals <- moddiff %*% coef(mod)
  
  diffse<- sqrt(rowSums((moddiff %*% vcov(mod, unconditional = FALSE)) * moddiff))
  
  crit <- qnorm(.05/2, lower.tail = FALSE)
  upr <- diffvals + (crit * diffse)
  lwr <- diffvals - (crit * diffse)
  
  pdat.diff <- pdat %>%
    select(period, type) %>%
    distinct()%>%
    mutate(fitted_dif = diffvals,
           upper= upr,
           lower = lwr) %>%
    mutate(diff_overlaps_zero = (upper * lower) < 0
    )
  
  return(pdat.diff)
}

plot_link_pred <- function(pdat.pred) {
  
  linkplot <- ggplot(pdat.pred, aes(period, link, color = okrat_treatment, fill = okrat_treatment)) +
    geom_line() +
    geom_ribbon(aes(ymin = link_lower, ymax = link_upper), alpha = .5) +
    theme_bw() +
    scale_color_viridis_d(end = .8) +
    scale_fill_viridis_d(end = .8)+
    ggtitle(pdat.pred$type[1]) +
    theme(legend.position = "top")
  
  
  if("diff_overlaps_zero" %in% colnames(pdat.pred)) {
    linkplot <- linkplot +
      geom_point(data = filter(pdat.pred, diff_overlaps_zero), aes(period, 1), color  = "red", size = 2) 
  }
  
  return(linkplot)
  
}


plot_fitted_pred <- function(pdat.pred) {
  
  fitplot <- ggplot(pdat.pred, aes(period, invlink_fit, color = okrat_treatment, fill = okrat_treatment)) +
    geom_line() +
    geom_ribbon(aes(ymin = invlink_lower, ymax = invlink_upper), alpha = .5) +
    theme_bw() +
    scale_color_viridis_d(end = .8) +
    scale_fill_viridis_d(end = .8)+
    ggtitle(pdat.pred$type[1]) +
    theme(legend.position = "top")
  
  
  if("diff_overlaps_zero" %in% colnames(pdat.pred)) {
    fitplot <- fitplot +
      geom_point(data = filter(pdat.pred, diff_overlaps_zero), aes(period, 0), color  = "red", size = 2) 
  }
  
  return(fitplot)
  
}

plot_exclosure_diff <- function(pdat.diff) {
  diffplot <- ggplot(pdat.diff, aes(period, fitted_dif)) +
    geom_line() +
    geom_ribbon(aes(ymin = lower, ymax = upper), alpha = .5) +
    theme_bw() +
    geom_hline(yintercept = 0)+
    ggtitle(pdat.diff$type[1])
  
  return(diffplot)
}

add_exclosure_diff <- function(pdat.pred, pdat.diff) {
  
  pdat.pred <- left_join(pdat.pred, select(pdat.diff, period, diff_overlaps_zero))
  
  return(pdat.pred)
}

plot_orig_data <- function(orig_dat) {
  
 return(ggplot(orig_dat, aes(period, nind, color= okrat_treatment)) +
    geom_line() +
    geom_point() +
    theme_bw() +
    scale_color_viridis_d(end = .8) +
    ggtitle(orig_dat$type[1]) +
      theme(legend.position = "top")
 )
}