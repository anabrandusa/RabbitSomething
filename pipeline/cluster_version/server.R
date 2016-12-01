# 10/29/2016. Author: Ana Brandusa Pavel

setwd(data.route)
all.data.table = read.csv("alldata.csv", header = T, stringsAsFactors = F)
auc.table =read.csv("aucdata.csv", header = T, stringsAsFactors = F)
server = function(input, output, session) {
    output$medianAuc <- renderPlot({
        selected.step = step.names[input$step]
        models.for.step = selected.models(selected.step)
        auc.for.subsets = list()
        auc.for.subsets.index = 1
        for (model.subset in models.for.step) {
            auc.for.subsets.for.model = c()
            for (model.name in model.subset) {
                model.subset=subset(auc.table, ModNames==model.name)
                model.auc.values = model.subset[,"AUC"]
                auc.for.subsets.for.model = c(auc.for.subsets.for.model, mean(model.auc.values))
                #selected.subtable = subset(all.data.table, ModNames == model.name)
                #auc.for.subsets.for.model = c(auc.for.subsets.for.model, get.mean.auc.values(model.name, selected.subtable))
            }
            auc.for.subsets.for.model.filtered = auc.for.subsets.for.model[!is.null(auc.for.subsets.for.model)]
            auc.for.subsets[auc.for.subsets.index] = list(auc.for.subsets.for.model.filtered)
            auc.for.subsets.index = auc.for.subsets.index + 1
        }
        
        names(models.for.step)[which(grepl("size", names(models.for.step))==TRUE)] <- substr(names(models.for.step)[which(grepl("size", names(models.for.step))==TRUE)], 17, nchar(names(models.for.step)[which(grepl("size", names(models.for.step))==TRUE)])-1)
        localeBoxplot = boxplot(auc.for.subsets, ylim = c(min(as.numeric(unlist(auc.for.subsets)), na.rm = TRUE), max(as.numeric(unlist(auc.for.subsets)), na.rm = TRUE)), names = names(models.for.step), col = box.col[1:length(models.for.step)])

    })
    output$boxplotParameters = renderPrint({
    summary(cars)
    })

    output$distPlot <- renderPlot({
        hist(rnorm(input$obs))
    })
    output$plotModelHistogram <- renderPlot({
        selected.model.number = input$selected.model.number
        print(paste("Serving model", toString(selected.model.number)))
        setwd(source.route)
        # score.data = get.histogram.values(selected.model.number)
        score.data = subset(all.data.table, Model==selected.model.number)[, "Score"]

        #plot(density(score.data, na.rm = TRUE), main = paste("Model combination ", selected.model.number))
        plot(density(score.data, na.rm = TRUE), main = paste(as.character(specs[selected.model.number, 1]), "; ", as.character(specs[selected.model.number, 2]), "; ", as.character(specs[selected.model.number, 3]), "; ", as.character(specs[selected.model.number, 4])))
    })
    output$summary <- renderPrint({
        summary(cars)
    })

    output$table <- DT::renderDataTable({
        DT::datatable(cars)
    })
}
