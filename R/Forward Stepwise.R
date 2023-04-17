# Packages
library(tidyverse) # data manipulation and visualization
library(leaps) # model selection functions
library(ISLR)

# Load data and remove rows with missing data
(hitters <- na.omit(ISLR::Hitters) %>%
    as_tibble())

# Finding the best variable in each step
best_subset <- regsubsets(Salary ~ ., hitters, nvmax = 19)
summary(best_subset)

# Forward Stepwise Regression Model
forward <- regsubsets(Salary ~ ., hitters, nvmax = 19, method = "forward")
results <- summary(forward)

# Best Model
which.max(results$adjr2)
which.min(results$bic)
which.max(results$rsq)

# Coefficients of the Best Model
coefs <- coef(results, 11)
coefs <- coef(results, 6)
coefs <- coef(results, 19)
coefs[which(coefs < 0.05)]
coef(forward, 11)

model <- lm(hitters$Salary ~ hitters$AtBat + hitters$Hits +
    hitters$HmRun + hitters$RBI + hitters$Walks +
    hitters$CAtBat + hitters$CHits + hitters$CRuns +
    hitters$League + hitters$Division + hitters$Assists)
summary(model)