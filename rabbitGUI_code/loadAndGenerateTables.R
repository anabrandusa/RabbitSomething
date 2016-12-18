#if (file.exists(file.path(input.data.route, "aucheaders.csv")) && file.exists(file.path(input.data.route, "aucmeans.csv"))) {
    #setwd(input.data.route)
    #auc.means = read.csv("aucmeans.csv", header = T, stringsAsFactors = F)
    #auc.means = auc.means[, 2:ncol(auc.means)]
    #auc.headers = read.csv("aucheaders.csv", header = T, stringsAsFactors = F)
    #auc.headers = auc.headers[, 2:ncol(auc.headers)]
#} else {
    #source("ProcessTable.R")
#}

if (!(file.exists(file.path(input.data.route, "aucheaders.csv")) && file.exists(file.path(input.data.route, "aucmeans.csv")))) {
    #input.auc.table = read.csv(file.path(input.data.route, "aucdata.csv"))
    setwd(base.route)
    source("CreateHeaderTable.R")
}