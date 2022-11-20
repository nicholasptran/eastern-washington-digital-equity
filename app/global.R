source("R/functions/data_tables.R")
source("R/modules/analysis_tab.R")
source("R/ui/home_tab.R")
source("R/modules/initialize_data.R")
source("R/functions/standardize.R")


library(uuid)
library(shinydashboard)
library(psych)
library(ggplot2)


options(
  DT.extentions = list("Scroller, FixedHeader"),
  DT.options = list(
    server = TRUE,
    scrollY = 300,
    scrollX = TRUE,
    scroller = FALSE,
    pageLength = 15,
    lengthMenu = c(15, 30, 100),
    height = "200px",
    fixedHeader = TRUE
  ),
  repr.plot.width = 15,
  repr.plot.height = 5
)

