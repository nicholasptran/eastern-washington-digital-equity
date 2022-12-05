library(tidyverse)

household_income <- read.csv("data/household_income.csv")
internet_subscription <- read.csv("data/internet_subscription.csv")
nativity <- read.csv("data/nativity.csv")
naturalization <- read.csv("data/naturalization.csv")
presence_computer <- read.csv("data/presence_computer.csv")
transportation <- read.csv("data/transportation.csv")
type_computer <- read.csv("data/type_computer.csv")
age <- read.csv("data/age.csv")
county_info <- read.csv("data/county_info.csv")

# join the data
combined_data <- inner_join(household_income, internet_subscription) %>% 
    inner_join(., nativity) %>% 
    inner_join(., naturalization) %>% 
    inner_join(., presence_computer) %>% 
    inner_join(., transportation) %>% 
    inner_join(., type_computer) %>% 
    inner_join(., age)


# reorder everything
combined_data <- combined_data %>% 
    select(
        tract, county, median_income, mean_income, internet_with_subscription,
        dialup, broadband, satellite, other, internet_without_subscription,
        no_internet, total_native, total_foreign_born, not_citizen,
        naturalized_citizen, computer, no_computer, work_from_home,
        desktop_laptop, only_desktop_laptop, with_smartphone, only_smartphone,
        with_tablet, only_tablet, with_other, only_other, X65_older,
        median_age, everything()
    )

write.csv(combined_data, "data/combined_data.csv", row.names= FALSE)
