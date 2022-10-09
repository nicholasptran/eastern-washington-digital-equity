library(RPostgres)
library(DBI)

# con <- dbConnect(Postgres(),
#   dbname = "dakj5goln6tg15",
#   host = "ec2-44-207-133-100.compute-1.amazonaws.com",
#   port = 5432,
#   user = "drpevzrnxesrae",
#   password = "e3f84705089a803f65456ceae142a0579246aa21d5d78c5bd466ce0fee970f92"
# )
pool <- dbPool(Postgres(),
  dbname = "dakj5goln6tg15",
  host = "ec2-44-207-133-100.compute-1.amazonaws.com",
  port = 5432,
  user = "drpevzrnxesrae",
  password = "e3f84705089a803f65456ceae142a0579246aa21d5d78c5bd466ce0fee970f92"
)
