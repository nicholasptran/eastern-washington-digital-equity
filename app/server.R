source("global.R")

server <- function(input, output, session) {
  insert_input <- reactive({
    input$submit
    input$submit_edit
    input$delete_button

    DBI::dbReadTable(con, "variables")
  })

  inputForm <- function(button) {
    showModal(modalDialog(
      title = "Insert",
      textInput("name", label = "name"),
      textAreaInput("description", label = "description"),
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
    x <- DBI::sqlAppendTable(con, "variables", data, row.names = FALSE)
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
    x <- DBI::dbReadTable(con, "variables")
    y <- x[input$variable_table_rows_selected, "id"]
    z <- lapply(y, function(nr) {
      dbExecute(
        con,
        sprintf('delete from "variables" where "id" = (\'%s\')', nr)
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
    x <- dbReadTable(con, "variables")

    showModal(
      if (length(input$variable_table_rows_selected) > 1) {
        modalDialog(
          title = "Error",
          paste("Only select 1 row."),
          easyClose = TRUE
        )
      } else if (length(input$variable_table_rows_selected) < 1) {
        modalDialog(
          title = "Error",
          paste("Select a row."),
          easyClose = TRUE
        )
      }
    )

    if (length(input$variable_table_rows_selected) == 1) {
      inputForm("submit_edit")

      updateTextInput(session, "name", value = x[input$variable_table_rows_selected, "name"])
      updateTextInput(session, "description", value = x[input$variable_table_rows_selected, "description"])
      updateTextInput(session, "link", value = x[input$variable_table_rows_selected, "link"])
    }
  })

  observeEvent(input$submit_edit, priority = 20, {
    x2 <- dbReadTable(con, "variables")
    y2 <- x2[input$variable_table_last_clicked, "id"]

    dbExecute(con, sprintf(
      'update "variables" set \'name\' = ?, \'description\' = ? \'link\' = ?
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

  output$dirty_data_table <- renderDataTable(head(dirty_data))
  output$clean_data_table <- renderDataTable(head(household_income_data))
  output$hh_income_table <- renderDataTable(head(household_income_data))
  output$ss_income_table <- renderDataTable(head(ss_income_data))
  output$public_assistance_table <- renderDataTable(head(public_assistance_data))
  output$naturalization_table <- renderDataTable(head(naturalization_data))
  output$nativity_table <- renderDataTable(head(nativity_data))
  output$transporation_table <- renderDataTable(head(transportation_data))
  output$poverty_table <- renderDataTable(head(poverty_data))
  output$types_computer_table <- renderDataTable(head(types_computer_data))
  output$presence_computer_table <- renderDataTable(head(presence_computer_data))
  output$internet_subscription_table <- renderDataTable(head(internet_subscription_data))
  output$voting_age_table <- renderDataTable(head(voting_age_data))
  output$occupation_over_16_table <- renderDataTable(head(occupation_over_16_data))
  output$type_computer_internet_sub_table <- renderDataTable(head(type_computer_internet_sub_data))

  # ANALYSIS PAGE
  output$sum_hh <- renderDataTable(summ_hh)
  output$sum_ss <- renderDataTable(summ_ss)
  output$sum_pad <- renderDataTable(summ_pad)
  output$sum_naturalization <- renderDataTable(summ_naturalization)
  output$sum_nativity <- renderDataTable(summ_nativity)
  output$sum_transportation <- renderDataTable(summ_transportation)
  output$sum_poverty <- renderDataTable(summ_poverty)
  output$sum_type_comp <- renderDataTable(summ_type_comp)
  output$sum_presence_comp <- renderDataTable(summ_presence_comp)
  output$sum_internet_sub <- renderDataTable(summ_internet_sub)
  output$sum_voting_age <- renderDataTable(summ_voting_age)
  output$sum_occupation <- renderDataTable(summ_occupation)
  output$sum_type_comp_internet <- renderDataTable(summ_type_comp_internet)
  output$sum_type_internet_sub <- renderDataTable(summ_type_internet_sub)

  output$hh_plot <- renderPlot(hh_plot)



  # areaReactive <- reactive(
  #   DBI::dbReadTable(con, "area_data")
  # )

  # waFixedReactive <- reactive(
  #   DBI::dbReadTable(con, "wa_fixed_data")
  # )

  # countyReactive <- reactive(
  #   DBI::dbReadTable(con, "county_info")
  # )

  # output$area_table <- renderDataTable(table <- areaReactive(),
  #   table <- datatable(table))
  # output$wa_fixed_table <- renderDataTable(table <- waFixedReactive())
  # output$county_table <- renderDataTable(table <- countyReactive())
}