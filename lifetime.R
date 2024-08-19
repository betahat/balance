# libraries
library(tidyverse)
library(magrittr)
library(readxl)
library(conflicted)
library(scales)
conflicts_prefer(dplyr::filter)
conflicts_prefer(dplyr::lag)

# load data
dat_raw <-
  read_excel("Distributed Effort Worksheets.xlsx",
             skip = 2,
             sheet = "Lifetime Scale")

dat_raw$Year <- as.numeric(dat_raw$Year)

dat_vals <- dat_raw %>% 
  select(Year:Total)

dat_cats <- read_excel("Distributed Effort Worksheets.xlsx", sheet = "Lifetime Scale")

dat_labels <-
  dat_raw %>% 
  select(`Career Stage`:Year) %>% 
  drop_na(`Career Stage`)

dat_labels %<>% rbind(c("End", max(dat_raw$Year))) %>% 
  mutate(Year = as.numeric(Year))

dat_labels$Year2 <- c(tail(dat_labels$Year,-1), NA)
dat_labels %<>% mutate(pos = (Year + Year2)/2)
dat_labels %<>% mutate(width = Year2 - Year)

# clean data
dat_cats2 <- data.frame(group = as_vector(dat_cats[1, ]), name = as_vector(dat_cats[2, ])) %>% remove_rownames()

dat_cats2 %<>% fill(group) %>% drop_na()

dat_long <- dat_vals %>% pivot_longer(cols = -Year) %>% filter(name != "Total")

dat <- dat_long %>% left_join(dat_cats2)

# color calculations
num_groups <- n_distinct(dat$group)
num_cats <- n_distinct(dat$name)
num_cats_per_group <-
  dat %>%
  distinct(group, name) %>%
  count(group)

# color palette
#main_cols <- viridis_pal()(num_groups + 1)[-I(num_groups + 1)]
main_cols <- brewer_pal(palette = "Set2")(num_groups)

show_col(main_cols)
my_pal <- c()
for (n in 1:num_groups) {
  new_cols <-
    colorRampPalette(
      colors = c("white", main_cols[n]))(as.numeric(num_cats_per_group[n, 2] + 2))[-1:-2]
  my_pal <- c(my_pal, new_cols)
}
rm(new_cols)

# plot data
dat %>%
  ggplot(aes(x = Year, y = value, fill = name)) +
  geom_area(position = 'stack') +
  scale_fill_manual(values = my_pal) +
  labs(y = "Percent", fill = "Category") +
  coord_cartesian(ylim = c(0, 100), clip = "off") +
  annotate(
    "text",
    x = dat_labels$pos,
    y = -50,
    label = str_wrap(dat_labels$`Career Stage`, width = 10)
  ) +
  theme(plot.margin = unit(c(1, 1, 8, 1), "lines")) +
  geom_vline(xintercept = dat_labels$Year)


# scratch
# dat %>%
#   ggplot(aes(x = Year, y = value, fill = name)) +
#   geom_area(position = 'stack') +
#   facet_grid( ~ group) +
#   scale_fill_manual(values = my_pal)
# 
# dat %>%
#   group_by(Year, group) %>%
#   summarize(perc = sum(value)) %>%
#   ggplot(aes(x = Year, y = perc, fill = group)) +
#   geom_area(position = 'stack') +
#   scale_fill_manual(values = main_cols)
