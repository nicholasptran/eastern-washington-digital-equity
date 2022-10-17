source("server.R")

ui <- fluidPage(
  title = "Spokane Digital Equity",
  fluidRow(
    h1("Spokane Digital Equity")
  ),

  br(),
  fluidRow(
    actionButton("add_button", "Add", icon("plus")),
    actionButton("edit_button", "Edit", icon("edit")),
    actionButton("delete_button", "Delete", icon("trash-alt"))
  ),
  br(),
  dataTableOutput("variable_table", width = "100%")
)