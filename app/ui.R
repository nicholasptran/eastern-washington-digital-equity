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
      "This index was created with the intention to determine areas in
      Spokane which do not have access to affordable high speed internet
      by tract.",
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
      to allow for analysis of the data.",
      br(),
      #
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
      dataTableOutput("variable_table", width = "100%")
    ),

    # ANALYSIS TAB
    tabItem(
      tabName = "analysis",
      h1("Analysis")
    )
  )
)


ui <- dashboardPage(
  dashboardHeader(title = "Spokane Digital Equity Index"),


  # sidebar
  sidebar,
  body
)