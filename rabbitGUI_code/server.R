# 10/29/2016. Author: Ana Brandusa Pavel
#setwd(data.route)
#all.data.table = read.csv("alldata.csv", header = T, stringsAsFactors = F)
#auc.table = read.csv("aucdata.csv", header = T, stringsAsFactors = F)
options(shiny.maxRequestSize = 100 * 1024 ^ 2)
setwd(source.route)
source("aucModelSelection.R")
source("PlotMedianAUC.R")
source("PlotModelHistogram.R")
source("PlotROCCurve.R")
source("PlotHeatmap.R")
source("PlotTestROCCurve.R")
source("GetRocResult.R")
source("GetAUCClassification.R")
source("DisplayBestModelsTable.R")
cex.scale = 1.5
plot.line.width = 2
displayed.digits = 3
first.selection = T
selected.model.header = selected.model.number = selected.model.auc.header = selected.model.header.random = selected.model.auc.header.random = F
server = function(input, output, session) {
    output$medianAuc <- renderPlot({
        selected.step = step.names[input$step];
        plotMedianAUC(selected.step, auc.means)
    })
    output$medianAucComparison <- renderPlot({
    selected.step = step.names[input$stepComparison];
    plotMedianAUC(selected.step, auc.means, F, random.auc.means)
    })
    #output$medianAucRandom <- renderPlot({
    #selected.step = step.names[input$stepComparison];
    #plotMedianAUC(selected.step, auc.means, F, random.auc.means)
    #})
    output$boxplotParameters <- DT::renderDataTable({
        input$step
        DT::datatable(round(aucSubsetInfo, digits = displayed.digits))
    })
    output$tukeyValues <- DT::renderDataTable({
        input$step
        locale.tukey.table = filtered.tukey.table
        locale.tukey.table = locale.tukey.table[, c("diff", "p adj")]
        colnames(locale.tukey.table) = c("difference in means", "adjusted p-value")
        DT::datatable(round(locale.tukey.table, digits = displayed.digits))
    })
    #output$bestModels <- DT::renderDataTable({
    #input$step
    #locale.tukey.table = filtered.tukey.table
    #locale.tukey.table = locale.tukey.table[, c("diff", "p adj")]
    #colnames(locale.tukey.table) = c("difference in means", "p-value")
    #DT::datatable(round(locale.tukey.table, digits = displayed.digits))
    #})
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
    plotROCCurve(locale.input, all.data.random.table, random.auc.headers, random.auc.means, "selected.model.auc.header.random")})
            output$modelHeatmap = renderPlot({

                pheno.file = input$pheno
                sample.class.file = input$sampleClass
                classification.scores.file = input$classifScores
                feature.list.file = input$featureList
                if (!is.null(pheno.file) && !is.null(sample.class.file) && !is.null(classification.scores.file) && !is.null(feature.list.file)) {
                plotHeatmap(pheno.file, sample.class.file, feature.list.file, classification.scores.file)
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
    output$modelHeatmapFull = renderPlot({ 
                                          pheno.file = input$phenoFull
                                          sample.class.file = input$sampleClassFull
                                          feature.list.file = input$featureListFull
                                          if (!is.null(pheno.file) && !is.null(sample.class.file) && !is.null(feature.list.file)) {
                                          plotHeatmap(pheno.file, sample.class.file, feature.list.file)
                                          }
                                          })
    output$displayBestModels = DT::renderDataTable({
        DT::datatable(displayBestModelsTable(), options = list(
        order = list(list(5, 'desc'))))
        
    })
    shinyjs::onclick("boxplotSummaryHeader",
                      shinyjs::toggle(id = "boxplotSummary", anim = TRUE))
#output$summary <- renderPrint({
#summary(cars)
#})

#output$table <- DT::renderDataTable({
#DT::datatable(cars)
#})
}
