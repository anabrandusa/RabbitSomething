library(gplots)
removeFirstColumns = function(input.file) {
    buffer.file = read.csv(input.file, header = T, stringsAsFactors = F)
    rownames(buffer.file) = buffer.file[, 1]
    as.matrix(buffer.file[, 2:ncol(buffer.file)])
}

plotHeatmap = function(pheno.file.1, pheno.file.2, classification.scores.file=NULL, feature.list=NULL) {
    file.route.1 = pheno.file.1$datapath
    file.route.2 = pheno.file.2$datapath
    pheno.table.1 = removeFirstColumns(file.route.1)
    pheno.table.2 = removeFirstColumns(file.route.2)
    if (!is.null(classification.scores.file) && !is.null(feature.list)) {
        classification.file.route = classification.scores.file$datapath
        feature.list.file.route = feature.list$datapath
        selected.samples = sapply(read.table(classification.file.route, header = T)[, "Sample"], as.character)
        selected.features = read.table(feature.list.file.route, header = F)[, 1]
        pheno.table.1 = pheno.table.1[rownames(pheno.table.1)[rownames(pheno.table.1) %in% selected.features], colnames(pheno.table.1)[colnames(pheno.table.1) %in% selected.samples]]
        pheno.table.2 = pheno.table.2[rownames(pheno.table.2)[rownames(pheno.table.2) %in% selected.features], colnames(pheno.table.2)[colnames(pheno.table.2) %in% selected.samples]]
    } else {
        row.intersection = intersect(rownames(pheno.table.1), rownames(pheno.table.2))
        pheno.table.1 = pheno.table.1[row.intersection, ]
        pheno.table.2 = pheno.table.2[row.intersection, ]
    }
    heatmap.scale <- colorRampPalette(c("blue", "white", "red"))
    heatmap.colors = c(rep("green", ncol(pheno.table.1)), rep("orange", ncol(pheno.table.2)))
    combined.table = cbind(pheno.table.1, pheno.table.2)
    heatmap.matrix = t(scale(t(combined.table)))
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
          cexRow = .8,
          cexCol = .8,
          #lmat=rbind(c(5, 1, 6), c(3, 2, 4), c(7,8,9)), lhei=c(2.5, 10,2), lwid=c(2, 10, 2)
          #5 - legend, 4 - column dendrogram, 3 - rowdendrogram, 2 - heatmap, 6,7,1 - padding
          lmat = rbind(c(0, 5, 4, 0), c(0, 0, 1, 0), c(0, 3, 2, 0), c(0, 7, 8, 6)), lhei = c(4, .5, 10, 2.5), lwid = c(2, 4, 10, 2.5)

    #good key
         #lmat=rbind(c(5, 0,0, 0), c(0,0,4,0),c(0,3, 2, 0), c(0,7,1,6)), lhei=c(2, 2.5,20,2.5), lwid=c(2,2.5, 2, 2.5)
         )
}

          