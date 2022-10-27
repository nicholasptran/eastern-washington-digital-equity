source("R/functions/data_tables.R")
source("R/functions/database.R")
source("R/modules/insert_into_variables.R")
source("R/modules/intro_dt.R")

library(uuid)
library(DBI)
library(dbplyr)
library(shinydashboard)

options(
    DT.extentions = "Scroller",
    DT.options = list(
        scrollY = 300,
        scrollX = TRUE,
        scroller = TRUE,
        pageLength = 15,
        lengthMenu = c(15, 30, 100),
        height = "200px"
    )
)
