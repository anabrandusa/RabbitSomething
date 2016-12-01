# 10/29/2016. Author: Ana Brandusa Pavel

library(markdown)

base.route = getwd()
source(paste(base.route, "/AppRoutes.R", sep = ""))
source(paste(base.route, "/createHistogramTable.R", sep = ""))
step.names=c("gene filter" , "feature selection" , "biomarker size" , "classification" )
step.labels=c("gene filter" , "feature selection" , "biomarker size" , "classifier" )
names(step.names) = step.labels
box.col = c("blue", "magenta", "orange", "red", "brown", "green", "pink", "purple", "cyan", "yellow", "indigo")
names(box.col)= step.names
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
  navbarMenu("More",
    tabPanel("Table",
      DT::dataTableOutput("table")
    ),
    tabPanel("About",
      fluidRow(
        column(3,
          img(class = "img-polaroid",
            src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Rabbit_in_montana.jpg/800px-Rabbit_in_montana.jpg"),
            #src = paste0("http://upload.wikimedia.org/",
            #"wikipedia/commons/9/92/",
            #"1919_Ford_Model_T_Highboy_Coupe.jpg")),
          tags$small(
            "Source: Photographed at the Bay State Antique ",
            "Automobile Club's July 10, 2005 show at the ",
            "Endicott Estate in Dedham, MA by ",
            a(href = "http://commons.wikimedia.org/wiki/User:Sfoskett",
              "User:Sfoskett")
          )
        )
      )
    )
  )
 )


