library(dplyr)

zScore <- function(dataset){
  standardized <- dataset %>% 
    transmute_if(is.numeric,~scale(.) %>% as.vector())
  return(standardized)
}
