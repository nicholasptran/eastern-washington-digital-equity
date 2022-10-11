source("server.R")

library(shinyjs)

ui <- fluidPage(
  useShinyjs(),
  title = "Spokane Digital Equity",
  fluidRow(
    h1("Spokane Digital Equity"),
    fileInput(
      inputId = "csvInput",
      label = "Import .csv (not working)"
    )
  ),

  br(),
  fluidRow(
    actionButton("addButton", "Add"),
    actionButton("editButton", "Edit"),
    actionButton("deleteButton", "Delete")
  ),
  br(),
  dataTableOutput("variableTable", width = "100%")
)