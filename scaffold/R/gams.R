make_pdat <- function(dat, np) {
  
  pdat <- expand.grid(censusdate = seq(min(dat$censusdate), max(dat$censusdate), length.out = np),
                      treatment = unique(dat$treatment),
                      plot = 2) %>%
    mutate(plot = ordered(plot),
           treatment = ordered(treatment),
           numericdate = as.numeric(censusdate) / 1000,
           censusyear = format.Date(censusdate, "%Y")) %>% 
    dplyr::mutate(era = NA) %>%
    dplyr::mutate(era = ifelse(censusyear <= 1995, "a_pre_ba",
                               ifelse(censusyear <= 2009, "b_pre_cpt",
                                      ifelse(censusyear <= 2014, "c_pre_switch", "d_post-switch")))) 
  
  return(pdat)
  
}

get_treatment_prediction <- function(dat, pdat, MODEL) {

  plotnames <- unique(dat$plot) %>%
    as.character()
  
  exVars <- c('oPlot', paste0('s(numericdate):oPlot', plotnames))
  
  #### FROM CHRISTENSEN #### 
    
  # actually predict, on link scale so we can get proper CIs, exclude
  treatPred <- as.data.frame(predict(MODEL, pdat, type = 'link', se.fit = TRUE,
                                     exclude = exVars))
  # bind predictions to data we predicted at
  treatPred <- cbind(pdat, treatPred)
  # extract inverse of link function from the model
  ilink <- family(MODEL)$linkinv
  # form 95% bayesian credible interval / frequentist across-function confidence interval
  treatPred <- transform(treatPred, Fitted = ilink(fit),
                         Upper = ilink(fit + (2 * se.fit)),
                         Lower = ilink(fit - (2 * se.fit)))
  return(treatPred)
}

#' @title compute differences of smooths
#' @description Compute pairwise differences of smooths when fitted using ordered factors
#' 
#' @param model gam model object
#' @param newdata predicted data (e.g. output from predict_treat_effect)
#' @param smooth_var variable name from 'newdata' to perform smooth upon
#' @param f1 first treatment type for computing difference ('CC','EC', or 'XC')
#' @param f2 second treatment type for computing difference ('CC','EC', or 'XC')
#' @param var variable name from 'newdata' corresponding to ordered treatment
#' @param alpha
#' @param unconditional
#' @param removePara T/F: remove parametric columns not associated with var?
#' @param keepVar
#' 
get_treatment_diff <- function(model, newdata, smooth_var, f1, f2, var, alpha = 0.05,
                               unconditional = FALSE, removePara = TRUE, keepVar = TRUE, ...) {
  
  ### FROM CHRISTENSEN
  xp <- predict(model, newdata = newdata, type = 'lpmatrix', ...)
  # reference level
  ref_level <- levels(newdata[[var]])[1L]
  ref_smooth <- grepl(paste0("s\\(", smooth_var, "\\)\\.{1}[[:digit:]]+$"), colnames(xp))
  not_smooth <- !grepl('^s\\(', colnames(xp))
  c1 <- ref_smooth | grepl(f1, colnames(xp))
  c2 <- ref_smooth | grepl(f2, colnames(xp))
  r1 <- newdata[[var]] == f1
  r2 <- newdata[[var]] == f2
  # difference rows of xp for data from comparison
  X <- xp[r1, ] - xp[r2, ]
  # zero out cols of X related to splines for other levels
  X[, !not_smooth][, ! (c1[!not_smooth] | c2[!not_smooth])] <- 0
  if (isTRUE(removePara)) {
    # zero out the parametric cols not associated with `var`,
    # ignore (Intercept), as it is zero anyway
    ind <- grepl('^s\\(', colnames(xp))
    if (isTRUE(keepVar)) {
      ind <- ind | grepl(paste0('^', var), colnames(xp))
    }
    X[, !ind] <- 0
  }
  dif <- X %*% coef(model)
  se <- sqrt(rowSums((X %*% vcov(model, unconditional = unconditional)) * X))
  crit <- qnorm(alpha/2, lower.tail = FALSE)
  upr <- dif + (crit * se)
  lwr <- dif - (crit * se)
  data.frame(pair = paste(f1, f2, sep = '-'),
             diff = dif,
             se = se,
             upper = upr,
             lower = lwr,
             censusdate = newdata[r1,'censusdate'])  %>%
    mutate(diff_overlaps_zero = (upper * lower) < 0)
}

