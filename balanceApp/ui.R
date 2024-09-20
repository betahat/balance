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
                plotOutput("plot1"),
                h1("Instructions"),
                "instructions here"
                  
                  )
              )
    )
