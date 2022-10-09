library(tidyverse)
source("R/functions/data_tables.R")
source("R/modules/database.R")
library(RPostgres)
library(DBI)
library(pool)

pool <- dbPool(Postgres(),
  dbname = "dakj5goln6tg15",
  host = "ec2-44-207-133-100.compute-1.amazonaws.com",
  port = 5432,
  user = "drpevzrnxesrae",
  password = "e3f84705089a803f65456ceae142a0579246aa21d5d78c5bd466ce0fee970f92"
)

onStop(function(){
  poolClose(pool)
})


variables <- pool %>%
  tbl("variables") %>% 
  collect()


server <- function(input, output, session) {
  output$variableTable <- dt1(variables)
}