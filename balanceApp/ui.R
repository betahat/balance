library(shiny)
library(DT)

fluidPage(
    titlePanel("Dynamic Life Equilibrium Visualizer"),
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
                tabsetPanel(
                  tabPanel("Instructions", "Instructions here"),
                  tabPanel("Annual Visualizer", plotOutput("plot2")),
                  tabPanel("Lifetime Visualizer", plotOutput("plot1")))
                  )
              )
    )
