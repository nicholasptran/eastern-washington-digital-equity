library(readxl)

data <- read_excel("Retention.xlsx")
head(data)

model <- lm(data$YearsPLE ~ ., data)
summary(model)

model_1 <- lm(data$YearsPLE ~ data$`College GPA` + data$Age +
                data$Gender + data$`College Grad` + data$Local)
summary(model_1)

model_2 <- lm(data$YearsPLE ~ data$`College GPA` + data$Age +
                data$`College Grad` + data$Local)
summary(model_2)


model_3 <- lm(data$YearsPLE ~ data$Age + data$`College Grad` + data$Local)
summary(model_3)

model_4 <- lm(data$YearsPLE ~ data$Age + data$Local)
summary(model_4)
