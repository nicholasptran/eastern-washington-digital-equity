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
      "Most of the data came from the US Census. The 2020 American
      Community Survey 5 year estimates were the best source of data
      for this case - with it being more reliable than the 1 year
      estimates and only being two years old. The rest of the data
      comes from the FCC.",
      "For the Census data, we had to transpose (flip x and y),
      remove the margin of error to standardize, add it back in,
      removed some irrelevant variables, and put the tracts and
      counties in their own columns to begin analysis.",
      "The FCC data was categorical instead of numerical. Dummy
      variables were created for each code per column(a = 1, b = 2, etc.)
      to allow for analysis of the data. Data provided from the FCC was only
      provided with block codes, so we joined a table with counties, tract
      numbers, and the block codes to group by county.",
      br(),
      br(),

      # show data before/after
      tabBox(
        title = "Original / Cleaned Data",
        id = "og_clean_box", width = "100%",
        tabPanel(
          "Original",
          dataTableOutput("dirty_data_table")
        ),
        tabPanel(
          "Cleaned",
          dataTableOutput("clean_data_table")
        )
      )
    ),

    # VARIABLES TAB
    tabItem(
      tabName = "variables",
      h1("Variables"),
      fluidRow(
        actionButton("add_button", "Add", icon("plus")),
        actionButton("edit_button", "Edit", icon("edit")),
        actionButton("delete_button", "Delete", icon("trash-alt"))
      ),
      br(),
      dataTableOutput("variable_table", width = "100%"),
      br(),
      h1("Datasets"),
      tabBox(
        title = "Datasets",
        id = "dataset_box", width = "100%",
        tabPanel("HH Income", dataTableOutput("hh_income_table")),
        tabPanel("SS Income", dataTableOutput("ss_income_table")),
        tabPanel(
          "Public Assistance",
          dataTableOutput("public_assistance_table")
        ),
        tabPanel("Naturalization", dataTableOutput("naturalization_table")),
        tabPanel("Nativity", dataTableOutput("nativity_table")),
        tabPanel("Transportation", dataTableOutput("transportation_table")),
        tabPanel("Poverty", dataTableOutput("poverty_table")),
        tabPanel("Types Computer", dataTableOutput("types_computer_table")),
        tabPanel(
          "Presence Computer",
          dataTableOutput("presence_computer_table")
        ),
        tabPanel(
          "Internet Subscription",
          dataTableOutput("internet_subscription_table")
        ),
        tabPanel("Voting Age", dataTableOutput("voting_age_table")),
        tabPanel("Occupation", dataTableOutput("occupation_over_16_table")),
        tabPanel(
          "Types Computer/Internet Subscription",
          dataTableOutput("type_computer_internet_sub_table")
        ),
        # tabPanel("Areas", dataTableOutput("area_table")),
        # tabPanel("Broadband", dataTableOutput("wa_fixed_table")),
        # tabPanel("County", dataTableOutput("county_table")),
      )
    ),

    # ANALYSIS TAB
    tabItem(
      tabName = "analysis",
      h1("Analysis"),
      br(),
      h2("Summarized Statistics and Visualization"),
      #

      h3("Household Income"),
      dataTableOutput("sum_hh"),
      plotOutput("hh_plot"),
      #

      h3("Social Security Income"),
      dataTableOutput("sum_ss"),
      #

      h3("Public Assistance Data"),
      dataTableOutput("sum_pad"),
      #

      h3("Naturalization"),
      dataTableOutput("sum_naturalization"),
      #

      h3("Nativity"),
      dataTableOutput("sum_nativity"),
      #

      h3("Transportation"),
      dataTableOutput("sum_transportation"),
      # 

      h3("Poverty"),
      dataTableOutput("sum_poverty"),
      # 

      h3("Types of Computer"),
      dataTableOutput("sum_type_comp"),
      #

      h3("Presence of Computer"),
      dataTableOutput("sum_presence_comp"),
      #

      h3("Internet Subscriptions"),
      dataTableOutput("sum_internet_sub"),
      #

      h3("Voting Age"),
      dataTableOutput("sum_voting_age"),
      #

      h3("Occupation"),
      dataTableOutput("sum_occupation"),
      #

      h3("Types of Computer/Internet"),
      dataTableOutput("sum_type_comp_internet"),
      #

      h3("Types of Internet Subscriptions"),
      dataTableOutput("sum_type_internet_sub")
    )
  )
)


ui <- dashboardPage(
  dashboardHeader(title = "Spokane Digital Equity Index"),
  sidebar,
  body
)