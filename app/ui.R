source("server.R")

ui <- dashboardPage(
  dashboardHeader(title = "Spokane Digital Equity Index"),


  # sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Variables",
        tabName = "variables",
        icon = icon("book font")
      )
    )
  ),


  # body
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "home",
        h1("Introduction"),
        br(),
        h2("filler"),
        br(),
        h2("filler")
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