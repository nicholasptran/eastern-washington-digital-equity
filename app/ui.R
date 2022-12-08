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
}'),
      "We selected a wide array of possible variables based upon criteria that
      we believe could help explain price, speed, and access, which make up the
      digital equity within eastern Washington. We then gathered tract-level
      data from the 2020 U.S. Census 5-Year Estimates as part of the American
      Community Survey.
      Most of the data that we collected was grouped by household income. Thus,
      when we were in the process of transforming our data, we completely took
      out the columns that were grouped by household income and kept the
      columns that showed only the totals of each variable. This helped in
      comprising our data, as we had hundreds of variables even after we
      completely dropped a few of them due to relevance. We then attempted
      to weigh the variables on the same scale, our first method using
      Z-scores. We took the sum in order to make an index using the Z-score
      method. We then used the ratio method to create a ratio index by taking
      the value of one cell and dividing it by the max value of that column
      (for x in col, x/xmax). By using these methods, we were able to
      standardize our data to give us our index values.
      The method we are choosing to run on our data is Factor Analysis.
      This will allow us to be able to further comprise our data by grouping
      the variables that we have to allow us to test our data so that we are
      able to statistically prove which variables are either not significant
      in explaining digital equity in eastern Washington or are statistically
      significant in explaining digital equity.
",
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
    
    "Z Score",
    tags$pre('
zScore <- function(dataset){
  standardized <- dataset %>% 
  mutate(across(setdiff(names(select(., where(is.numeric))), "tract"), scale))
return(standardized)
}
')
    ),




    # VARIABLES TAB
    tabItem(
      tabName = "variables",
      h1("Variables"),
      br(),
      h3("A look into our data"),
      dataTableOutput("combined_data_table")
    ),

    # ANALYSIS TAB
    tabItem(
      tabName = "analysis",
      h1("Analysis"),
      h2("Ratioed Data"),
      dataTableOutput("ratio_table"),
      h2("Z-Scored Data"),
      dataTableOutput("z_score_table"),
      br(),
      h2("Summarized Statistics and Visualization"),
      "Correlation Matrix",
      plotOutput("corr_plot")
      #
    )
  )
)





ui <- dashboardPage(
  dashboardHeader(title = "Spokane Digital \n Equity Index"),
  sidebar,
  body
)