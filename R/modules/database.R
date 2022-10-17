library(RPostgres)
library(DBI)
library(pool)
library(tidyverse)
library(shiny)


pool <- dbPool(Postgres(),
  dbname = "dakj5goln6tg15",
  host = "ec2-44-207-133-100.compute-1.amazonaws.com",
  port = 5432,
  user = "drpevzrnxesrae",
  password = "e3f84705089a803f65456ceae142a0579246aa21d5d78c5bd466ce0fee970f92"
)

onStop(function() {
  poolClose(pool)
})


variables <- pool %>%
  tbl("variables") %>%
  data.frame()



