source("app/R/scripts/get_geometry_data.R")
library(RColorBrewer)
library(leafpop)
library(tidycensus)
library(tidyverse)
library(tigris)
library(mapview)
library(rgdal)

index <- read.csv("app/data/pc_index.csv")
data <- read.csv("app/data/combined_data.csv")
data <- data[1:27] %>% select(-with_other, -only_tablet)

mapviewOptions(viewer.suppress = FALSE)

# merge df
index_plot <- merge(geometry_data, index) %>% select(-X)
index_plot <- merge(index_plot, data)

# counties vector
counties <- c(
    "Adams", "Asotin", "Ferry", "Garfield", "Lincoln",
    "Pend Oreille", "Spokane", "Stevens", "Whitman"
)

# get wa counties
county_map <- counties("wa")


# filter counties
county_map <- county_map %>%
    filter(NAME %in% counties) %>%
    select(NAME, geometry)

# mapview(county_map, burst = TRUE, zcol = 'NAME') +
mapview(index_plot, zcol = 'index')


# mapview(index_plot,
#     zcol = c('tract', 'county'),
#     # col.regions = brewer.pal(9, "Paired"),
#     popup = popupTable(
#         index_plot,
#         zcol = "index"
#     )
# )


# mapview(index_plot, zcol = 'index')

