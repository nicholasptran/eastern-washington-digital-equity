library(tidycensus)
library(dplyr)
library(stringr)

census_api_key(Sys.getenv("CENSUS_API_KEY"))

getCensusData <- function(table) {
    # get the census data
    census_data <- get_acs(
        geography = "tract",
        table = table,
        year = 2020,
        state = "WA",
        survey = "acs5",
        cache_table = TRUE
    ) %>%
        separate(NAME, c("tract", "county", "state"), sep = ",") %>%
        select(-state, -GEOID)

    # transform census data
    census_data$county <- str_to_lower(census_data$county)
    census_data$county <- gsub(" county", "", census_data$county)
    census_data$tract <- gsub("Census Tract ", "", census_data$tract)
    census_data$tract <- as.double(census_data$tract)

    # clean variables data
    variable_data <- load_variables(2020, "acs5", cache = TRUE)
    variable_data$concept <- str_to_lower(variable_data$concept)
    variable_data$label <- str_to_lower(variable_data$label)
    variable_data$label <- gsub("!", "_", variable_data$label)
    variable_data$label <- gsub("__", "_", variable_data$label)
    variable_data$label <- gsub(":", "", variable_data$label)
    variable_data$label <- gsub(" ", "_", variable_data$label)
    variable_data$concept <- gsub(" ", "_", variable_data$concept)

    variable_data <- variable_data %>%
        select(-geography) %>%
        rename_all(recode, name = "variable", concept = "dataset")

    # join
    census_data <- merge(census_data, variable_data, by = "variable") %>%
        select(-variable) %>%
        rename_all(recode, label = "variable")

    return(census_data)
}
