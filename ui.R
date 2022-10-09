source("server.R")

library(shinyjs)

ui <- fluidPage(
  useShinyjs(),
  h1("spokane digital equity index"),
  dataTableOutput("variableTable")

)