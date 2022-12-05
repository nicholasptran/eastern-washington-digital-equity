library(dplyr)

zScore <- function(dataset){
  standardized <- dataset %>% 
    mutate(across(setdiff(names(select(., where(is.numeric))), 'tract'), scale))
  return(standardized)
}
