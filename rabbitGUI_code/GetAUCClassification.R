getAUCClassification = function(selected.step, input.auc.means, select.best.models=T, save.tukey.table=T) {
    models.for.step = selected.models(selected.step)
    auc.for.subsets = list()
    auc.for.subsets.index = 1
    for (model.subset in models.for.step) {
        auc.for.subsets.for.model = c()
        model.indexes = as.numeric(gsub("model_", "", model.subset))
        for (model.name in model.indexes) {
            model.subset = subset(input.auc.means, Model == model.name)
            model.auc.values = model.subset[, auc.order.criterion]
            names(model.auc.values) = model.subset[, "Model"]
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
    returned.list = list(auc.for.subsets = auc.for.subsets, class.names = class.names, models.for.step = models.for.step)
    if (select.best.models) {

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
        if (save.tukey.table) {
            assign("filtered.tukey.table", filtered.tukey.table, envir = .GlobalEnv)
        }
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
        returned.list = append(returned.list, list(large.classes = large.classes, anova.p.value = anova.p.value))
    }
    returned.list
}