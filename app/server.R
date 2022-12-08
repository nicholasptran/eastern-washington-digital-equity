source("global.R")

server <- function(input, output, session) {
  # home page
  output$dirty_table <- renderDataTable(dirty_data)
  output$clean_table <- renderDataTable(clean_data)

  # variable page
  output$combined_data_table <- renderDataTable(combined_data)


  # ANALYSIS PAGE
  output$ratio_table <- renderDataTable(ratio_data)
  output$z_score_table <- renderDataTable(z_score_data)

  output$corr_plot <- renderPlot(corrplot(cor, method = "shade"))
}
