# 10/29/2016. Author: Ana Brandusa Pavel

selected.models = function(step) {

    step.partition = list()
    number.of.step.values = 1
    specs.names=unique(specs[, step])
    for (step.value in specs.names) {
        step.value.subtable.indexes = which(specs[, step] == step.value)
        step.partition[number.of.step.values] = list(rownames(specs[step.value.subtable.indexes,]))
        number.of.step.values = number.of.step.values+1
    }
    names(step.partition)=specs.names
    return(step.partition)
}