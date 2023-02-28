# Spokane Digital Equity

## Introduction
This tract-level digital equity index was created to ensure that residents of the Greater Spokane area have equitable access to high-speed internet by improving the availability of affordable broadband services in un-served and underserved tracts. The index consists of tract-level indicators meant to measure, provide the aspects of digital equity (access, affordability, and high-speed), and gives an insight of areas which will be greatly impacted with targeted funding assistance.

Most of the data came from the US Census. The 2021 5 Year ACS were the best source of data for this case - with it being more reliable than the 1 year estimates and only being two years old. We also collected speed data from Ookla and provider data from the FCC.  



## Gathering and Cleaning The Data
We collected tract-level data for these counties:
* Adams
* Asotin
* Ferry
* Garfield
* Lincoln
* Pend Oreille
* Stevens
* Whitman

### Census Data
Load your libraries and Census API key:
```
library(tidycensus)
library(tidyverse)
library(tigris)
library(sf)

census_api_key(Sys.getenv("CENSUS_API_KEY"))
```
[Get Census API key here](https://api.census.gov/data/key_signup.html)  



Load the acs5 and acs5 subject variables into an object:
```
variable_data <- load_variables(2021, "acs5", cache = FALSE) %>%
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

variable_data2 <- load_variables(2021, "acs5/subject", cache = FALSE) %>%
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
```


Select your variables and filter them:
```
variables <- c(
    "B05011_002", "B05011_003", "B05012_002", "B05012_003", "B08101_049", "B28001_003", "B28001_004",
    "B28001_005", "B28001_006", "B28001_007", "B28003_002", "B28003_006", "B28011_002", "B28011_003", "B28011_004",
    "B28011_005", "B28011_006", "B28011_007", "B28011_008", "S0101_C01_030", "S1901_C01_012", "S1901_C01_013"
)

variable_data <- variable_data %>%
    filter(variable_key %in% variables)
```


Define your counties, create a function, and assign the data to objects:
```
counties <- c(
  "adams", "asotin", "ferry", "garfield", "lincoln",
  "pend oreille", "spokane", "stevens", "whitman"
)

getCensusData <- function(table) {
  census_data <- get_acs(
    geography = "tract",
    table = table,
    year = 2020,
    state = "WA",
    survey = "acs5",
    cache_table = FALSE,
    county = counties
    # ,output = "wide"
    # , keep_geo_vars = TRUE
    # , geometry = TRUE
  )
  return(census_data)
}


naturalization <- getCensusData("B05011")
nativity <- getCensusData("B05012")
transportation <- getCensusData("B08101")
type_computer <- getCensusData("B28001")
presence_computer <- getCensusData("B28003")
internet_subscription <- getCensusData("B28011")
age <- getCensusData("S0101")
household_income <- getCensusData("S1901")


census_data <- naturalization %>%
  rbind(., nativity) %>%
  rbind(., transportation) %>%
  rbind(., type_computer) %>%
  rbind(., presence_computer) %>%
  rbind(., internet_subscription) %>%
  rbind(., age) %>%
  rbind(., household_income)
```


Inner join the census_data with variable_data while keeping the GEOID:
```
census_data <- census_data %>% inner_join(variable_data, by = c("variable" = "variable_key"))

census_data <- census_data %>% 
    select(GEOID, estimate, variable = variable.y)
```


Get the GEOID data per tract:
```
tract_data <- tracts(state = "washington", county = counties, progress_bar = FALSE, cb = FALSE)

tract_data <- tract_data %>% 
    select(GEOID, tract = NAME)
```


Inner join census_data and tract_data by GEOID:
```
census_data <- inner_join(census_data, tract_data)
```


Drop the geometry (we'll use it later to plot the map once we finish our final dataset):
```
census_data <- st_drop_geometry(census_data)
```


Change the data from tall to wide:
```
census_data <- census_data %>% 
    pivot_wider(names_from = variable, values_from = estimate) %>% 
    select(-geometry)
```


Rename the columns:
```
census_data <- census_data %>% 
    rename(
        not_citizen = estimate_total_not_a_u.s._citizen,
        naturalized_citizen = estimate_total_naturalized_citizens,
        native_citizen = estimate_total_native,
        foreign_born = 'estimate_total_foreign-born',
        work_from_home = estimate_total_worked_from_home,
        desktop_or_laptop = estimate_total_has_one_or_more_types_of_computing_devices_desktop_or_laptop,
        desktop_or_laptop_only = estimate_total_has_one_or_more_types_of_computing_devices_desktop_or_laptop_desktop_or_laptop_with_no_other_type_of_computing_device,
        smartphone = estimate_total_has_one_or_more_types_of_computing_devices_smartphone,
        smartphone_only = estimate_total_has_one_or_more_types_of_computing_devices_smartphone_smartphone_with_no_other_type_of_computing_device,
        tablet_or_portable = estimate_total_has_one_or_more_types_of_computing_devices_tablet_or_other_portable_wireless_computer,
        has_computer = estimate_total_has_a_computer,
        no_computer = estimate_total_no_computer,
        internet_subscription = estimate_total_with_an_internet_subscription,
        dial_up = 'estimate_total_with_an_internet_subscription_dial-up_alone',
        broadband = 'estimate_total_with_an_internet_subscription_broadband_such_as_cable,_fiber_optic,_or_dsl',
        satellite = estimate_total_with_an_internet_subscription_satellite_internet_service,
        other_internet_service = estimate_total_with_an_internet_subscription_other_service,
        access_with_no_subscription = estimate_total_internet_access_without_a_subscription,
        no_internet_access = estimate_total_no_internet_access,
        sixty_five_and_older = estimate_total_total_population_selected_age_categories_65_years_and_over,                                                           
        median_income = "estimate_households_median_income_(dollars)",                                                                                         
        mean_income = "estimate_households_mean_income_(dollars)"
    )
```


Replace the null value in the median_income column with the mean value:
```
census_data$median_income[is.na(census_data$median_income)] <- mean(census_data$median_income, na.rm=TRUE)
```


### Ookla Speed Data
Load the libraries:
```
library(tidyverse)
library(ooklaOpenDataR)
library(tigris)
library(sf)
```


Define the counties and collect the tract data:
```
counties <- c('Asotin', 'Lincoln', 'Ferry', 'Garfield', 'Pend Oreille', 'Stevens', 'Whitman', 'Spokane',
    'Adams')

wa_tracts <- tigris::tracts(state = "Washington", county = counties) %>% 
    select(state_code = STATEFP, geoid = GEOID, tract = NAME) %>% 
    st_transform(4326)
```


Get the speed test data from Ookla:
```
tiles <- ooklaOpenDataR::get_performance_tiles('fixed', 2022, 4, sf = TRUE)
```

Filter the tiles with tract data (similar to an inner join):
```
tiles <- ooklaOpenDataR:: filter_by_quadkey(tiles, bbox = st_bbox(wa_tracts))
```


Join the datasets by special feature:
```
data <- sf_join(wa_tracts, tiles, left = FALSE)
```


Clean it up a bit:
```
test <- test %>% 
    group_by(geoid, tract) %>% 
    summarise(
        mean_d_mbps = weighted.mean(avg_d_kbps, tests) / 1000,
        mean_u_mbps = weighted.mean(avg_u_kbps, tests) / 1000,
        mean_lat_ms = weighted.mean(avg_lat_ms, tests) / 1000,
        tests = sum(tests)) %>% 
    select(-tests)
```


### FCC Provider Data
Load the libraries and the data (you can use the API if you want):
```
library(tidyverse)
library(tigris)
library(sf)

options(tigris_use_cache = TRUE)
# https://opendata.fcc.gov/Wireline/Fixed-Broadband-Deployment-Data-June-2021-Status-V/jdr4-3q4p
fcc_data <- read.csv('../data/fcc.csv')
```


Define the counties, get the tract data, and block data (the FCC data are by block-level):
```
counties <- c('Asotin', 'Lincoln', 'Ferry', 'Garfield', 'Pend Oreille', 'Stevens', 'Whitman', 'Spokane',
    'Adams')

tract <- tracts(state = "washington", county = counties, progress_bar = FALSE, cb = FALSE)
block <- blocks(state = "washington", county = counties, progress_bar = FALSE)
```


Special features join the datasets:
```
tract <- st_join(tract, block, left = FALSE)
```



## Surrounding Spokane Counties



## sources

[Spokane city, spokane metro, and 9 surrounding counties](https://data.census.gov/cedsci/table?g=0500000US53001,53003,53019,53023,53043,53051,53063,53065,53075_1600000US5367000_310XX00US44060)

[with all of the tracts filtered](https://data.census.gov/cedsci/table?g=0500000US53001%241400000,53003%241400000,53019%241400000,53023%241400000,53043%241400000,53051%241400000,53063%241400000,53065%241400000,53075%241400000_310XX00US44060_400XX00US83764&y=2020&tid=ACSST5Y2020.S0101&moe=false&tp=true)


