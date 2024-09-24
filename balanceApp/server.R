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
    
    annual_pos <- read_excel("annual_pos.xlsx")
    
    output$downloadData <- downloadHandler(
        filename = "template.xlsx",
        content = function(file) {
            file.copy("./template.xlsx", file)
        },
        contentType = "application/xlsx"
    )
    
    source("lifetime.R", local = TRUE)
    source("annual.R", local = TRUE)
}
