# 10/29/2016. Author: Ana Brandusa Pavel

#if (interactive()) {
#    shinyApp(ui, server)
#}
library(shiny)
base.route = getwd()
source("AppRoutes.R")
setwd(base.route)
# source("AppRoutes.R")
# source("createHistogramTable.R")
setwd(base.route)
source("loadTables.R")
setwd(base.route)
source("checkOrProcessTable.R")
setwd(base.route)
source("ui.R")
source("server.R")
setwd(base.route)
app=shinyApp(ui=ui, server=server)
runApp(app, launch.browser = TRUE)
setwd(base.route)