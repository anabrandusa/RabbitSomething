# 10/29/2016. Author:Ana Brandusa Pavel
#setwd(data.route)
#all.data.table = read.csv("alldata.csv", header = T, stringsAsFactors = F)
#auc.table = read.csv("aucdata.csv", header = T, stringsAsFactors = F)
setwd(source.route)
source("aucModelSelection.R")
cex.scale = 1.5
plot.line.width=2
selected.model.header = selected.model.number = selected.model.auc.header = F
server = function(input, output, session) {
    output$medianAuc <- renderPlot({
        selected.step = step.names[input$step]
        models.for.step = selected.models(selected.step)
        auc.for.subsets = list()
        auc.for.subsets.index = 1
        for (model.subset in models.for.step) {
            auc.for.subsets.for.model = c()
            for (model.name in model.subset) {
                model.subset = subset(auc.table, ModNames == model.name)
                model.auc.values = model.subset[, "AUC"]
                auc.for.subsets.for.model = c(auc.for.subsets.for.model, mean(model.auc.values))
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
         anova.results = aov(AUC ~ Class, data = auc.data.frame)
         anova.p.value = summary(anova.results)[[1]][["Pr(>F)"]][1]
         tukey.table = TukeyHSD(anova.results, "Class")$Class
         filtered.tukey.table = tukey.table
        updated.tukey.row.names=sapply(rownames(tukey.table),
        function(x){
            new.difference.label=gsub("\\-", " --- ", x)
            for (class.name in class.names) {
                label.class.name = paste("(", names(models.for.step)[as.numeric(class.name)], ")", sep = "")
                new.difference.label = gsub(paste("^", toString(class.name), sep = ""), label.class.name, new.difference.label)
                new.difference.label = gsub(paste(toString(class.name), "$", sep = ""), label.class.name, new.difference.label)
            }
            new.difference.label
        })
        rownames(filtered.tukey.table) = updated.tukey.row.names
        assign("filtered.tukey.table", filtered.tukey.table, envir = .GlobalEnv)
         significative.tukey.entries=tukey.table[, "p adj"]<0.05
         significative.tukey.table = tukey.table[significative.tukey.entries,]
         tukey.empty.values=c()
         if(nrow(significative.tukey.table)>0){
             for (tukey.index in 1:nrow(significative.tukey.table)) {
                 tukey.diff = significative.tukey.table[tukey.index,"diff"]
                 tukey.elements = strsplit(rownames(significative.tukey.table)[tukey.index], "-")
                 if (tukey.diff <= 0) {
                    tukey.empty.values = c(tukey.empty.values, tukey.elements[[1]][1])
                 } else {
                    tukey.empty.values = c(tukey.empty.values, tukey.elements[[1]][2])
                 }
             }
        }
         large.classes = setdiff(class.names, tukey.empty.values)
         locale.box.col = rep("blue", times = length(class.names))
        locale.box.col[sapply(large.classes, as.numeric)]="red"
        boxplotContainer = boxplot(auc.for.subsets, ylim = c(min(as.numeric(unlist(auc.for.subsets)), na.rm = TRUE), max(as.numeric(unlist(auc.for.subsets)), na.rm = TRUE)), names = names(models.for.step), col = locale.box.col[1:length(models.for.step)], ylab = "mean AUC", main = paste("Cross validation mean AUC.\nAnova p-value:", toString(round(anova.p.value, digits=5))))
        mean.values = sapply(auc.for.subsets, function(x) { mean(x, na.rm = T) })
        sd.values = sapply(auc.for.subsets, function(x) { sd(x, na.rm = T) })
        aucSubsetInfo = boxplotContainer$stats
        aucSubsetInfo = rbind(mean.values, sd.values, aucSubsetInfo)
        rownames(aucSubsetInfo) = c("Mean", "SD", "Min.", "1st Qu.", "Median", "3rd Qu.", "Max.")
        colnames(aucSubsetInfo) = names(models.for.step)
        
        assign("aucSubsetInfo", aucSubsetInfo, envir = .GlobalEnv)
       
        boxplotContainer
        legend("topright", legend = c("Best models", "Models to exclude"), col = c("red","blue"), cex = 1, pch=15)

        
    })
    output$boxplotParameters <- DT::renderDataTable({
        input$step
        DT::datatable(round(aucSubsetInfo, digits = 3))
    })
    output$tukeyValues <- DT::renderDataTable({
        input$step
        locale.tukey.table = filtered.tukey.table
        locale.tukey.table = locale.tukey.table[,c("diff", "p adj")]
        colnames(locale.tukey.table) = c("difference in means", "p-value")
        DT::datatable(round(locale.tukey.table, digits = 3))
    })
    output$distPlot <- renderPlot({
        hist(rnorm(input$obs))
    })
    output$plotModelHistogram <- renderPlot({
        locale.input=input
        selected.model.number = select.auc.model(locale.input, "selected.model.header")
        # score.data = get.histogram.values(selected.model.number)
        model.values = subset(all.data.table, Model==selected.model.number)
        trueClassValues = unique(model.values[, "TrueClass"])
        #plot(density(score.data, na.rm = TRUE), main = paste("Model combination ", selected.model.number))
        color.vector = c("magenta", "blue")
        header.from.matrix = auc.headers[auc.headers[, "Model"] == selected.model.number, "Headers"]
        plot(density(subset(model.values, TrueClass == trueClassValues[1])[, "Score"], na.rm = TRUE), main = header.from.matrix, xlab = "Prediction score", ylab = "Distribution of test samples (density)", cex.lab = cex.scale, cex.main = cex.scale, col = color.vector[1], lwd = plot.line.width)
        for (trueClassType in trueClassValues[2:length(trueClassValues)]) {
            lines(density(subset(model.values, TrueClass == trueClassType)[, "Score"], na.rm = TRUE), col = color.vector[2], lwd = plot.line.width)
        }
        legend("topright", legend = trueClassValues, col = color.vector, cex = 1, lty = 1, lwd = plot.line.width)
    })
    output$ROCCurve <- renderPlot({
        locale.input = input
        selected.model.number = select.auc.model(locale.input, "selected.model.auc.header")
        #message("Using number: ", selected.model.number)
        score.data = subset(all.data.table, Model == selected.model.number)[, c("Score", "TrueClass")]
        roc.result = roc(as.numeric(as.factor(score.data[, "TrueClass"])), score.data[, "Score"])
        #auc.performance <- roc.result$auc
        #auc.performance = mean(subset(auc.table, Model == selected.model.number)[, "AUC"])
        #auc.performance = subset(auc.means, Model == selected.model.number)[, "AUC"]
        auc.performance = subset(auc.means, Model == selected.model.number)[, auc.order.criterion]
        auc.performance.numeric = as.numeric(as.character(auc.performance))
        auc.label = paste("ROC AUC:", toString(round(as.numeric(auc.performance.numeric), digits = 2)))
        plot(roc.result, height = 500, width = 500, main = auc.label, cex.lab = cex.scale, cex.main = cex.scale)
    })
    #output$summary <- renderPrint({
        #summary(cars)
    #})

    #output$table <- DT::renderDataTable({
        #DT::datatable(cars)
    #})
}
