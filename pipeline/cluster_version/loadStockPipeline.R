# 10/29/2016. Author: Ana Brandusa Pavel

library(rabbit)
data("stockPipeline")
specs <- stockPipeline$getModelSpecs()
rownames(specs) = gsub("^M", "m", rownames(specs))
setwd(data.route)
pheno.data = read.csv("pheno.csv", header = T)
class.types = pheno.data$characteristics_ch1.10
names(class.types) = pheno.data$geo_accession
setwd(source.route)

    


