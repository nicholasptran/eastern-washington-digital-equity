library(tidyverse)
data <- read.csv("app/data/Household_Income.csv")
summary(data)
names(data)
data %>%
  summarise(total = With_dialup_Internet_subscription_alone_Less_than_.10.000_Income +
 With_a_broadband_Internet_subscription_Less_than_.10.000_Income) %>%
  select(With_dialup_Internet_subscription_alone_Less_than_.10.000_Income,
 With_a_broadband_Internet_subscription_Less_than_.10.000_Income,total)
