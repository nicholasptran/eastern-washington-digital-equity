library(tidyverse)
data <- read.csv("data/data.csv")
## summary measures of household income less than $20,000 w/ broadband internet sub
summary(data$`            With a broadband Internet subscription...5`) 

data %>% ggplot(aes(data$`            With a broadband Internet subscription...5`)) +
  geom_histogram(bins = 5)

### summary measures of income less than $20,000 w/ no broadband internet sub
summary(data$`            Without an Internet subscription...6`)

data %>% ggplot(aes(data$`            Without an Internet subscription...6`)) +
  geom_histogram(bins = 5)

### summary measures of income $20,000 - $74,999 w/ broadband internet sub
summary(data$`            With a broadband Internet subscription...8`)

data %>% ggplot(aes(data$`            With a broadband Internet subscription...8`)) +
  geom_histogram(bins = 5)

### summary measures of income $20,000-$74,999 W/ no broadband internet sub
summary(data$`            Without an Internet subscription...9`)

data %>% ggplot(aes(data$`            Without an Internet subscription...9`)) +
  geom_histogram(bins = 5)

### summary measures of household pop 25yrs+ w/ less than highschool graduate or equivalent
summary(data$`            Less than high school graduate or equivalency`)

data %>% ggplot(aes(data$`            Less than high school graduate or equivalency`)) +
  geom_histogram(bins = 5)
### summary measures of household pop 25yrs+ w/ bachelors+
summary(data$`            Bachelor's degree or higher`)

data %>% ggplot(aes(data$`            Bachelor's degree or higher`)) +
  geom_histogram(bins = 5)

  

### summary measures of 16yrs+ old that are employed#####
summary(data$`                Employed`)

data %>% ggplot(aes(data$`                Employed`)) +
  geom_histogram(bins = 5)

### summary measures of 16yrs+ old that are unemployed
summary(data$`                Unemployed`)

data %>% ggplot(aes(data$`                Unemployed`)) +
  geom_histogram(bins = 5)

### summary measures of pop 3yrs+ old enrolled in school;HighSchool 9-12 grade
summary(data$`        High school: grade 9 to grade 12`)

data %>% ggplot(aes(data$`        High school: grade 9 to grade 12`)) +
  geom_histogram(bins = 5)

  

