select.auc.model = function(locale.input, fetched.variable, input.auc.headers=auc.headers, input.auc.means=auc.means) {
    preliminary.selected.model.number = input.auc.means[locale.input$selected.model.number, "Model"]
    preliminary.selected.model.header = locale.input$selected.model.header
    select.with.number = T
    if ((!first.selection) && (preliminary.selected.model.header != get(fetched.variable))) {    
        select.with.number = F
    }
    assign("first.selection", F, envir = .GlobalEnv)
    if (select.with.number) {
        selected.model.number = preliminary.selected.model.number
    } else {
        selected.model.number = input.auc.headers[which(input.auc.headers[, "Headers"] == preliminary.selected.model.header), "Model"]
    }
    assign("selected.model.number", preliminary.selected.model.number, envir = .GlobalEnv)
    assign(fetched.variable, preliminary.selected.model.header, envir = .GlobalEnv)
    #message("Selected model header: ", preliminary.selected.model.header)
    selected.model.number
}