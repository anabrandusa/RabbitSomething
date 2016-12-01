# 10/29/2016. Author: Ana Brandusa Pavel

get.histogram.values=function(model.index){
    setwd(model.route)
    iteration.dirs = list.dirs(recursive=F)
    iteration.dirs=iteration.dirs[!grepl("^(\\.)+$",iteration.dirs)]
    score.data = c()
    for (iteration.dir in iteration.dirs) {
        setwd(file.path(iteration.dir, paste("model", toString(model.index), sep = "_")))
        score.data = c(score.data, read.table("predictions.txt", header = T, sep = "\t")[, "Score"])
        setwd("..\\..")
    }
    setwd(source.route)
    score.data
}