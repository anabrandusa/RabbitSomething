library(gplots)
setwd("C:/Users/manu_/OneDrive/Documentos/pipeline/pipeline_code/data_classified")
removeFirstColumns = function(input.file) {
    buffer.file = read.csv(input.file, header = T, stringsAsFactors = F)
    rownames(buffer.file) = buffer.file[, 1]
    as.matrix(buffer.file[, 2:ncol(buffer.file)])
}
#par(mar = c(6, 6, 6, 6))
file.route.1 = "exp_pheno1.csv"
file.route.2 = "exp_pheno2.csv"
pheno.table.1 = removeFirstColumns(file.route.1)
pheno.table.2 = removeFirstColumns(file.route.2)
heatmap.scale <- colorRampPalette(c("blue", "white", "red"))
heatmap.colors = c(rep("green", ncol(pheno.table.1)), rep("magenta", ncol(pheno.table.2)))
heatmap.matrix = t(scale(t(cbind(pheno.table.1, pheno.table.2))))
heatmap.plot = heatmap.2(heatmap.matrix,
          main = "",
          col = heatmap.scale,
          #col=bluered,
          Rowv = TRUE,
          #Rowv=FALSE,
          Colv = TRUE,
          #Colv=FALSE,
          trace = "none",
          density.info = "none",
          #xlab = "cell lines",
          #ylab = "data types",
          # #hclustfun = hclust,
          scale = c("none"),
          ColSideColors = heatmap.colors,
          #labRow=c(" "," "),
          cexRow = .5,
          cexCol = .5,
          #lmat=rbind(c(5, 1, 6), c(3, 2, 4), c(7,8,9)), lhei=c(2.5, 10,2), lwid=c(2, 10, 2)
          #5 - legend, 4 - column dendrogram, 3 - rowdendrogram, 2 - heatmap, 6,7,1 - padding
          lmat = rbind(c(0,5, 4, 0), c(0, 0, 1, 0), c(0, 3, 2, 0), c(0, 7, 8, 6)), lhei = c(4, .5, 10, 2.5), lwid = c(2, 4, 10, 2.5)

#good key
         #lmat=rbind(c(5, 0,0, 0), c(0,0,4,0),c(0,3, 2, 0), c(0,7,1,6)), lhei=c(2, 2.5,20,2.5), lwid=c(2,2.5, 2, 2.5)
         )
#dev.off()