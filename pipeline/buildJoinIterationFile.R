# 10/29/2016. Author: Ana Brandusa Pavel

table.columns = c("Iteration", "Model", "ModNames", "TrueClass", "Sample", "Score", "Classification")
setwd(model.route)
iteration.dirs = list.dirs(recursive = F)
iteration.dirs = iteration.dirs[!grepl("^(\\.)+$", iteration.dirs)]
all.data.table = matrix(nrow = 0, ncol = length(table.columns))
colnames(all.data.table) = table.columns
for (iteration.dir in iteration.dirs) {
    iteration.locale.index = as.numeric(gsub("\\./cv_loop_", "", iteration.dir))
    setwd(iteration.dir)
    model.dirs = list.dirs(recursive = F)
    model.dirs = model.dirs[!grepl("^(\\.)+$", model.dirs)]
    for (model.dir in model.dirs) {
        model.locale.index = as.numeric(gsub("\\./model_", "", model.dir))
        model.name = paste("model", toString(model.locale.index), sep = "_")
        setwd(model.dir)
        prediction.table = subset(read.table("predictions.txt", dec = ".", header = T, sep = "\t"), !is.na(Score))
        num.preds = nrow(prediction.table)
        if (num.preds > 0) {

            combined.model.prediction.table = cbind(rep(iteration.locale.index, num.preds), rep(model.locale.index, num.preds), rep(model.name, num.preds), class.types[prediction.table$Sample], prediction.table)
            all.data.table = rbind(all.data.table, combined.model.prediction.table)
            setwd(file.path(model.route, iteration.dir, model.dir))
            
        }
        setwd("..")
    }
    setwd("..")
}
all.data.table = all.data.table[order(all.data.table$Iteration, all.data.table$Model),]
setwd(data.route)
write.table(all.data.table, "alldata.csv", sep = ",", row.names = T)