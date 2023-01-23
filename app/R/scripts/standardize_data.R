setwd("app")
source("R/scripts/merge_data.R")


# z score
# function to z score
zScore <- function(dataset){
  standardized <- dataset %>% 
    mutate(across(setdiff(names(select(., where(is.numeric))), 'tract'), scale))
  return(standardized)
}

# index col
z_score_data <- zScore(combined_data) %>%
    rowwise() %>%
    mutate(index = sum(.[3:28], na.rm = TRUE))

write.csv(z_score_data, "data/z_score_data.csv", row.names = FALSE)


# ratio
# init var
ratio_data <- combined_data

# x/max(x) each value for col in df
for (x in 3:ncol(ratio_data)){
    ratio_data[, x] <- ratio_data[, x] / max(ratio_data[, x])
}

# index col
ratio_data  <- ratio_data %>%
    rowwise() %>%
    mutate(index = sum(.[3:28], na.rm = TRUE))

write.csv(ratio_data, "data/ratio_data.csv", row.names = FALSE)
