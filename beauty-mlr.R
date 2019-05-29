dataset <- read.csv("dataset/beauty.csv", sep = ";", header = TRUE)

summary(dataset)

# correlation
matrix <- cor(dataset)
library(corrplot)
corrplot(matrix, method="number")

# vif
library(regclass)
VIF(lm(wage ~ ., data = dataset))

# scale
dataset[2:10] <- scale(dataset[2:10])
summary(dataset)

# split
library(caTools)
set.seed(123)
split = sample.split(dataset$wage, SplitRatio = 0.75)
train_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# regression
regressor = lm(formula = wage ~ ., data = train_set)
summary(regressor)

y_pred = predict(regressor, newdata = test_set)
y_pred

plot(test_set$wage, y_pred, col='blue', pch=16, ylab = "predicted wage", xlab = "real wage")
abline(0,1, col = "red")

# Calculate Root Mean Square Error (RMSE)
RMSE = (sum((test_set$wage - y_pred)^2) / nrow(dataset)) ^ 0.5
print(paste0("Root Mean Square Error is ", RMSE))

hist(y_pred, xlim = c(0,15), ylim = c(0,40),
     xlab = "Predicted wage", ylab = "Percentage", main = "Histogram of predicted values",
     col = "skyblue", border = "purple", density = 30)
