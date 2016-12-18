get.roc.result = function(auc.order.criterion, true.class.vector, score.vector, direction.is.zero) {
    if (auc.order.criterion == "AUC") {
        roc.result = roc(true.class.vector, score.vector)
    } else {
        if (direction.is.zero) {
            true.class.vector = 1 - true.class.vector
        }
        rocr.prediction = prediction(score.vector, true.class.vector)
        roc.result = roc.perf = performance(rocr.prediction, measure = "tpr", x.measure = "fpr")
    }
    roc.result
}