library(tidycensus)
library(tidyverse)
library(tigris)
library(mapview)
library(sp)
library(rgdal)
options(tigris_use_cache = TRUE)

counties <- c(
  "adams", "asotin", "ferry", "garfield", "lincoln",
  "pend oreille", "spokane", "stevens", "whitman"
)

getCensusData <- function(variable) {
  census_data <- get_acs(
    geography = "tract",
    variable = variable,
    year = 2020,
    state = "WA",
    survey = "acs5",
    geometry = TRUE,
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
    filter(county %in% counties)


  return(census_data)
}


# pick a random census variable
geometry_data <- getCensusData("B05011_001") %>%
    dplyr::select(GEOID, tract, geometry)
geometry_data
