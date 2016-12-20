getTukeyBadModelNames = function(tukey.vector, tukey.name) {
    #tukey.diff = significative.tukey.table[tukey.index, "diff"]
tukey.diff = tukey.vector["diff"]
    #tukey.elements = strsplit(rownames(significative.tukey.table)[tukey.index], "-")
    tukey.elements = strsplit(tukey.name, "-")

    if (tukey.diff <= 0) {
return(tukey.elements[[1]][1])
        #tukey.empty.values = c(tukey.empty.values, tukey.elements[[1]][1])
    } else {
return(tukey.elements[[1]][2])
        #tukey.empty.values = c(tukey.empty.values, tukey.elements[[1]][2])
    }
}

plotMedianAUC = function(selected.step, input.auc.means, select.best.models=T) {
    auc.classification = getAUCClassification(selected.step, input.auc.means, select.best.models)
    auc.for.subsets = auc.classification$auc.for.subsets
    large.classes = auc.classification$large.classes
    models.for.step = auc.classification$models.for.step
    class.names = auc.classification$class.names
    locale.box.col = rep("blue", times = length(class.names))
    boxplot.header = "Cross validation mean AUC"
    if (select.best.models) {
        locale.box.col[sapply(large.classes, as.numeric)] = "red"
        boxplot.header = paste(boxplot.header, "\nAnova p - value:", toString(round(auc.classification$anova.p.value, digits = 5)))
        class.names = auc.classification$class.names
    } else {
        locale.box.col = rep("yellow", times = length(class.names))
    }
    boxplotContainer = boxplot(auc.for.subsets, ylim = c(min(as.numeric(unlist(auc.for.subsets)), na.rm = TRUE), max(as.numeric(unlist(auc.for.subsets)), na.rm = TRUE)), names = names(models.for.step), col = locale.box.col[1:length(models.for.step)], ylab = "mean AUC", main = boxplot.header)
    mean.values = sapply(auc.for.subsets, function(x) {
        mean(x, na.rm = T)
    })
    sd.values = sapply(auc.for.subsets, function(x) {
        sd(x, na.rm = T)
    })
    aucSubsetInfo = boxplotContainer$stats
    aucSubsetInfo = rbind(mean.values, sd.values, aucSubsetInfo)
    rownames(aucSubsetInfo) = c("Mean", "SD", "Min.", "1st Qu.", "Median", "3rd Qu.", "Max.")
    colnames(aucSubsetInfo) = names(models.for.step)

    assign("aucSubsetInfo", aucSubsetInfo, envir = .GlobalEnv)

    boxplotContainer
    if (select.best.models) {
        legend("bottomright", legend = c("Best models", "Other models"), col = c("red", "blue"), cex = 1, pch = 15)
    }
}