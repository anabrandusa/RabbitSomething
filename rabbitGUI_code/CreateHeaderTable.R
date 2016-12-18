auc.headers.vector = c()
for (selected.model.number in 1:nrow(specs)) {
    locale.header = paste(as.character(specs[selected.model.number, 1]), "; ", as.character(specs[selected.model.number, 2]), "; ", as.character(specs[selected.model.number, 3]), "; ", as.character(specs[selected.model.number, 4]))
    auc.headers.vector = c(auc.headers.vector, locale.header)
}
output.auc.headers = cbind(1:nrow(specs), auc.headers.vector)
colnames(output.auc.headers)=c("Model", "Headers")
setwd(input.data.route)
write.csv(output.auc.headers, "aucheaders.csv")
