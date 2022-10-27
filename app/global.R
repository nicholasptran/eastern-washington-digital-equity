source("R/functions/data_tables.R")
source("R/functions/database.R")
source("R/modules/insert_into_variables.R")
source("R/modules/analysis_tab.R")

library(uuid)
library(DBI)
library(dbplyr)
library(shinydashboard)
library(psych)

options(
    DT.extentions = "Scroller",
    DT.options = list(
        server = TRUE,
        scrollY = 300,
        scrollX = TRUE,
        scroller = TRUE,
        pageLength = 15,
        lengthMenu = c(15, 30, 100),
        height = "200px"
    )
)

dirty_data <- read.csv("data/B28004.csv")
household_income_data <- read.csv("data/Household_Income.csv")
ss_income_data <- read.csv("data/Social_Security_Income.csv")
public_assistance_data <- read.csv("data/Public_Assistance.csv")
naturalization_data <- read.csv("data/B05011 PERIOD OF NATURALIZATION.csv")
nativity_data <- read.csv("data/B05012 NATIVITY IN THE UNITED STATES.csv")
transportation_data <- read.csv("data/B08101 MEANS OF TRANSPORTATION TO WORK BY AGE.csv")
poverty_data <- read.csv("data/B17020 POVERTY STATUS IN THE PAST 12 MONTHS BY AGE.csv")
types_computer_data <- read.csv("data/B28001 TYPES OF COMPUTERS IN HOUSEHOLD.csv")
presence_computer_data <- read.csv("data/B28003 PRESENCE OF COMPUTER AND TYPE OF INTERNET SUBSCRIPTION IN HOUSEHOLD.csv")
internet_subscription_data <- read.csv("data/B28003 PRESENCE OF COMPUTER AND TYPE OF INTERNET SUBSCRIPTION IN HOUSEHOLD.csv")
voting_age_data <- read.csv("data/B29002 CITIZEN, VOTING-AGE POPULATION BY EDUCATIONAL ATTAINMENT.csv")
occupation_over_16_data <- read.csv("data/OCCUPATION_BY_SEX_FOR_THE_FULL-TIME_YEAR-ROUND_CIVILIAN_EMPLOYED_POPULATION_16_YEARS_AND_OVER.csv")
type_computer_internet_sub_data <- read.csv("data/TYPES_OF_COMPUTERS_AND_INTERNET_SUBSCRIPTIONS.csv")
type_internet_sub_characteristics <- read.csv("data/TYPES_OF_INTERNET_SUBSCRIPTIONS_BY_SELECTED_CHARACTERISTICS.csv")
# area_data <- tbl(con, "area_data")
# wa_fixed_data <- tbl(con, "wa_fixed_data")
# county_info <- tbl(con, "county_info")

summ_hh <- data.frame(describe(household_income_data))
summ_ss <- data.frame(describe(ss_income_data))
summ_pad <- data.frame(describe(public_assistance_data))
summ_naturalization <- data.frame(describe(naturalization_data))
summ_nativity <- data.frame(describe(nativity_data))
summ_transportation <- data.frame(describe(transportation_data))
summ_poverty <- data.frame(describe(poverty_data))
summ_type_comp <- data.frame(describe(types_computer_data))
summ_presence_comp <- data.frame(describe(presence_computer_data))
summ_internet_sub <- data.frame(describe(internet_subscription_data))
summ_voting_age <- data.frame(describe(voting_age_data))
summ_occupation <- data.frame(describe(occupation_over_16_data))
summ_type_comp_internet <- data.frame(describe(type_computer_internet_sub_data))
summ_type_internet_sub <- data.frame(describe(type_internet_sub_characteristics))