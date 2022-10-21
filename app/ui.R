source("server.R")

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("home")),
    menuItem("Variables",
      tabName = "variables",
      icon = icon("book font")
    )
  )
)


body <- dashboardBody(
  tabItems(
    tabItem(
      tabName = "home",
      h1("Spokane Digital Equity Index"),
      h2("Introduction"),
      "This index will allow you to determine which tracts in Spokane
        have access to affordable internet.",
      br(),
      h2("Objective"),
      "Create an index to determine which tracts in Spokane have access to
        affordable internet.",
      br(),
      h2("Index"),
      "Add the scores",
      "find the average of the variables",
      "z score or standardization",
      "x - x bar / S",
      "normalization",
      "categorical",
      "by tract"
    ),
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
    )
  )
)

ui <- dashboardPage(
  dashboardHeader(title = "Spokane Digital Equity Index"),


  # sidebar
  sidebar,
  body
)

# ui <- fluidPage(
#   title = "Spokane Digital Equity",
#   fluidRow(
#     h1("Spokane Digital Equity")
#   ),

#   br(),
#   fluidRow(
#     actionButton("add_button", "Add", icon("plus")),
#     actionButton("edit_button", "Edit", icon("edit")),
#     actionButton("delete_button", "Delete", icon("trash-alt"))
#   ),
#   br(),
#   dataTableOutput("variable_table", width = "100%")
# )