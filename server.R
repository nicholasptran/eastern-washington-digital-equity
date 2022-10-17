source("R/functions/data_tables.R")
source("R/modules/database.R")
source("R/modules/insert_into_variables.R")

library(uuid)
library(DBI)



server <- function(input, output, session) {

  insert_input <- reactive({
    input$submit
    input$submit_edit
    input$delete_button

    dbReadTable(pool, "variables2")
  })

  inputForm <- function(button) {
    showModal(modalDialog(
      title = "Insert",
      textInput("name", label = "name"),
      textInput("category", label = "category"),
      textInput("link", label = "link"),
      easyClose = TRUE,
      actionButton(button, "Submit")
    ))
  }

  all_fields <- c("Name", "Category", "Link")

  inputFormData <- reactive({
    inputFormData <- data.frame(
      id = UUIDgenerate(),
      name = input$name,
      category = input$category,
      link = input$link,
      stringsAsFactors = FALSE
    )
    return(inputFormData)
  })

  # add button
  appendData <- function(data) {
    x <- sqlAppendTable(pool, "variables2", data, row.names = FALSE)
    dbExecute(pool, x)
  }

  observeEvent(input$add_button, priority = 20, {
    inputForm("submit")
  })

  observeEvent(input$submit, priority = 20, {
    appendData(inputFormData())
    removeModal()
  })


  # delete button
  deleteData <- reactive({
    x <- dbReadTable(pool, "variables2")
    y <- x[input$variable_table_rows_selected, "id"]
    z <- lapply(y, function(nr){
      dbExecute(
        pool,
        sprintf('delete from "variables2" where "id" = (\'%s\')', nr)
      )
    })
  })

  observeEvent(input$delete_button, priority = 20, {
    if (length(input$variable_table_rows_selected) >= 1) {
      deleteData()
    }
  })


  # edit button
  observeEvent(input$edit_button, priority = 20, {
    x <- dbReadTable(pool, "variables2")

    showModal(
      if (length(input$variable_table_rows_selected) > 1) {
        modalDialog(
          title = "Error",
          paste("Only select 1 row."),
          easyClose = TRUE
        )
      }
      else if (length(input$variable_table_rows_selected) < 1) {
        modalDialog(
          title = "Error",
          paste("Select a row."),
          easyClose = TRUE
        )
      }
    )

    if(length(input$variable_table_rows_selected) == 1) {
      inputForm("submit_edit")

      updateTextInput(session, "name", value = x[input$variable_table_rows_selected, "name"])
      updateTextInput(session, "category", value = x[input$variable_table_rows_selected, "category"])
      updateTextInput(session, "link", value = x[input$variable_table_rows_selected, "link"])
    }
  })

  observeEvent(input$submit_edit, priority = 20, {
    x2 <- dbReadTable(pool, "variables2")
    y2 <- x2[input$variable_table_last_clicked, "id"]

    dbExecute(pool, sprintf(
      'update "variables2" set \'name\' = ?, \'category\' = ? \'link\' = ?
      where \'id\' = (\'%s\')', y2
    ),
    param = list(input$name, input$category, input$link)
    )
  removeModal()
  })

  # render variable table
  output$variable_table <- renderDataTable({
    table <- insert_input() %>%
      select(-id)

    names(table) <- all_fields

    table <- datatable(
      table,
      rownames = FALSE
    )
  })
}