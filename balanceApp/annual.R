annual <- reactive({
  inFile <- input$file1
  if (is.null(inFile))
    return(NULL)
  data <-
    read_excel(inFile$datapath, skip = 1, sheet = "Annual Example")
  #data$Year <- as.numeric(data$Year)
  data
})

a_dat_vals <- reactive({
  req(annual())
  annual() %>%
    select(Season:Total)
})

a_dat_cats <- reactive({
  inFile <- input$file1
  if (is.null(inFile))
    return(NULL)
  data <-
    read_excel(
      inFile$datapath, 
      sheet = "Annual Example", 
      col_names = FALSE) %>%
    select(-...1, -...2)
  data
})



# clean data
a_dat_cats2 <- reactive({
  data.frame(group = as_vector(a_dat_cats()[1, ]),
             name = as_vector(a_dat_cats()[2, ])) %>%
    remove_rownames() %>%
    fill(group) %>% drop_na()
})

a_dat_long <- reactive({
  a_dat_vals() %>%
    select(-Season) %>% 
    pivot_longer(cols = -Week) %>%
    filter(name != "Total")
})

a_dat <- reactive({
  a_dat_long() %>%
    left_join(a_dat_cats2())
})

# color calculations
a_num_groups <- reactive({
  n_distinct(a_dat()$group)
})
a_num_cats <- reactive({
  n_distinct(a_dat()$name)
})
a_num_cats_per_group <- reactive({
  a_dat() %>%
    distinct(group, name) %>%
    count(group)
})

# color palette
#main_cols <- viridis_pal()(num_groups + 1)[-I(num_groups + 1)]
a_main_cols <- reactive({
  brewer_pal(palette = "Set2")(a_num_groups())
})

a_my_pal <- reactive({
  make_palette(a_num_groups(), a_main_cols(), a_num_cats_per_group())
})

output$plot2 <- renderPlot({
  
  ggplot(data = a_dat(), aes(
    x = Week,
    y = value,
    fill = name
  )) +
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

})