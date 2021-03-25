library(portalr)
library(dplyr)
library(LDATS)

c(2, 8, 22)

abunds <- portalr::abundance(level = "Site", type = "Granviores", plots = c(2, 8, 22), unknowns = FALSE, shape = "crosstab", time = "all", min_traps = 45, min_plots = 24, effort =T, zero_drop = F)

sg <- c('BA','PE','PF','PH','PI','PL','PM','PP','RF','RM','RO')


sg_abunds <- abunds[, sg] %>%
  mutate(totals = rowSums(.),
         period = abunds$period) %>%
  filter(totals > 0)

sg_periods <- sg_abunds$period

sg_abunds <- select(sg_abunds, -period, -totals)

sg_lda <- LDATS::LDA_set(sg_abunds, topics = c(2:10), nseeds = 100)

sg_select <- LDATS::select_LDA(sg_lda)

plot(sg_select$`k: 2, seed: 132`)


sg_abunds <- abunds[, sg] %>%
  mutate(totals = rowSums(.),
         period = abunds$period) %>%
  filter(totals > 0) %>%
  mutate(prop_pp = PP / totals) %>%
  mutate(prop_pp = prop_pp + .000000000001)

library(gratia)
library(mgcv)

prop_pp_gam <- gam(prop_pp ~ s(period, k = 100), family = "Gamma", data = sg_abunds)

sg_abunds <- add_fitted(sg_abunds, prop_pp_gam)

ggplot(sg_abunds, aes(period, .value)) +
  geom_line()

