# libraries
library(tidyverse)
library(magrittr)
library(readxl)
library(conflicted)
library(scales)
conflicts_prefer(dplyr::filter)
conflicts_prefer(dplyr::lag)

annual <-
  read_excel("template.xlsx",
             skip = 1,
             sheet = "Annual Example")

a_dat_vals <- 
  annual %>%
    select(Season:Total)


a_dat_cats <- 
  read_excel("template.xlsx",
      sheet = "Annual Example", 
      col_names = FALSE) %>%
    select(-...1, -...2)


# dat_labels <- 
#   annual %>%
#     select(Season:Week) %>% 
#   filter(Week %in% )
    #drop_na(`Career Stage`) %>% 
    #group_by(Season) %>% 
    #slice_head() %>% 
    #arrange(Week) %>% 
    #ungroup()# %>% 
    #add_row(Season = "Winter", Week = "End") #%>% 
  #mutate(Year = as.numeric(Year))


a_dat_cats2 <-
  data.frame(group = as_vector(a_dat_cats[1, ]),
             name = as_vector(a_dat_cats[2, ])) %>%
    remove_rownames() %>%
    fill(group) %>% drop_na()

a_dat_long <- 
  a_dat_vals %>%
  select(-Season) %>% 
    pivot_longer(cols = -Week) %>%
    filter(name != "Total")

a_dat <- 
  dat_long %>%
    left_join(a_dat_cats2)

annual_pos <- read_excel("balanceApp/annual_pos.xlsx")

ggplot(data = a_dat, aes(x = Week, y = value, fill = name)) +
  geom_area(position = 'stack') +
  #scale_fill_manual(values = my_pal()) +
  labs(y = "Percent", fill = "Category") +
  coord_cartesian(ylim = c(0, 100), clip = "off") +
  annotate(
    "text",
    x = annual_pos$pos,
    y = -50,
    label = str_wrap(annual_pos$Season, width = 10)
  ) +
  theme(plot.margin = unit(c(1, 1, 8, 1), "lines")) +
  geom_vline(xintercept = annual_pos$line)
