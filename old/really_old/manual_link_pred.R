library(dplyr)
library(mgcv)

manual_link_pred <- function(MODEL, newdata, exVars, uncond = FALSE, alpha) {
  xp <- predict(MODEL, newdata = newdata, type = 'lpmatrix')
  
  xp0 <- xp
  
  xp0[ , exVars] <- 0
  
  mod_coef <- coef(MODEL)
  
  mod_coef0 <- mod_coef
  mod_coef0[  exVars] <- 0
  
  pred0 <- xp0 %*% mod_coef0
  
  #pred <- xp %*% mod_coef
  #se <- sqrt(rowSums((xp %*% vcov(MODEL, unconditional = F)) * xp))
  
  se0 <- sqrt(rowSums((xp0 %*% vcov(MODEL, unconditional = uncond)) * xp0))
  
  #pred_gam <- predict(MODEL, newdata=newdata, type = "link", se.fit = T)
  
  #all.equal(as.vector(pred_gam$fit), as.vector(pred))
  #all.equal(as.vector(pred_gam$se.fit), as.vector(se))
  
  crit <- qnorm(alpha/2, lower.tail = FALSE)
  upr <- pred0 + (crit * se0)
  lwr <- pred0 - (crit * se0)
  
  newdata %>%
    mutate(Fitted = pred0,
           Lower = lwr,
           Upper = upr)
}


predict_treat_effect_manual = function(dat, np, MODEL, exVars, treatEff = NULL) {
  # Data to predict at; note the dummy plot - need to provide all variables used to
  # fit the model when predicting
  
  if(is.null(treatEff)) {
  treatEff <- as.data.frame(
    expand.grid(censusdate = seq(min(dat$censusdate), max(dat$censusdate), length = np),
                oPlot = unique(dat$oPlot),
                oTreatment = unique(dat$oTreatment)))
  
  treatEff <- treatEff %>%
    filter(oPlot == 4) %>%
    left_join(distinct(select(dat, oPlot, oTreatment))) %>%
    mutate(numericdate =as.numeric(censusdate) / 1000)
  }
  # actually predict, on link scale so we can get proper CIs, exclude
  treatPred <- manual_link_pred(MODEL, treatEff, exVars, FALSE, .05)
 
  # extract inverse of link function from the model
  ilink <- family(MODEL)$linkinv
  # form 95% bayesian credible interval / frequentist across-function confidence interval
  treatPred <- transform(treatPred, Fitted = ilink(Fitted),
                         Upper = ilink(Upper),
                         Lower = ilink(Lower))
  return(treatPred)
}
