model = dipo.gam
newdata = treatPred.dipo
var = "oTreatment"
removePara = F
smooth_var = "numericdate"
f1 = "CC"
f2 = "XC"

xp <- predict(model, newdata = newdata, type = 'lpmatrix')

ref_level <- levels(newdata[[var]])[1L]

ref_smooth <- grepl(paste0("s\\(", smooth_var, "\\)\\.{1}[[:digit:]]+$"), colnames(xp)) # find the columns from xp that involve the ref_smooth
not_smooth <- !grepl('^s\\(', colnames(xp)) # and the converse
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
se <- sqrt(rowSums((X %*% vcov(model, unconditional = F)) * X))
crit <- qnorm(alpha/2, lower.tail = FALSE)
upr <- dif + (crit * se)
lwr <- dif - (crit * se)
data.frame(pair = paste(f1, f2, sep = '-'),
           diff = dif,
           se = se,
           upper = upr,
           lower = lwr,
           censusdate = newdata[r1,'censusdate']) 
