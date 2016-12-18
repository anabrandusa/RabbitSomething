setwd(data.route)
all.data.table = read.csv("alldata.csv", header = T, stringsAsFactors = F)
#auc.table = read.csv("aucdata.csv", header = T, stringsAsFactors = F)
setwd(specs.route)
specs = read.csv("specs.csv", header = T, stringsAsFactors = F)
setwd(data.random.route)
all.data.random.table = read.csv("alldata.csv", header = T, stringsAsFactors = F)
#auc.random.table = read.csv("aucdata.csv", header = T, stringsAsFactors = F)
rownames(specs) = specs[, 1]
specs = specs[, 2:ncol(specs)]
colnames(specs)=gsub("\\.", " ", colnames(specs))
auc.order.criterion = "ROCRAUC"