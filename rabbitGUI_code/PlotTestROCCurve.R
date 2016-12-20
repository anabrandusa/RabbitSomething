plotTestROCCurve = function(classification.scores.file, input.model.name) {
    predictions.table = read.table(classification.scores.file, header = T)
    true.class.vector = as.numeric(as.factor(predictions.table[, "Response"]))
    score.vector = predictions.table[, "Score"]
    direction.is.zero = any(all.data.table[all.data.table[, "ModNames"] == input.model.name, "Direction"] == 0)
    #message("Direction is ", direction.is.zero)
    roc.result = get.roc.result(auc.order.criterion, true.class.vector, score.vector, direction.is.zero)
    auc.performance = performance(prediction(score.vector, true.class.vector), "auc")@y.values[[1]]
    auc.label = paste("ROC AUC:", toString(round(as.numeric(auc.performance), digits = 2)))
    plot(roc.result, main = auc.label, cex.lab = cex.scale, cex.main = cex.scale, lwd = plot.line.width)
}