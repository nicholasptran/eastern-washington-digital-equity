library(shiny)
library(dplyr)
library(RPostgres)
library(DBI)
library(pool)


con <- dbConnect(Postgres(),
  dbname = Sys.getenv("DATABASE_NAME"),
  host = Sys.getenv("DATABASE_HOST"),
  port = Sys.getenv("DATABASE_PORT"),
  user = Sys.getenv("DATABASE_USER"),
  password = Sys.getenv("DATABASE_PASSWORD")
)

variableTable <- c(
  "name" = "varchar",
  "description" = "varchar",
  "link" = "varchar"
)
dbCreateTable(con,
  "variables2",
  variableTable
)


onStop(function() {
  poolClose(con)
})


