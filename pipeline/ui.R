# 10/29/2016. Author: Ana Brandusa Pavel

library(markdown)

step.names=c("gene filter" , "feature selection" , "biomarker size" , "classification" )
step.labels=c("gene filter" , "feature selection" , "biomarker size" , "classifier" )
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

ui=navbarPage("Rabbit",
tabPanel("Prediction Scores",
fluidRow(splitLayout(cellWidths = c("50%", "50%"),
    sliderInput("selected.model.number", "Model combination:",
    min = 1, max = number.of.models, step = 1, value = 1
    ), selectInput("selected.model.header", label = h5("Model description"),
        choices = as.list(auc.headers[,"Headers"]),
        width = 500,
        selected = 1)
        )),
fluidRow(splitLayout(cellWidths = c("70%", "30%"),
    plotOutput("plotModelHistogram"),
    plotOutput("ROCCurve")
    )
  )
  ),
  tabPanel("Model selection",
    sidebarLayout(
      sidebarPanel(
        radioButtons("step", "Select best option for each step",
          step.labels
        )
      ),
      mainPanel(
        plotOutput("medianAuc"),
        h4("Boxplot summary"),
         DT::dataTableOutput("boxplotParameters"),
         h4("TukeyHSD comparison"),
         DT::dataTableOutput("tukeyValues")
      )
    )
  ),
  #tabPanel("Summary",
    #verbatimTextOutput("summary")
  #),
  #tabPanel("Table",
      #DT::dataTableOutput("table")
    #),
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
                tags$li("genefilter")
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


