library(tidyverse)
source("R/functions/data_tables.R")
source("R/modules/database.R")




server <- function(input, output, session) {
  output$variableTable <- dt1(variables)
}