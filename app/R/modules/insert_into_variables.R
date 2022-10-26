library(dplyr)
library(DBI)

variables2 <- data.frame(
  id = character(),
  name = character(),
  description = character(),
  link = character(),
  stringsAsFactors = FALSE
)


dbWriteTable(CON, "variables2", variables2, overwrite = FALSE, append = TRUE)
