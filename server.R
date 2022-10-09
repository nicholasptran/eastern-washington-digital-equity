library(tidyverse)
source("R/functions/data_tables.R")
source("R/functions/database.R")

server <- function(input, output, session) {
  # x <- reactive({
  #   input$submit
  #   input$delete_button
  #   selectAll <- variables$find()
  # })
  output$variablesTable <- dt1(selectAll)
}