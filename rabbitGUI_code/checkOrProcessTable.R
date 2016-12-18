library(ROCR)
#input.auc.table = auc.table
input.all.data.table = all.data.table
input.data.route = data.route
setwd(base.route)
source("loadAndGenerateTables.R")
setwd(input.data.route)
auc.means = read.csv("aucmeans.csv", header = T, stringsAsFactors = F)
auc.means = auc.means[order(auc.means[, auc.order.criterion], decreasing = T), 2:ncol(auc.means)]
auc.headers = read.csv("aucheaders.csv", header = T, stringsAsFactors = F)
auc.headers = auc.headers[, 2:ncol(auc.headers)]
input.all.data.table = all.data.random.table
input.data.route = data.random.route
setwd(base.route)
source("loadAndGenerateTables.R")
setwd(input.data.route)
random.auc.means = read.csv("aucmeans.csv", header = T, stringsAsFactors = F)
random.auc.means = random.auc.means[, 2:ncol(random.auc.means)]
random.auc.headers = read.csv("aucheaders.csv", header = T, stringsAsFactors = F)
random.auc.headers = random.auc.headers[, 2:ncol(random.auc.headers)]