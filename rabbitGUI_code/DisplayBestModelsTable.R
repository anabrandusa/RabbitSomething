displayBestModelsTable = function() {
    best.models.selected = NULL
    for (selected.step in step.names) {

        auc.classification.object = getAUCClassification(selected.step, auc.means, select.best.models = T, save.tukey.table = F)
        large.classes = as.numeric(auc.classification.object$large.classes)
        auc.for.subsets = auc.classification.object$auc.for.subsets
        if (length(large.classes) == 0) {
            large.classes = 1:length(auc.for.subsets)
        }
        if (selected.step == "biomarker size") {
            large.classes = large.classes[1]
        }
        locale.best.models = as.numeric(names(unlist(auc.for.subsets[large.classes])))
        if (is.null(best.models.selected)) {
            best.models.selected = locale.best.models
        } else {
            best.models.selected = intersect(best.models.selected, locale.best.models)
        }


    }
    best.models.selected = sort(best.models.selected)
    headers.by.model = auc.headers[auc.headers[, "Model"] %in% best.models.selected, c("Model", "Headers")]
    headers.by.model = headers.by.model[order(headers.by.model[,"Model"]), "Headers"]
    best.model.headers = strsplit(headers.by.model, ";")
    best.model.headers.matrix = matrix(nrow = length(best.models.selected), ncol = length(best.model.headers[[1]]))
    for (best.model.header.index in 1:length(best.model.headers)) {
        best.model.headers.matrix[best.model.header.index,] = best.model.headers[[best.model.header.index]]
    }
    auc.by.model = auc.means[auc.means[, "Model"] %in% best.models.selected, c("Model", auc.order.criterion)]
    auc.by.model = auc.by.model[order(auc.by.model[, "Model"]), auc.order.criterion]
    best.model.headers.matrix = cbind(sprintf("%3i", best.models.selected), best.model.headers.matrix, round(auc.by.model, digits = displayed.digits))
    colnames(best.model.headers.matrix) = c("Model", step.labels, "Mean AUC")
    best.model.headers.matrix
}