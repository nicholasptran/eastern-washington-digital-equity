# install.packages("mongolite")

library(mongolite)

connection_string <- "mongodb+srv://me:password2@cluster0.jev0lo5.mongodb.net/spokane_digital_equity"
variables <- mongo(collection = "variables", db = "spokane_digital_equity", url = connection_string)

variables$count()

selectAll <- variables$find()


insertStr <- c(
  '{"name": "test2",
  "category": "deez nutz",
  "link": "pornhub.com"}'
)
variables$insert(insertStr)

variables$disconnect
