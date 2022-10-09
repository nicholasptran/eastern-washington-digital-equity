helpers.installPackages(
  "shiny",
  "tidyverse",
  "DT",
  "shinyjs",
  "pool",
  "RPostgres"
)

# packages <- c(
#   "shiny",
#   "tidyverse",
#   "DT",
#   "shinyjs"
# )

# install_if_missing <- function(x) {
#   if(x %in% rownames(installed.packages()) == FALSE) {
#     install.packages(p, clean = TRUE, quiet = TRUE)
#   }
# }

# invisible(sapply(packages, install_if_missing()))