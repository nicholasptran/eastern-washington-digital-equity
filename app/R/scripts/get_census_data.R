# load the libraries
library(tidycensus)
library(tidyr)
library(stringr)
library(dplyr)
library(tidyr)


# load your census api key with an environment variable
census_api_key(Sys.getenv("CENSUS_API_KEY"))


# load variable data and transform
variable_data <- load_variables(2020, "acs5", cache = FALSE) %>%
  rename_all(recode,
    name = "variable_key", concept = "dataset",
    label = "variable"
  ) %>%
  mutate(
    dataset = tolower(dataset),
    dataset = gsub(" ", "_", dataset),
    variable = tolower(variable),
    variable = gsub("!!", "_", variable),
    variable = gsub(" ", "_", variable),
    variable = gsub(":", "", variable)
  ) %>%
  select(-geography)

variable_data2 <- load_variables(2020, "acs5/subject", cache = FALSE) %>%
  rename_all(recode,
    name = "variable_key", concept = "dataset",
    label = "variable"
  ) %>%
  mutate(
    dataset = tolower(dataset),
    dataset = gsub(" ", "_", dataset),
    variable = tolower(variable),
    variable = gsub("!!", "_", variable),
    variable = gsub(" ", "_", variable),
    variable = gsub(":", "", variable)
  )

variable_data <- rbind(variable_data, variable_data2)

# list of counties
counties <- c(
  "adams", "asotin", "ferry", "garfield", "lincoln",
  "pend oreille", "spokane", "stevens", "whitman"
)


# load census data and transform
getCensusData <- function(table) {
  census_data <- get_acs(
    geography = "tract",
    table = table,
    year = 2020,
    state = "WA",
    survey = "acs5",
    cache_table = FALSE
  ) %>%
    separate(NAME, c("tract", "county", "state"), sep = ",") %>%
    mutate(
      tract = gsub("Census Tract ", "", tract),
      tract = as.double(tract),
      county = tolower(county),
      county = gsub(" county", "", county),
      county = gsub(" ", "", county)
    ) %>%
    rename_all(recode, variable = "variable_key") %>%
    merge(variable_data, by = "variable_key") %>%
    select(-state, -GEOID, -variable_key, -dataset) %>%
    filter(county %in% counties) %>%
    pivot_wider(
      names_from = variable,
      values_from = c(estimate, moe)
    )

  return(census_data)
}


# load urban data and transform
getUrbanCensusData <- function(table) {
  census_data <- get_acs(
    geography = "urban area",
    table = table,
    year = 2020,
    survey = "acs5",
    cache_table = FALSE
  ) %>%
    filter(str_detect(NAME, "Spokane")) %>%
    rename_all(recode, variable = "variable_key") %>%
    merge(variable_data, by = "variable_key") %>%
    select(-GEOID, -NAME, -variable_key, -dataset) %>% 
    pivot_wider(
      names_from = variable,
      values_from = c(estimate, moe)
    )



  return(census_data)
}

naturalization <- getCensusData("B05011")
naturalization_urban <- getUrbanCensusData("B05011")
write.csv(naturalization, "app/data/naturalization.csv", row.names = FALSE)
write.csv(naturalization_urban, "app/data/naturalization_urban.csv", row.names = FALSE)

nativity <- getCensusData("B05012")
nativity_urban <- getUrbanCensusData("B05012")
write.csv(nativity, "app/data/nativity.csv", row.names = FALSE)
write.csv(nativity_urban, "app/data/nativity_urban.csv", row.names = FALSE)

transportation <- getCensusData("B08101")
transportation_urban <- getUrbanCensusData("B08101")
write.csv(transportation, "app/data/transportation.csv", row.names = FALSE)
write.csv(transportation_urban, "app/data/transportation_urban.csv", row.names = FALSE)

type_computer <- getCensusData("B28001")
type_computer_urban <- getUrbanCensusData("B28001")
write.csv(type_computer, "app/data/type_computer.csv", row.names = FALSE)
write.csv(type_computer_urban, "app/data/type_computer_urban.csv", row.names = FALSE)

presence_computer <- getCensusData("B28003")
presence_computer_urban <- getUrbanCensusData("B28003")
write.csv(presence_computer, "app/data/presence_computer.csv", row.names = FALSE)
write.csv(presence_computer_urban, "app/data/presence_computer_urban.csv", row.names = FALSE)

internet_subscription <- getCensusData("B28011")
internet_subscription_urban <- getUrbanCensusData("B28011")
write.csv(internet_subscription, "app/data/internet_subscription.csv", row.names = FALSE)
write.csv(internet_subscription_urban, "app/data/internet_subscription_urban.csv", row.names = FALSE)

voting_age <- getCensusData("B29002")
voting_age_urban <- getUrbanCensusData("B29002")
write.csv(voting_age, "app/data/voting_age.csv", row.names = FALSE)
write.csv(voting_age_urban, "app/data/voting_age_urban.csv", row.names = FALSE)

household_income <- getCensusData("S1901")
household_income_urban <- getUrbanCensusData("S1901")
write.csv(household_income, "app/data/household_income.csv", row.names = FALSE)
write.csv(household_income_urban, "app/data/household_income_urban.csv", row.names = FALSE)


# combined_data <- rbind(
#   naturalization,
#   nativity,
#   transportation,
#   type_computer,
#   presence_computer,
#   internet_subscription,
#   voting_age,
#   household_income
# )
# write.csv(combined_data, "app/data/combined_data.csv")

# combined_data_urban <- rbind(
#   naturalization_urban,
#   nativity_urban,
#   transportation_urban,
#   type_computer_urban,
#   presence_computer_urban,
#   internet_subscription_urban,
#   voting_age_urban,
#   household_income_urban
# )
# write.csv(combined_data_urban, "app/data/combined_data_urban.csv")

dirty_data <- get_acs(
  geography = "tract",
  table = "B28003",
  year = 2020,
  state = "WA",
  survey = "acs5",
  cache_table = FALSE
)

clean_data <- getCensusData("B28003")
write.csv(clean_data, "app/data/clean_data.csv", row.names = FALSE)
write.csv(dirty_data, "app/data/dirty_data.csv")