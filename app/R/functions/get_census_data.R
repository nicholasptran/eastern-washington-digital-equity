library(tidycensus)
library(tidyr)
library(stringr)
library(dplyr)

census_api_key(Sys.getenv("CENSUS_API_KEY"))

# load variable data and transform
variable_data <- load_variables(2020, "acs5", cache = TRUE) %>%
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


getCensusData <- function(table) {
    # load census data and transform
    census_data <- get_acs(
        geography = "tract",
        table = table,
        year = 2020,
        state = "WA",
        survey = "acs5",
        cache_table = TRUE
    ) %>%
        separate(NAME, c("tract", "county", "state"), sep = ",") %>%
        mutate(
            tract = gsub("Census Tract ", "", tract),
            tract = as.double(tract),
            county = tolower(county),
            county = gsub(" county", "", county)
        ) %>%
        rename_all(recode, variable = "variable_key") %>%
        merge(variable_data, by = "variable_key") %>%
        select(-state, -GEOID, -variable_key)

    return(census_data)
}

getUrbanCensusData <- function(table) {
    # load urban data and transform
    census_data <- get_acs(
        geography = "urban area",
        table = table,
        year = 2020,
        survey = "acs5",
        cache_table = TRUE
    ) %>%
        filter(str_detect(NAME, "Spokane")) %>%
        rename_all(recode, variable = "variable_key") %>%
        merge(variable_data, by = "variable_key") %>%
        select(-GEOID, -NAME, -variable_key)


    return(census_data)
}