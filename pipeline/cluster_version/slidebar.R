# 10/29/2016. Author: Ana Brandusa Pavel

library(shiny)

if (interactive()) {
    ui <- fluidPage(
    sliderInput("obs", "Number of observations:",
    min = 0, max = 1000, value = 500
    ),
    plotOutput("distPlot")
    )

    # Server logic
    server <- function(input, output) {
        output$distPlot <- renderPlot({
        hist(rnorm(input$obs))
    })
    }
    # Complete app with UI and server components
    shinyApp(ui, server)
shinyApp(ui, server)
}
