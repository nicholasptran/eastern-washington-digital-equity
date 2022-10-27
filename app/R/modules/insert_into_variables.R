library(dplyr)
library(DBI)

variables <- data.frame(
  id = character(),
  name = character(),
  description = character(),
  link = character(),
  stringsAsFactors = FALSE
)


dbWriteTable(con, "variables", variables, overwrite = FALSE, append = TRUE)
