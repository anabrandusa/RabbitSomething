
auc.total.performance = c()
roc.results = c()
auc.headers = c()
for (selected.model.number in unique(auc.table[, "Model"])) {
    auc.total.performance = c(auc.total.performance, mean(subset(auc.table, Model == selected.model.number)[, "AUC"]))
    roc.score.data = subset(all.data.table, Model == selected.model.number)[, c("Score", "TrueClass")]
    locale.roc.score = roc(as.numeric(as.factor(roc.score.data[, "TrueClass"])), roc.score.data[, "Score"])$auc
    roc.results = c(roc.results, locale.roc.score)
    #locale.header = paste("AUC: ", toString(round(locale.roc.score, digits = 3)), "; ", as.character(specs[selected.model.number, 1]), "; ", as.character(specs[selected.model.number, 2]), "; ", as.character(specs[selected.model.number, 3]), "; ", as.character(specs[selected.model.number, 4]))
    locale.header = paste(as.character(specs[selected.model.number, 1]), "; ", as.character(specs[selected.model.number, 2]), "; ", as.character(specs[selected.model.number, 3]), "; ", as.character(specs[selected.model.number, 4]))
    auc.headers = c(auc.headers, locale.header)
}
auc.table.columns = c("Model", "AUC", "ROCAUC", "Headers")
auc.means = matrix(nrow = length(auc.total.performance), ncol = length(auc.table.columns))
colnames(auc.means) = auc.table.columns
auc.means[, "Model"] = unique(auc.table[, "Model"])
auc.means[, "AUC"] = auc.total.performance
auc.means[, "ROCAUC"] = roc.results
auc.means[, "Headers"] = auc.headers
auc.order = order(auc.means[, auc.order.criterion], decreasing = T)
auc.means = auc.means[auc.order,]
auc.headers = auc.means[, c("Model", "Headers")]
auc.means = as.data.frame(auc.means[, auc.table.columns !="Headers"] )
setwd(data.route)
write.csv(auc.means, "aucmeans.csv")
write.csv(auc.headers, "aucheaders.csv")
setwd(base.route)
        #auc.performance <- roc.result$auc
