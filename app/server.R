source("global.R")

server <- function(input, output, session) {
  # home page
  output$dirty_table <- renderDataTable(dirty_data)
  output$clean_table <- renderDataTable(clean_data)


  # ANALYSIS PAGE

}
