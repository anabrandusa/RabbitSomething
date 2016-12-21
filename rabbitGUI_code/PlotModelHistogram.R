plotModelHistogram = function(locale.input, input.all.data.table, input.auc.headers, input.auc.means, model.source)
{
    
    # selected.model.number = select.auc.model(locale.input, "selected.model.header", input.auc.headers, input.auc.means)
    selected.model.number = select.auc.model(locale.input, model.source)
    #message("Model selected: ", selected.model.number)
    # score.data = get.histogram.values(selected.model.number)
    model.values = subset(input.all.data.table, Model == selected.model.number)
    trueClassValues = rev(sort(unique(model.values[, "TrueClass"])))
    #plot(density(score.data, na.rm = TRUE), main = paste("Model combination ", selected.model.number))
    color.vector = c("magenta", "blue")
    header.from.matrix = input.auc.headers[input.auc.headers[, "Model"] == selected.model.number, "Headers"]
    max.score = max(sapply(trueClassValues, function(x) density(as.numeric(subset(model.values, TrueClass == x)[, "Score"]), na.rm = TRUE)$y))
    auc.description = names(header.descriptions.body)[selected.model.number]
    plot(density(as.numeric(subset(model.values, TrueClass == trueClassValues[1])[, "Score"]), na.rm = TRUE), main = auc.description, xlab = "Prediction score", ylab = "Distribution of test samples (density)", cex.lab = cex.scale, cex.main = cex.scale, col = color.vector[1], lwd = plot.line.width, ylim = c(0, max.score))
    for (trueClassType in trueClassValues[2:length(trueClassValues)]) {
        lines(density(as.numeric(subset(model.values, TrueClass == trueClassType)[, "Score"]), na.rm = TRUE), col = color.vector[2], lwd = plot.line.width)
    }
    legend("topright", legend = trueClassValues, col = color.vector, cex = 1, lty = 1, lwd = plot.line.width)
}