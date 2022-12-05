setwd("app")
source("R/scripts/merge_data.R")
source("R/functions/standardize.R")

z_score_data <- zScore(combined_data) %>%
    rowwise() %>%
    mutate(index = sum(median_income, mean_income, internet_with_subscription,
        dialup, broadband, satellite, other, internet_without_subscription,
        no_internet, total_native, total_foreign_born, not_citizen,
        naturalized_citizen, computer, no_computer, work_from_home,
        desktop_laptop, only_desktop_laptop, with_smartphone, only_smartphone,
        with_tablet, only_tablet, with_other, only_other, X65_older,
        median_age, na.rm = TRUE))

z_score_data
# write.csv(z_score_data, "data/z_score_data.csv", row.names = FALSE)

ratio_data <- combined_data

for (x in 3:ncol(ratio_data)){
    ratio_data[, x] <- ratio_data[, x] / max(ratio_data[, x])
}

ratio_data  <- ratio_data %>%
    rowwise() %>%
    mutate(index = sum(median_income, mean_income, internet_with_subscription,
        dialup, broadband, satellite, other, internet_without_subscription,
        no_internet, total_native, total_foreign_born, not_citizen,
        naturalized_citizen, computer, no_computer, work_from_home,
        desktop_laptop, only_desktop_laptop, with_smartphone, only_smartphone,
        with_tablet, only_tablet, with_other, only_other, X65_older,
        median_age, na.rm = TRUE))

# write.csv(ratio_data, "data/ratio_data.csv", row.names = FALSE)
