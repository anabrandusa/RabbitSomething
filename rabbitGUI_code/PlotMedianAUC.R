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

interleave.elements = function(list1, list2) {
    c(list1, list2)[order(c(seq_along(list1), seq_along(list2)))]
}

plotMedianAUC = function(selected.step, input.auc.means, select.best.models = T, additional.auc.means=NULL) {
    auc.classification = getAUCClassification(selected.step, input.auc.means, select.best.models)
    auc.for.subsets = auc.classification$auc.for.subsets
    large.classes = sapply(auc.classification$large.classes, as.numeric)
    models.for.step = auc.classification$models.for.step
    #class.names = auc.classification$class.names
    if (!is.null(additional.auc.means)) {
        additional.auc.classification = getAUCClassification(selected.step, additional.auc.means, F)
        auc.for.subsets = interleave.elements(auc.for.subsets, additional.auc.classification$auc.for.subsets)
        additional.models.for.step = additional.auc.classification$models.for.step
        models.for.step = interleave.elements(models.for.step, additional.models.for.step)
    }
    boxplot.header = "Cross validation mean AUC"
    locale.box.col = rep("blue", times = length(auc.for.subsets))
    if (select.best.models | !is.null(additional.auc.means)) {
        if (is.null(additional.auc.means)) {
            locale.box.col[large.classes] = "red"
            auc.subtitle = paste("Anova p - value:", toString(round(auc.classification$anova.p.value, digits = 3)))
        } else {
            locale.box.col[1:length(locale.box.col)] = c("magenta", "yellow")
            auc.subtitle = "Real vs. random"
        }
        boxplot.header = paste(boxplot.header, auc.subtitle, sep = "\n")
        #class.names = auc.classification$class.names
    } else {
        locale.box.col = rep("yellow", times = length(auc.for.subsets))
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
    if (select.best.models | !is.null(additional.auc.means)) {
        if (is.null(additional.auc.means)) {
            legend.text = c("Best models", "Other models")
            legend.colors = c("red", "blue")
        } else {
            legend.text = c("Real", "Random")
            legend.colors = c("magenta", "yellow")
        }
        legend("bottomright", legend = legend.text, col = legend.colors, cex = 1, pch = 15)
    }
}