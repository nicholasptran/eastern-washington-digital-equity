helpers.installPackages(
  "shiny",
  "tidyverse",
  "RPostgres",
  "DT",
  "pool",
  "uuid",
  "DBI"
)

# packages <- c(
#   "shiny",
#   "tidyverse",
#   "DT",
# )

# install_if_missing <- function(x) {
#   if(x %in% rownames(installed.packages()) == FALSE) {
#     install.packages(p, clean = TRUE, quiet = TRUE)
#   }
# }

# invisible(sapply(packages, install_if_missing()))