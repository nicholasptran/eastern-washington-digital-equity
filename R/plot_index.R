source("R/get_geometry_data.R")
library(RColorBrewer)
library(leafpop)
library(sf)


index <- read.csv("data/final_index_data.csv")
data <- read.csv("data/combined_data.csv")
mapviewOptions(viewer.suppress = FALSE)

# merge df
index_plot <- merge(geometry_data, index)
# index_plot <- merge(index_plot, data)
head(index_plot)
# counties vector
counties <- c(
    "Adams", "Asotin", "Ferry", "Garfield", "Lincoln",
    "Pend Oreille", "Spokane", "Stevens", "Whitman"
)

# get wa counties
county_map <- counties("wa")
county_map

# filter counties
county_map <- county_map %>%
    filter(NAME %in% counties) %>%
    dplyr::select(NAME, geometry)
county_map

save <- mapview(index_plot, zcol = "index", col.regions = brewer.pal(11, "RdYlGn"))


# https://www.datanovia.com/en/blog/the-a-z-of-rcolorbrewer-palette/
mapview(index_plot, zcol = 'index', col.regions = brewer.pal(11, "RdYlGn"))

mapshot(save, url = "map.html")
