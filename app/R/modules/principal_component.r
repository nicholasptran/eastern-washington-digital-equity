library(tidyverse)

data <- read.csv("app/data/combined_data.csv")

standardized_data <- read.csv("app/data/z_score_data.csv")
standardized_data <- standardized_data[4:27]
names(standardized_data)
cov_data <- cov(standardized_data)

View(cov_data)

eigen_data <- eigen(cov_data)

names(eigen_data)
loadings <- eigen_data$vectors

loadings <- -loadings

loadings
View(loadings)
nrow(loadings)

pc1 <- as.matrix(standardized_data) %*% loadings[,1:24]

pc_data <- as.matrix(standardized_data) %*% loadings[,1:24] %>% as.matrix

pc_limit <- sqrt(1/ncol(standardized_data))

View(pc_data)
view(pc1)
