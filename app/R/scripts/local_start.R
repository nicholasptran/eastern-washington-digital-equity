library(shiny)
source("app/R/scripts/local.R")



options(shiny.autoreload = TRUE, shiny.launch.browser = TRUE)

shinyAppDir("app")
runApp()

