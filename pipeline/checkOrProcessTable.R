library(ROCR)
library(pROC)
if (file.exists(file.path(data.route, "aucheaders.csv")) && file.exists(file.path(data.route, "aucmeans.csv"))) {
    setwd(data.route)
    auc.means = read.csv("aucmeans.csv", header = T, stringsAsFactors = F)
    auc.means = auc.means[, 2:ncol(auc.means)]
    auc.headers = read.csv("aucheaders.csv", header = T, stringsAsFactors = F)
    auc.headers = auc.headers[, 2:ncol(auc.headers)]
} else {
    source("ProcessTable.R")
}
setwd(base.route)