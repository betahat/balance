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
                  tabPanel(
                  "Instructions", 
                  HTML("<p>The Life Equilibrium Visualizer is a Shiny web app that graphically displays the way you allocate your efforts across time. The code used to create this can be found on GitHub <a href = 'https://github.com/betahat/balance'>here</a>. The Life Equilibrium Visualizer mirrors Figure 2 in the paper \"Work and Life In Dynamic Equilibrium.\"</p>"),
                  p("To get started, download the provided template. Then, complete the spreadsheet(s) found in the \"Annual Visualizer\" and/or \"Lifetime Visualizer\" tabs. Finally, upload the completed templates to create your own Work Life Equilibrium figure. If you would like to preserve your figure(s), take a screenshot(s) because the app does not have the ability to save your data. For a detailed guide on using the Life Equilibrium Visualizer, see the accompanying tool: Exploring Dynamic Work-Life Equilibrium at Insert Hyperlink to Supplementary Material When Available.")),
                  tabPanel("Annual Visualizer", plotOutput("plot2")),
                  tabPanel("Lifetime Visualizer", plotOutput("plot1")))
                  )
              )
    )
