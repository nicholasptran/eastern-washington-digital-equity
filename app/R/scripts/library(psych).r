library(psych)
library(tidyverse)

data <- read.csv("app/data/pc_index.csv")
data <- data %>% select(index)

cortest.bartlett(cov(data), 178)    

dist_data <- dist(data, method = 'euclidean')

hclust_avg <- hclust(dist_data, method = 'average')


cut_avg <- cutree(hclust_avg, k = 5)


plot(hclust_avg)
rect.hclust(hclust_avg, k = 5, border = 1:30)
abline(h = 5, col = 'red')
head(data)

index <- read.csv('app/data/pc_index.csv')
summary(index)
sd(index$index)
