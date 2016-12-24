# 10/29/2016. Author: Ana Brandusa Pavel

library(markdown)

step.names=c("gene filter" , "feature selection" , "biomarker size" , "classification" )
step.labels=c("Feature filter" , "Feature ranking" , "Size selection" , "Classification" )
names(step.names) = step.labels
box.col = c("blue", "magenta", "orange", "brown", "green", "pink", "purple", "cyan", "yellow", "indigo")
names(box.col)= step.names
number.of.models = nrow(auc.means)
#setwd("C:/Users/Ana/Documents/Visual Studio 2015/Projects/pipeline/pipeline")
#setwd(data.route)
#all.data.table = read.csv("alldata.csv", header = T, stringsAsFactors = F)
#message("Data table read")
#possible.iterations = unique(all.data.table$Iteration)
setwd(source.route)
source("ModelSelection.R")

setwd(source.route)
source("meanAUC.R")
source("calculateModelHeaders.R")
ui = navbarPage("rabbitGUI",
  tabPanel("Model selection",
    sidebarLayout(
      sidebarPanel(
        radioButtons("step", "Visualize the best option for each step",
          step.labels)),
      mainPanel(
        #h3("Mean AUC"),
        plotOutput("medianAuc"),
        h4("TukeyHSD comparison"),
         DT::dataTableOutput("tukeyValues"),
         h4("Boxplot summary"),
         DT::dataTableOutput("boxplotParameters"),
                h4("Best combination of models"),
                DT::dataTableOutput("displayBestModels")))),
tabPanel("Random mean AUC",
    sidebarLayout(
      sidebarPanel(
        radioButtons("stepComparison", "Select the best option for each step",
          step.labels)),
      mainPanel(
        h3("Real mean AUC"),
        plotOutput("medianAucComparison"),
        h3("Random mean AUC"),
        plotOutput("medianAucRandom")
))),
tabPanel("Prediction scores",
fluidRow(splitLayout(cellWidths = c("50%", "50%"),
    sliderInput("selected.model.number", "Models sorted by the the highest AUC",
    min = 1, max = number.of.models, step = 1, value = 1), selectInput("selected.model.header", label = h5("Model description"),
        choices = as.list(header.descriptions.body),
        width = 500,
        selected = 1))),
h3("Real score"),
fluidRow(splitLayout(cellWidths = c("70%", "30%"),
    plotOutput("plotModelHistogram"),
    plotOutput("ROCCurve"))),
h3("Random score"),
  fluidRow(splitLayout(cellWidths = c("70%", "30%"),
    plotOutput("plotModelHistogramRandom"),
    plotOutput("ROCCurveRandom")))),
tabPanel("View biomarker: training",
    sidebarLayout(
      sidebarPanel(
              fileInput("phenoFull", "Expression Phenotype File",
              accept = c(
              "text/csv",
              "text/comma-separated-values,text/plain",
              ".csv")),
              fileInput("sampleClassFull", "Sample Class File",
              accept = c(
              "text/csv",
              "text/comma-separated-values,text/plain",
".csv")), fileInput("featureListFull", "Feature List",
              accept = c(
              "text/txt",
              ".txt"))), mainPanel(
        plotOutput("modelHeatmapFull", height = "600px")))),
tabPanel("View biomarker: test",
    sidebarLayout(
      sidebarPanel(
              fileInput("pheno", "Expression Phenotype File",
              accept = c(
              "text/csv",
              "text/comma-separated-values,text/plain",
              ".csv")),
              fileInput("sampleClass", "Sample Class File",
              accept = c(
              "text/csv",
              "text/comma-separated-values,text/plain",
              ".csv")),
              fileInput("featureList", "Feature List",
              accept = c(
              "text/txt",
              ".txt")),
              fileInput("classifScores", "Classification Scores",
              accept = c(
              "text/txt",
              ".txt"))), mainPanel(
        
        plotOutput("modelHeatmap", height = "600px"),
fluidRow(splitLayout(cellWidths = c("20%", "40%", "20%"),
    plotOutput("Padding"),
    plotOutput("modelROCCurve"),
    plotOutput("Padding2")
    )))
)),
#tabPanel("Biomarker Heatmap",
    #sidebarLayout(
      #sidebarPanel(
        #fileInput("heatmapFile", "Choose heatmap File",
        #accept = c(
          #"text/csv",
          #"text/comma-separated-values,text/plain",
          #".csv"))),
      #mainPanel(
        #h3("Biormarker Heatmap")
##,plotOutput("biomarkerHeatmap")
#))),
#tabPanel("Model ranking",
    #sidebarLayout(
      #sidebarPanel(
        #radioButtons("step", "Select the best option for each step",
          #step.labels)),
      #mainPanel(
        #h2("AUC Comparison"),
        #h3("Real AUC"),
        #plotOutput("medianAuc"),
        #h3("Random AUC"),
        #plotOutput("medianAucRandom"),
        #h2("Boxplot summary for real AUC"),
         #DT::dataTableOutput("boxplotParameters"),
         #h4("TukeyHSD comparison"),
         #DT::dataTableOutput("tukeyValues")))),
  #tabPanel("Summary",
    #verbatimTextOutput("summary")
  #),
  #tabPanel("Table",
      #DT::dataTableOutput("table")
    #),
  #navbarMenu("Help",
    #tabPanel("Package dependencies",
      #fluidRow(
        #column(3,
            #tags$b(
            #"Dependencies for", a(href = "http://topepo.github.io/caret/index.html", "caret", target="_blank"), "package"
            #),
            #tags$ul(
                #tags$li("pbkrtest (R >= 3.2.3)"), 
                #tags$li("car (R >= 3.2.0)"),
                #tags$li("nlme (R >= 3.0.2)")
            #),
            #tags$b(
            #"Dependencies for", a(href = "https://github.com/jperezrogers/rabbit", "rabbit", target="_blank"), "package"
            #),
            #tags$ul(
                #tags$li("devtools"),
                #tags$li("multtest"),
                #tags$li("impute"),
                #tags$li("samr"),
                #tags$li("e1071"),
                #tags$li("randomForest"),
                #tags$li("klaR"),
                #tags$li("kernlab"),
                #tags$li("pROC"),
                #tags$li("glmnet"),
                #tags$li("limma"),
                #tags$li("genefilter")
          #),
          #tags$b(
            #"Dependencies for ", a(href = "https://github.com/anabrandusa/rabbitGUI", "rabbitGUI", target="_blank")
            #),
            #tags$ul(
                #tags$li("shiny"),
                #tags$li("DT")
          #)
        #)
      #)
    #),
    tabPanel("About",
      fluidRow(
        column(3,
        tags$b(
            a(href = "https://github.com/jperezrogers/rabbit", "rabbit package", target = "_blank"),
            renderText(paste("", "", sep = "\n")),
            a(href = "https://github.com/anabrandusa/rabbitGUI/", "rabbitGUI v1.00", target = "_blank")),
         img(class = "img-polaroid",
            src = "https://avatars1.githubusercontent.com/u/5145014?v=3&s=400")
#tags$small(
#  a(href = "https://github.com/jperezrogers/rabbit", "rabbit", target="_blank")
#)


#   )
        )
      )
    )
  )


