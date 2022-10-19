library(dplyr)

variables2 <- data.frame(
  id = character(),
  name = character(),
  category = character(),
  link = character(),
  stringsAsFactors = FALSE
)

dbWriteTable(pool, "variables2", variables2, overwrite = FALSE, append = TRUE)
