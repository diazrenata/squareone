make_pdat <- function(orig_dat, np = 500, include_plot = F, comparison_variable = "treatment") {
  
    
  pdat <- as.data.frame(expand.grid(period = seq(min(orig_dat$period), max(orig_dat$period), length.out= np), compare_var = levels(orig_dat[, comparison_variable]))) 
  
  pdat$type <- orig_dat$type[1]
  
  colnames(pdat)[ which(colnames(pdat) == "compare_var")] <- comparison_variable
  
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

get_exclosure_diff <- function(mod, pdat, comparison_variable = "treatment", reference_level = 1, comparison_level = 2) {
  
  modlp <- predict(mod, newdata = pdat, type = "lpmatrix")
  
  reference_rows <- which(pdat[,comparison_variable] == levels(pdat[,comparison_variable])[reference_level])
  
 comparison_rows <- which(pdat[,comparison_variable] ==levels(pdat[,comparison_variable])[comparison_level])
  
 if(length(reference_rows) == 0) {
   
   
   reference_rows <- which(pdat[,comparison_variable] == levels(pdat[,comparison_variable][[1]])[reference_level])
   
   comparison_rows <- which(pdat[,comparison_variable] ==levels(pdat[,comparison_variable][[1]])[comparison_level])
 }
 
  moddiff <- modlp[reference_rows, ] - modlp[comparison_rows, ]
  
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

plot_link_pred <- function(pdat.pred, comparison_variable = "treatment") {
  colnames(pdat.pred) [ which(colnames(pdat.pred) == comparison_variable)] <- "compare_var"
  
  linkplot <- ggplot(pdat.pred, aes(period, link, color = compare_var, fill = compare_var)) +
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


plot_fitted_pred <- function(pdat.pred, comparison_variable = "treatment") {
  colnames(pdat.pred) [ which(colnames(pdat.pred) == comparison_variable)] <- "compare_var"
  fitplot <- ggplot(pdat.pred, aes(period, invlink_fit, color = compare_var, fill = compare_var)) +
    geom_line() +
    geom_ribbon(aes(ymin = invlink_lower, ymax = invlink_upper), alpha = .5) +
    theme_bw() +
    scale_color_viridis_d(end = .8) +
    scale_fill_viridis_d(end = .8)+
    ggtitle(pdat.pred$type[1]) +
    theme(legend.position = "top")
  
  
  if("diff_overlaps_zero" %in% colnames(pdat.pred)) {
    if(any(pdat.pred$diff_overlaps_zero)) {
    fitplot <- fitplot +
      geom_point(data = filter(pdat.pred, diff_overlaps_zero), aes(period, 0), color  = "red", size = 2) 
    }
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

plot_orig_data <- function(orig_dat, comparison_variable = "treatment") {
  
  colnames(orig_dat) [ which(colnames(orig_dat) == comparison_variable)] <- "compare_var"
  
 return(ggplot(orig_dat, aes(period, nind, color= compare_var)) +
    geom_line() +
    geom_point() +
    theme_bw() +
    scale_color_viridis_d(end = .8) +
    ggtitle(orig_dat$type[1]) +
      theme(legend.position = "top")
 )
}