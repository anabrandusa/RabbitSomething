# 10/29/2016. Author: Ana Brandusa Pavel

library(markdown)
base.route = getwd()
setwd(base.route)
source("AppRoutes.R")
source("createHistogramTable.R")
step.names = c("gene filter", "feature selection", "biomarker size", "classification")
step.labels = c("gene filter", "feature selection", "biomarker size", "classifier")
names(step.names) = step.labels
box.col = c("blue", "magenta", "orange", "red", "brown", "green", "pink", "purple", "cyan", "yellow", "indigo")
names(box.col) = step.names
number.of.models = length(list.dirs(path = file.path(model.route, "cv_loop_1"), recursive = F))
#setwd("C:/Users/Ana/Documents/Visual Studio 2015/Projects/pipeline/pipeline")
#setwd(data.route)
#all.data.table = read.csv("alldata.csv", header = T, stringsAsFactors = F)
#message("Data table read")
#possible.iterations = unique(all.data.table$Iteration)
setwd(source.route)
source("ModelSelection.R")

setwd(source.route)
source("meanAUC.R")
source("loadStockPipeline.R")

ui=navbarPage("Rabbit",
tabPanel("Prediction Scores",
    sliderInput("selected.model.number", "Model combination:",
    min = 1, max = number.of.models, step=1, value = 1
    ),
    plotOutput("plotModelHistogram")

  ),
  tabPanel("Model selection",
    sidebarLayout(
      sidebarPanel(
        radioButtons("step", "Select best option for each step",
          step.labels
        )
      ),
      mainPanel(
        plotOutput("medianAuc")
      )
    )
  ),
  tabPanel("Summary",
    verbatimTextOutput("summary")
  ),
  tabPanel("Table",
      DT::dataTableOutput("table")
    ),
  navbarMenu("Help",
    tabPanel("Package dependencies",
      fluidRow(
        column(3,
            tags$b(
            "Dependencies for", a(href = "http://topepo.github.io/caret/index.html", "caret", target="_blank"), "package"
            ),
            tags$ul(
                tags$li("pbkrtest (R >= 3.2.3)"), 
                tags$li("car (R >= 3.2.0)"),
                tags$li("nlme (R >= 3.0.2)")
            ),
            tags$b(
            "Dependencies for", a(href = "https://github.com/jperezrogers/rabbit", "rabbit", target="_blank"), "package"
            ),
            tags$ul(
                tags$li("devtools"),
                tags$li("multtest"),
                tags$li("impute"),
                tags$li("samr"),
                tags$li("e1071"),
                tags$li("randomForest"),
                tags$li("klaR"),
                tags$li("kernlab"),
                tags$li("pROC"),
                tags$li("glmnet"),
                tags$li("limma"),
                tags$li("genefilter"),
                tags$li("pROC")
          ),
          tags$b(
            "Dependencies for ", a(href = "https://github.com/anabrandusa/rabbitGUI/", "rabbitGUI", target="_blank")
            ),
            tags$ul(
                tags$li("shiny"),
                tags$li("DT")
          )
        )
      )
    ),
    tabPanel("About",
      fluidRow(
        column(3,
        tags$b(
            "rabbitGUI v1.00"
            ),
          img(class = "img-polaroid",
            src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Rabbit_in_montana.jpg/800px-Rabbit_in_montana.jpg")
          #tags$small(
          #  a(href = "https://github.com/jperezrogers/rabbit", "rabbit", target="_blank")
          #)
        )
      )
    )
  )
 )


