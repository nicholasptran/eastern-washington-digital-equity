library(tidyr)

dirty_data <- read.csv("data/dirty_data.csv")
clean_data <- read.csv("data/clean_data.csv")


household_income <- read.csv("data/household_income.csv")
internet_subscription <- read.csv("data/internet_subscription.csv")
nativity <- read.csv("data/nativity.csv")
naturalization <- read.csv("data/naturalization.csv")
presence_computer <- read.csv("data/presence_computer.csv")
transportation <- read.csv("data/transportation.csv")
type_computer <- read.csv("data/type_computer.csv")
age <- read.csv("data/age.csv")
combined_data <- read.csv("data/combined_data.csv")
ratio_data <- read.csv("data/ratio_data.csv")
z_score_data <- read.csv("data/z_score_data.csv")

cor <- combined_data[3:28] %>% 
    cor()




