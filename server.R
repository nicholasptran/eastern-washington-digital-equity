source("R/functions/data_tables.R")
source("R/modules/database.R")
library(tidyverse)
library(uuid)
library(DBI)


server <- function(input, output, session) {
  observeEvent(input$addButton, {
    showModal(modalDialog(
      title = "Insert",
      textInput("nameInput", label = "name"),
      textInput("categoryInput", label = "category"),
      textInput("linkInput", label = "link"),
      easyClose = TRUE,
      footer = tagList(
        actionButton("submitButton", "Insert"),
        modalButton("Cancel"),
      )
    ))
  })

  observeEvent(input$submitButton, priority = 20, {
    sql <- "Insert into variables values (?name, ?category, ?link)"
    query <- sqlInterpolate(
      pool,
      sql,
      name = input$nameInput,
      category = input$categoryInput,
      link = input$linkInput
    )
    dbGetQuery(pool, query)
    removeModal()
  })
  

  output$variableTable <- dt1(variables)
}