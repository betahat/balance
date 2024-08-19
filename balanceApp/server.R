library(shiny)
library(tidyverse)
library(magrittr)
library(readxl)
library(conflicted)
library(scales)
library(DT)
conflicts_prefer(DT::renderDataTable)
conflicts_prefer(dplyr::filter)
conflicts_prefer(dplyr::lag)


function(input, output, session) {

    source("functions.R", local = FALSE)
    
    output$downloadData <- downloadHandler(
        filename = "template.xlsx",
        content = function(file) {
            file.copy("./Distributed Effort Worksheets.xlsx", file)
        },
        contentType = "application/xlsx"
    )
    
    
    dat_raw <- reactive({
        inFile <- input$file1
        if (is.null(inFile)) return(NULL)
        data <- read_excel(inFile$datapath,
                           skip = 2,
                           sheet = "Lifetime Scale")
        data$Year <- as.numeric(data$Year)
        data
    })
    
    dat_vals <- reactive({
        req(dat_raw())
        dat_raw() %>% 
        select(Year:Total)
        })
    
    dat_cats <- reactive({
        inFile <- input$file1
        if (is.null(inFile)) return(NULL)
        data <- read_excel("Distributed Effort Worksheets.xlsx", sheet = "Lifetime Scale")
        data
    })
        
    dat_labels <- reactive({
        dat_raw() %>% 
            select(`Career Stage`:Year) %>% 
            drop_na(`Career Stage`) %>% 
            rbind(c("End", max(dat_raw()$Year))) %>% 
            mutate(Year = as.numeric(Year))
    })
    
    dat_labels2 <- reactive({
        dat_labels() %>% 
            mutate(Year2 = c(tail(dat_labels()$Year,-1), NA)) %>% 
            mutate(pos = (Year + Year2)/2) %>% 
            mutate(width = Year2 - Year)
    })
    
    # clean data
    dat_cats2 <- reactive({
        data.frame(
            group = as_vector(dat_cats()[1, ]), 
            name = as_vector(dat_cats()[2, ])) %>% 
            remove_rownames() %>% 
            fill(group) %>% drop_na()
        })
    
    dat_long <- reactive({
        dat_vals() %>% 
            pivot_longer(cols = -Year) %>% 
            filter(name != "Total")
    })
    
    dat <- reactive({
        dat_long() %>% 
            left_join(dat_cats2())
    })
    
    # color calculations
    num_groups <- reactive({n_distinct(dat()$group)})
    num_cats <- reactive({n_distinct(dat()$name)})
    num_cats_per_group <- reactive({
        dat() %>%
        distinct(group, name) %>%
        count(group)
    })
    
    # color palette
    #main_cols <- viridis_pal()(num_groups + 1)[-I(num_groups + 1)]
    main_cols <- reactive({brewer_pal(palette = "Set2")(num_groups())})
    
    my_pal <- reactive({make_palette(num_groups(), main_cols(), num_cats_per_group())})
    
    output$plot1 <- renderPlot({
            ggplot(data = dat(), aes(x = Year, y = value, fill = name)) +
            geom_area(position = 'stack') +
            scale_fill_manual(values = my_pal()) +
            labs(y = "Percent", fill = "Category") +
            coord_cartesian(ylim = c(0, 100), clip = "off") +
            annotate(
                "text",
                x = dat_labels2()$pos,
                y = -50,
                label = str_wrap(dat_labels2()$`Career Stage`, width = 10)
            ) +
            theme(plot.margin = unit(c(1, 1, 8, 1), "lines")) +
            geom_vline(xintercept = dat_labels2()$Year)
    })

}
