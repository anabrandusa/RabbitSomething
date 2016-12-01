# 10/29/2016. Author: Ana Brandusa Pavel

#if (interactive()) {
#    shinyApp(ui, server)
#}


library(shiny)
setwd(source.route)
source("ui.R")
setwd(source.route)
source("server.R")

app=shinyApp(ui=ui, server=server)
runApp(app, launch.browser = TRUE)