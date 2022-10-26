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

variables2 <- data.frame(
  id = character(),
  name = character(),
  description = character(),
  link = character(),
  stringsAsFactors = FALSE
)


dbWriteTable(con, "variables2", variables2, overwrite = FALSE, append = TRUE)


onStop(function() {
  dbDisconnect(con)
})