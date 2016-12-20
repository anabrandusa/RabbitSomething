plotROCCurve = function(locale.input, input.all.data.table, input.auc.headers, input.auc.means, model.source) {
    #selected.model.number = select.auc.model(locale.input, model.source, input.auc.headers, input.auc.means)
    selected.model.number = select.auc.model(locale.input, model.source)
     #message("Using number: ", selected.model.number)
    score.data = subset(input.all.data.table, Model == selected.model.number)[, c("Score", "TrueClass", "Direction")]
    true.class.vector = as.numeric(as.factor(score.data[, "TrueClass"]))
    score.vector = as.numeric(score.data[, "Score"])
    roc.result = get.roc.result(auc.order.criterion, true.class.vector, score.vector, all(score.data[, "Direction"]) == 0)
    #auc.performance <- roc.result$auc
    #auc.performance = mean(subset(auc.table, Model == selected.model.number)[, "AUC"])
    #auc.performance = subset(auc.means, Model == selected.model.number)[, "AUC"]
    auc.performance = subset(input.auc.means, Model == selected.model.number)[, auc.order.criterion]
    auc.performance.numeric = as.numeric(as.character(auc.performance))
    auc.label = paste("ROC AUC:", toString(round(as.numeric(auc.performance.numeric), digits = 2)))
    plot(roc.result, main = auc.label, cex.lab = cex.scale, cex.main = cex.scale, lwd = plot.line.width)
    #plot(roc.result, height = 500, width = 500, main = auc.label, cex.lab = cex.scale, cex.main = cex.scale)
}