library(tidyverse)
source("server.R")

ui <- fluidPage(
  h1("spokane digital equity index"),
  dataTableOutput("variablesTable")
)