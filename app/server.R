source("global.R")

server <- function(input, output, session) {

  insert_input <- reactive({
    input$submit
    input$submit_edit
    input$delete_button

    DBI::dbReadTable(con, "variables2")
  })

  inputForm <- function(button) {
    showModal(modalDialog(
      title = "Insert",
      textInput("name", label = "name"),
      textInput("description", label = "description"),
      textInput("link", label = "link"),
      easyClose = TRUE,
      actionButton(button, "Submit")
    ))
  }

  all_fields <- c("Name", "Description", "Link")

  inputFormData <- reactive({
    inputFormData <- data.frame(
      id = UUIDgenerate(),
      name = input$name,
      description = input$description,
      link = input$link,
      stringsAsFactors = FALSE
    )
    return(inputFormData)
  })

  # add button
  appendData <- function(data) {
    x <- DBI::sqlAppendTable(con, "variables2", data, row.names = FALSE)
    DBI::dbExecute(con, x)
  }

  observeEvent(input$add_button, priority = 20, {
    inputForm("submit")
  })

  observeEvent(input$submit, priority = 20, {
    appendData(inputFormData())
    shiny::removeModal()
  })


  # delete button
  deleteData <- reactive({
    x <- DBI::dbReadTable(con, "variables2")
    y <- x[input$variable_table_rows_selected, "id"]
    z <- lapply(y, function(nr) {
      dbExecute(
        con,
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
    x <- dbReadTable(con, "variables2")

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
      updateTextInput(session, "description", value = x[input$variable_table_rows_selected, "description"])
      updateTextInput(session, "link", value = x[input$variable_table_rows_selected, "link"])
    }
  })

  observeEvent(input$submit_edit, priority = 20, {
    x2 <- dbReadTable(con, "variables2")
    y2 <- x2[input$variable_table_last_clicked, "id"]

    dbExecute(con, sprintf(
      'update "variables2" set \'name\' = ?, \'description\' = ? \'link\' = ?
      where \'id\' = (\'%s\')', y2
    ),
    param = list(input$name, input$description, input$link)
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