library(tidyverse)


# str(data)
standardized_data <- read.csv("app/data/z_score_data.csv")
standardized_data <- standardized_data[4:27]
# names(standardized_data)
cov_data <- cov(standardized_data)

# View(cov_data)

eigen_data <- eigen(cov_data)
# View(eigen_data$vectors)
# eigen_data$values
loadings <- eigen_data$vectors

loadings <- -loadings
View(eigen_data$vectors[,1:5])
# loadings
# View(loadings)
# nrow(loadings)

pc1 <- as.matrix(standardized_data) %*% loadings[, 1]

pc_data <- as.matrix(standardized_data) %*% loadings[, 1:5] %>% as.matrix()

pc_limit <- sqrt(1 / ncol(standardized_data))

# View(pc_data)
# view(pc1)

num_pc <- eigen_data$values / sum(eigen_data$values)
round(num_pc, 2)
