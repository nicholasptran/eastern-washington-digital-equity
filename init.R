helpers.installPackages(
  "shiny",
  "tidyverse",
  "DT",
  "mongolite",
  "shinyjs"
)

# packages <- c(
#   "shiny",
#   "tidyverse",
#   "DT",
#   "mongolite",
#   "shinyjs"
# )

# install_if_missing <- function(x) {
#   if(x %in% rownames(installed.packages()) == FALSE) {
#     install.packages(p, clean = TRUE, quiet = TRUE)
#   }
# }

# invisible(sapply(packages, install_if_missing()))