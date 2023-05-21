library(tidyverse)  # data manipulation and visualization
library(gridExtra)  # plot arrangement

# Step 1: Get the data
data("USArrests")
head(USArrests, 10)

# Step 2: Standardize the data
# compute variance of each variable
apply(USArrests, 2, var)

# standardizing the variables will fix the issue
# create new data frame with centered variables - meaning z scores
scaled_df <- apply(USArrests, 2, scale)
head(scaled_df)

# (13.2 - mean(USArrests$Murder))/sd(USArrests$Murder)

# Step 3: Calculate the Covariance, Calculate eigenvalues & eigenvectors
arrests.cov <- cov(scaled_df)
arrests.cov
arrests.eigen <- eigen(arrests.cov)
str(arrests.eigen)


# Extract the loadings
(phi <- arrests.eigen$vectors[,1:2])

phi <- -phi
row.names(phi) <- c("Murder", "Assault", "UrbanPop", "Rape")
colnames(phi) <- c("PC1", "PC2")
phi


# Calculate Principal Components scores
PC1 <- as.matrix(scaled_df) %*% phi[,1]
PC2 <- as.matrix(scaled_df) %*% phi[,2]

# Create data frame with Principal Components scores
PC <- data.frame(State = row.names(USArrests), PC1, PC2)
head(PC)

# Plot Principal Components for each State
ggplot(PC, aes(PC1, PC2)) + 
  modelr::geom_ref_line(h = 0) +
  modelr::geom_ref_line(v = 0) +
  geom_text(aes(label = State), size = 3) +
  xlab("First Principal Component") + 
  ylab("Second Principal Component") + 
  ggtitle("First Two Principal Components of USArrests Data")

# Step 4: Selcting the number of Principal Components
PVE <- arrests.eigen$values / sum(arrests.eigen$values)
round(PVE, 2)

# PVE (aka scree) plot
PVEplot <- qplot(c(1:4), PVE) + 
  geom_line() + 
  xlab("Principal Component") + 
  ylab("PVE") +
  ggtitle("Scree Plot") +
  ylim(0, 1)

# Cumulative PVE plot
cumPVE <- qplot(c(1:4), cumsum(PVE)) + 
  geom_line() + 
  xlab("Principal Component") + 
  ylab(NULL) + 
  ggtitle("Cumulative Scree Plot") +
  ylim(0,1)

grid.arrange(PVEplot, cumPVE, ncol = 2)


# measure of sampling adequacy
library(psych)
KMO(scaled_df)


# are the data correlated? 
# is the cor matrix helping to explain variation in the data?
cortest.bartlett(cov(scaled_df), 50)

# is the index reliable?
library(ltm)
cronbach.alpha(scaled_df)


# correlation between the Index Scores and the variables
corr.test(scaled_df)$p
cov(scaled_df)

library(Hmisc)
rcorr(as.matrix(USArrests),type="pearson")

#### Using a package
pca_result <- prcomp(USArrests, scale = TRUE)
names(pca_result)

# means
pca_result$center

# standard deviations
pca_result$scale

# loading vectors
pca_result$rotation

pca_result$rotation <- -pca_result$rotation
pca_result$rotation

# principal component scores
pca_result$x <- - pca_result$x
head(pca_result$x)


USArrests[1,]
pca_result$rotation[,1]

