library(tidyverse)
source("R/functions/data_tables.R")
source("R/functions/database.R")

server <- function(input, output) {
  output$variablesTable <- dt1(selectAll)
}