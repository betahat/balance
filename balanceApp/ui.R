library(shiny)
library(DT)


fluidPage(
    titlePanel("Life Balance Visualizer"),
          sidebarLayout(
              sidebarPanel(
                  width = 2, 
                  downloadButton("downloadData", "Download Template"),
                  br(),
                  br(),
                  fileInput(
                      'file1',
                      'Upload Data:',
                      accept = 
                          c(".xlsx")
                      )
                  ), 
              mainPanel(
                  plotOutput("plot1")
                  )
              )
    )
