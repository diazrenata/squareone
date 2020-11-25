# Gavin's post on factor by smooths


library('readr')
library('dplyr')
library('ggplot2')
theme_set(theme_bw())
library('mgcv')



uri <- 'https://gist.githubusercontent.com/gavinsimpson/eb4ff24fa9924a588e6ee60dfae8746f/raw/geochimica-metals.csv'
metals <- read_csv(uri, skip = 1, col_types = c('ciccd'))
metals <- mutate(metals, SiteCode = factor(SiteCode))

head(metals)

is.ordered(metals$SiteCode) # SiteCode is NOT ordered



ggplot(metals, aes(x = Date, y = Hg, colour = SiteCode)) +
  geom_point() +
  geom_smooth(method = 'loess', se = FALSE) +
  scale_colour_brewer(type = 'qual', palette = 'Dark2') +
  theme(legend.position = 'top')



m <- gam(Hg ~ SiteCode + s(Date, by = SiteCode), data = metals) # Fit with the parametric term and the smooth(by). The parametric term allows there to be a different mean per level of the factor. Otherwise the smooths are "centered around zero effect".
summary(m)

plot(m, shade = TRUE, pages = 1, scale = 0)

m_nopar <- gam(Hg ~ s(Date, by = SiteCode), data = metals)



plot(m_nopar, shade = TRUE, pages = 1, scale = 0) # At least in these plots, the difference is most pronounced for NODH. Not sure what the situation all means though.

# K now we get the Xp matrix at a grid of points for Date x Site.

pdat <- expand.grid(Date = seq(1860, 2000, length = 400),
                    SiteCode = c('FION', 'CHNA', 'NODH'))

#' Gavin's description of the Xp matrix (at least here): 
#' "a matrix where the basis functions of the model have been evaluated at the values of the covariates supplied to newdata."
#' "to turn this matrix into one containing fitted or predicted values (ARE THOSE DIFFERENT?), it needs to be multiplied by the model coefficients and the rows summed."
#' "HOWEVER, in this Xp state we can compute differences between the evaluated smooths before computing fitted values". 
#' "this process needs to be repeated for each pair of smooths we want to compare." Will then walk through those steps. 
#'
#'
#' Question at this point: Erica fit a model with additional terms (for plot and smooth(date, by=plot) but then appears to have excluded those terms from the smooths she was comparing? I can sort of interpolate a rationale for doing this in that adding the plot level terms soaks up some of that variation, leaving only treatment signal in the treatment smooths? But am not sure if that's really the reason, or, if it is, if you can rely on that? 
#' 
#' Also ordered vs. not ordered factors. This example is NOT ordered. Gavin's second post in this series (https://fromthebottomoftheheap.net/2017/12/14/difference-splines-ii/) uses ordered factors which I think is maybe more appropriate to Portal (we want difference from control). 
#' 
#' 
#' She also included a separate smooth for date alone. This might have been because it's an ordered factor?
#' 
#' Is Xp on the link scale? Probably? At what point does one invlink it? Differences of smooths appear to get reported on the link scale.
#'  
xp <- predict(m, newdata = pdat, type = 'lpmatrix')

colnames(xp)

# One pairwise comparison
# We can extract from Xp the rows and columns related to the levels of the factors we are interested in comparing.
# Using "CHNA" and "FION"

# Columns for these levels
chna_cols <- grepl("CHNA", colnames(xp))
fion_cols <- grepl("FION", colnames(xp))

# Rows for these levels
chna_rows <- pdat$SiteCode == "CHNA"
fion_rows <- pdat$SiteCode == "FION"

# Subtract the rows for FION from the rows for CHNA

X <- xp[chna_rows, ] - xp[fion_rows, ]

# Then zero out the columns from the xp matrix that were for the other levels

X[, !(chna_cols | fion_cols)] <- 0

# And zero out ones that aren't smooths (i.e. the parametric cols)
X[ ,!grepl("^s\\(", colnames(xp))] <- 0

# Use matrix multiplication of the X matrix (the modified Xp matrix) with the model coefficients from m to MULTIPLY Xp by the coefficients and SUM row wise in one step

dif <- X %*% coef(m)

plot(dif)

# standard errors

se <- sqrt(rowSums((X %*% vcov(m)) * X))


crit <- qt(.975, df.residual(m)) # not sure that this is the correct way to get a CI in the case of a Poisson
upr <- dif + (crit * se)
lwr <- dif - (crit * se)

### K how about ordered factors -https://fromthebottomoftheheap.net/2017/12/14/difference-splines-ii/


#' If mgcv gets an ORDERED factor, it fits one REFERENCE smooth and then additional DIFFERENCE smooths the get the difference between the additional levels and the reference level. 
#' ALSO. The by variable doesn't include a smoother for a reference level, so you have to add that one manually. THIS IS YOUR PROBLEM WITH PORTAL.
#' 
#' 
