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

plotMedianAUC = function(selected.step, input.all.data.table, input.auc.means, select.best.models=T) {
    models.for.step = selected.models(selected.step)
    auc.for.subsets = list()
    auc.for.subsets.index = 1
    for (model.subset in models.for.step) {
        auc.for.subsets.for.model = c()
        model.indexes = as.numeric(gsub("model_", "", model.subset))
        for (model.name in model.indexes) {
            model.subset = subset(input.auc.means, Model == model.name)
            model.auc.values = model.subset[, auc.order.criterion]
            auc.for.subsets.for.model = c(auc.for.subsets.for.model, model.auc.values)
            #selected.subtable = subset(all.data.table, ModNames == model.name)
            #auc.for.subsets.for.model = c(auc.for.subsets.for.model, get.mean.auc.values(model.name, selected.subtable))
        }
        auc.for.subsets.for.model.filtered = auc.for.subsets.for.model[!is.null(auc.for.subsets.for.model)]
        auc.for.subsets[auc.for.subsets.index] = list(auc.for.subsets.for.model.filtered)
        auc.for.subsets.index = auc.for.subsets.index + 1
    }

    names(models.for.step)[which(grepl("size", names(models.for.step)) == TRUE)] <- substr(names(models.for.step)[which(grepl("size", names(models.for.step)) == TRUE)], 17, nchar(names(models.for.step)[which(grepl("size", names(models.for.step)) == TRUE)]) - 1)
    auc.for.subsets.as.matrix = matrix(ncol = 2, nrow = 0)
    colnames(auc.for.subsets.as.matrix) = c("AUC", "Class")
    for (auc.element in 1:length(auc.for.subsets)) {
        auc.values = auc.for.subsets[[auc.element]]
        auc.values = auc.values[!is.na(auc.values)]
        auc.label = rep(auc.element, times = length(auc.values))
        auc.for.subsets.as.matrix = rbind(auc.for.subsets.as.matrix, cbind(auc.values, auc.label))
    }
    auc.data.frame = as.data.frame(auc.for.subsets.as.matrix)
    auc.data.frame[, "Class"] = as.factor(auc.data.frame[, "Class"])
    class.names = unique(auc.data.frame[, "Class"])
    if (select.best.models){
    anova.results = aov(AUC ~ Class, data = auc.data.frame)
    anova.p.value = summary(anova.results)[[1]][["Pr(>F)"]][1]
    tukey.table = TukeyHSD(anova.results, "Class")$Class
    filtered.tukey.table = tukey.table
    updated.tukey.row.names = sapply(rownames(tukey.table),
        function(x) {
            new.difference.label = gsub("\\-", " -- ", x)
            for (class.name in class.names) {
                label.class.name = paste("(", names(models.for.step)[as.numeric(class.name)], ")", sep = "")
                new.difference.label = gsub(paste("^", toString(class.name), sep = ""), label.class.name, new.difference.label)
                new.difference.label = gsub(paste(toString(class.name), "$", sep = ""), label.class.name, new.difference.label)
            }
            new.difference.label
        })
    rownames(filtered.tukey.table) = updated.tukey.row.names
    assign("filtered.tukey.table", filtered.tukey.table, envir = .GlobalEnv)
    significative.tukey.entries = tukey.table[, "p adj"] < 0.05
    significative.tukey.table = tukey.table[significative.tukey.entries,]
    tukey.empty.values = c()
    if (length(which(significative.tukey.entries)) == 1) {
        names(significative.tukey.table) = colnames(tukey.table)
        tukey.name = rownames(tukey.table)[significative.tukey.entries]
        tukey.empty.values = getTukeyBadModelNames(significative.tukey.table, tukey.name)
    } else {
            if (nrow(significative.tukey.table) > 0) {
                for (tukey.index in 1:nrow(significative.tukey.table)) {
                    tukey.empty.values = c(tukey.empty.values, getTukeyBadModelNames(significative.tukey.table[tukey.index,], rownames(significative.tukey.table)[tukey.index]))
                }
            }
        }
    large.classes = setdiff(class.names, tukey.empty.values)
    }
    locale.box.col = rep("blue", times = length(class.names))
    boxplot.header = "Cross validation mean AUC"
    if (select.best.models) {
        locale.box.col[sapply(large.classes, as.numeric)] = "red"
        boxplot.header = paste(boxplot.header, "\nAnova p - value:", toString(round(anova.p.value, digits = 5)))
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
        legend("bottomright", legend = c("Best models", "Models to exclude"), col = c("red", "blue"), cex = 1, pch = 15)
    }
}