# 10/29/2016. Author: Ana Brandusa Pavel

base.route = getwd()
source.route = file.path(base.route)
model.route = file.path(base.route, "Pipeline_Output")
data.route = file.path(base.route, "data")
setwd(data.route)
if (!file.exists("alldata.csv")) {
    setwd(source.route)
    source("loadStockPipeline.R")
}
setwd(source.route)