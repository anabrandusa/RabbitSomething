# 10/29/2016. Author: Ana Brandusa Pavel
#setwd(data.route)
#all.data.table = read.csv("alldata.csv", header = T, stringsAsFactors = F)
#auc.table = read.csv("aucdata.csv", header = T, stringsAsFactors = F)
options(shiny.maxRequestSize=100*1024^2)
setwd(source.route)
source("aucModelSelection.R")
source("PlotMedianAUC.R")
source("PlotModelHistogram.R")
source("PlotROCCurve.R")
source("PlotHeatmap.R")
source("PlotTestROCCurve.R")
source("GetRocResult.R")
cex.scale = 1.5
plot.line.width=2
selected.model.header = selected.model.number = selected.model.auc.header = selected.model.header.random = selected.model.auc.header.random = F
server = function(input, output, session) {
    output$medianAuc <- renderPlot({
        selected.step = step.names[input$step];
        plotMedianAUC(selected.step, all.data.table, auc.means)
    })
    output$medianAucComparison <- renderPlot({
    selected.step = step.names[input$stepComparison];
    plotMedianAUC(selected.step, all.data.table, auc.means)
    })
    output$medianAucRandom <- renderPlot({
    selected.step = step.names[input$stepComparison];
    plotMedianAUC(selected.step, all.data.random.table, random.auc.means, F)
    })
    output$boxplotParameters <- DT::renderDataTable({
        input$step
        DT::datatable(round(aucSubsetInfo, digits = 3))
    })
    output$tukeyValues <- DT::renderDataTable({
        input$step
        locale.tukey.table = filtered.tukey.table
        locale.tukey.table = locale.tukey.table[, c("diff", "p adj")]
        colnames(locale.tukey.table) = c("difference in means", "p-value")
        DT::datatable(round(locale.tukey.table, digits = 3))
    })
    output$distPlot <- renderPlot({
        hist(rnorm(input$obs))
    })
    output$plotModelHistogram <- renderPlot({
    locale.input = input;
    plotModelHistogram(locale.input, all.data.table, auc.headers, auc.means, "selected.model.header")
    })
    output$ROCCurve <- renderPlot({
    locale.input = input
    plotROCCurve(locale.input, all.data.table, auc.headers, auc.means, "selected.model.auc.header")
})
        output$plotModelHistogramRandom <- renderPlot({
    locale.input = input;
    plotModelHistogram(locale.input, all.data.random.table, random.auc.headers, random.auc.means, "selected.model.header.random")
        })
        output$ROCCurveRandom <- renderPlot({
    locale.input = input
    plotROCCurve(locale.input, all.data.random.table, random.auc.headers, random.auc.means, "selected.model.auc.header.random")
    output$modelHeatmap = renderPlot({
                pheno.file.1 = input$pheno1
                pheno.file.2 = input$pheno2
                classification.scores.file = input$classifScores
                feature.list.file = input$featureList
                if (!is.null(pheno.file.1) && !is.null(pheno.file.2) && !is.null(classification.scores.file) && !is.null(feature.list.file)) {
                    plotHeatmap(pheno.file.1, pheno.file.2, classification.scores.file, feature.list.file)
                }
                })
            output$modelROCCurve = renderPlot({
                classification.scores.file = input$classifScores
         
         if (!is.null(classification.scores.file)) {
              classification.scores.file = classification.scores.file$datapath
             classification.scores.directory = strsplit(classification.scores.file, .Platform["file.sep"][[1]])
                    classification.scores.directory = classification.scores.directory[length(classification.scores.directory) - 1]
                    plotTestROCCurve(classification.scores.file, classification.scores.directory)
                }
            })
})
    output$modelHeatmapFull = renderPlot({ 
                                          pheno.file.1 = input$phenoFull1
                                          pheno.file.2 = input$phenoFull2
                                          if (!is.null(pheno.file.1) && !is.null(pheno.file.2)) {
                                             plotHeatmap(pheno.file.1, pheno.file.2)
                                          }
                                         })

#output$summary <- renderPrint({
#summary(cars)
#})

#output$table <- DT::renderDataTable({
#DT::datatable(cars)
#})
}
