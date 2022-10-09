library(tidyverse)
library(shinyjs)
source("server.R")

ui <- fluidPage(
  useShinyjs(),
  h1("spokane digital equity index"),
  fluidRow(
    actionButton("add_button", "Add", icon("plus")),
    actionButton("delete_button", "Delete", icon("trash-alt"))
  ),
  fluidRow(
    width = "100%",
    dataTableOutput("variablesTable", width = "100%")
  )
)