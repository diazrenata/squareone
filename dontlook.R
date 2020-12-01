library(dplyr)
library(mgcv)
library(ggplot2)

rat_totals <- read.csv(here::here("lore", "1981_competition", "1981_data_statevars.csv"), stringsAsFactors = F)

rat_totals <- rat_totals %>%
  mutate(krat_treatment = ifelse(brown_trtmnt == "dipo_present", "control", "exclosure")) %>%
  mutate(okrat_treatment = ordered(krat_treatment))

sg <- filter(rat_totals, type == "small_granivore")


head(sg)

is.ordered(sg$okrat_treatment)

nind.gam <- gam(nind ~ okrat_treatment + s(period) + s(period, by = okrat_treatment), data = sg, family = poisson, method = "REML")

plot(nind.gam, pages= 1, scale = 0)

pdat <- as.data.frame(expand.grid(period = seq(min(sg$period), max(sg$period), length.out= 500), okrat_treatment = levels(sg$okrat_treatment)))

nind.predicted <- predict(nind.gam, newdata = pdat, type = "lpmatrix")
nind.link <- predict(nind.gam, newdata = pdat, type = "link", se.fit = T)

nind.predicted.vals <- nind.gam$family$linkinv(nind.predicted %*% coefficients(nind.gam))

pdat.pred <- pdat %>%
  mutate(predicted = nind.predicted.vals,
         link = nind.link$fit,
         se_link = nind.link$se.fit) %>%
  mutate(link_fit = nind.gam$family$linkinv(link),
         link_upper = nind.gam$family$linkinv(link + (2 * se_link)),
         link_lower = nind.gam$family$linkinv(link - (2 * se_link)))

ggplot(pdat.pred, aes(period, link_fit, color= okrat_treatment)) +
  geom_line() +
  geom_ribbon(aes(period, ymin = link_lower, ymax =link_upper, fill = okrat_treatment), alpha = .5) +
  theme_bw()



nind.diff.keeppar <- nind.predicted[1:500, ] - nind.predicted[501:1000, ]

nind.diff.vals <- nind.diff.keeppar %*% coef(nind.gam)

plot(nind.diff.vals)

nind.diff.se<- sqrt(rowSums((nind.diff.keeppar %*% vcov(nind.gam, unconditional = FALSE)) * nind.diff.keeppar))
crit <- qnorm(.05/2, lower.tail = FALSE)
upr <- nind.diff.vals + (crit * nind.diff.se)
lwr <- nind.diff.vals - (crit * nind.diff.se)

pdat.diff <- pdat %>%
  select(period) %>%
  distinct()%>%
  mutate(fitted_dif = nind.diff.vals,
         upper= upr,
         lower = lwr)

ggplot(pdat.diff, aes(period, fitted_dif)) +
  geom_line() +
  geom_ribbon(aes(period, ymin = lower, ymax = upper), alpha  = .5) +
  geom_hline(yintercept = 0)


