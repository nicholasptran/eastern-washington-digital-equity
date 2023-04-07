library(tidyverse)
library(psych)


data <- read.csv("app/data/combined_data.csv")


# str(data)
standardized_data <- read.csv("app/data/z_score_data.csv")
standardized_data <- standardized_data[3:27]
# names(standardized_data)
cov_data <- cov(standardized_data)

# View(cov_data)

eigen_data <- eigen(cov_data)
# View(eigen_data$vectors)
# eigen_data$values
loadings <- eigen_data$vectors

loadings <- -loadings
View(eigen_data$vectors[, 1:4])
# loadings
# View(loadings)
# nrow(loadings)

pc1 <- as.matrix(standardized_data) %*% loadings[, 1]
pc1
pc_data <- as.matrix(standardized_data) %*% loadings[, 1:4] %>% as.matrix()

pc_limit <- sqrt(1 / ncol(standardized_data))

# View(pc_data)
# view(pc1)

num_pc <- eigen_data$values / sum(eigen_data$values)
round(num_pc, 2)


# insert the pc data into a variable
pc_data <- prcomp(standardized_data, scale = FALSE)


# square the stdev to turn into eigen value
eigen_value <- pc_data$sdev^2
eigen_value

# inverse the vectors
pc_data$rotation <- -pc_data$rotation



# inverse the pc data
# pc_data$x <- -pc_data$x


# vectors
pc_data$rotation[, 1:4]

# pc 1 -4
pc_data$x[, 1:4]



pc_data
