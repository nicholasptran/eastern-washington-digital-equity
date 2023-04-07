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
    cache_table = FALSE,
    county = counties
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
    pivot_wider(
      names_from = variable,
      values_from = c(estimate, moe)
    )

  return(census_data)
}

naturalization <- getCensusData("B05011")
# write.csv(naturalization, "app/data/naturalization.csv", row.names = FALSE)

nativity <- getCensusData("B05012")
# write.csv(nativity, "app/data/nativity.csv", row.names = FALSE)

transportation <- getCensusData("B08101")
# write.csv(transportation, "app/data/transportation.csv", row.names = FALSE)

type_computer <- getCensusData("B28001")
# write.csv(type_computer, "app/data/type_computer.csv", row.names = FALSE)

presence_computer <- getCensusData("B28003")
# write.csv(presence_computer, "app/data/presence_computer.csv", row.names = FALSE)

internet_subscription <- getCensusData("B28011")
# write.csv(internet_subscription, "app/data/internet_subscription.csv", row.names = FALSE)

age <- getCensusData("S0101")
# write.csv(age, "app/data/age.csv", row.names = FALSE)

# household_income <- getCensusData("S1901")
# write.csv(household_income, "app/data/household_income.csv", row.names = FALSE)


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