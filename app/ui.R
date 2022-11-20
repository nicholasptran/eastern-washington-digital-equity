source("server.R")

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("home")),
    menuItem("Variables", tabName = "variables", icon = icon("book font",
      verify_fa = FALSE
    )),
    menuItem("Analysis", tabName = "analysis", icon = icon("bar-chart",
      verify_fa = FALSE
    ))
  )
)


body <- dashboardBody(
  tabItems(
    # HOME TAB
    tabItem(
      tabName = "home",
      h1("Spokane Digital Equity Index"),

      # INTRODUCTION
      h2("Introduction"),
      "This tract-level digital equity index was created to ensure that
      residents of the Greater Spokane area have equitable access to high-speed
      internet by improving the availability of affordable broadband services in
      un-served and underserved tracts. The index consists of tract-level
      indicators meant to measure, provide the aspects of digital equity
      (access, affordability, and meaningful use), and gives an insight
      of areas which will be greatly impacted with targeted funding
      assistance.",
      br(),

      # DATA COLLECTION PROCESS
      h2("Data Collection Process"),
      "The data was collected for the following areas:",
      tags$ul(
        tags$li("Spokane Metropolitan Area"),
        tags$li(
          "Tracts of surrounding counties",
          tags$ul("Adams"),
          tags$ul("Asotin"),
          tags$ul("Ferry"),
          tags$ul("Garfield"),
          tags$ul("Lincoln"),
          tags$ul("Pend Oreille"),
          tags$ul("Spokane"),
          tags$ul("Stevens"),
          tags$ul("Whitman"),
        ),
      ),
      "Most of the data came from the US Census. The 2020 5 Year ACS
      were the best source of data
      for this case - with it being more reliable than the 1 year
      estimates and only being two years old. The rest of the data
      comes from the FCC.",
      "The Census data was not ready to be used. It had to be cleaned.",
      # show data before/after
      tabBox(
        title = "Original / Cleaned Data",
        id = "og_clean_box", width = "100%",
        tabPanel(
          "Original",
          dataTableOutput("dirty_table")
        ),
        tabPanel(
          "Cleaned",
          dataTableOutput("clean_table")
        )
      ),
      br(),
      "The tidycensus library was used to collect census data.",
      tags$pre('
# load the libraries
library(tidycensus)
library(tidyr)
library(stringr)
library(dplyr)


# load your census api key with an environment variable
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
    select(-state, -GEOID, -variable_key) %>%
    filter(county %in% counties)

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
    select(-GEOID, -NAME, -variable_key)


  return(census_data)
}'),
      "Storing the data locally for faster access",
      tags$pre('
naturalization <- getCensusData("B05011")
naturalization_urban <- getUrbanCensusData("B05011")
write.csv(naturalization, "app/data/naturalization.csv")
write.csv(naturalization_urban, "app/data/naturalization_urban.csv")'),
      "The FCC data was categorical instead of numerical. Dummy
      variables were created for each code per column(a = 1, b = 2, etc.)
      to allow for analysis of the data. Data provided from the FCC was only
      provided with block codes, so we joined a table with counties, tract
      numbers, and the block codes to group by county.",
    ),


    # VARIABLES TAB
    tabItem(
      tabName = "variables",
      h1("Variables")
    ),

    # ANALYSIS TAB
    tabItem(
      tabName = "analysis",
      h1("Analysis"),
      br(),
      h2("Summarized Statistics and Visualization")
      #
    )
  )
)





ui <- dashboardPage(
  dashboardHeader(title = "Spokane Digital \n Equity Index"),
  sidebar,
  body
)