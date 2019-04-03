# Support Vector Machine (SVM)

# Import dataset
sales <- read.csv("https://raw.githubusercontent.com/aungpyaeap/datasets/master/aungpyae_salesdata.csv", sep = ",",header = T)
sales[,1] = NULL

# Encoding the target feature as factor
sales$Y <- as.integer(sales$Y)
sales$Y[sales$Y<=5] = 0
sales$Y[sales$Y>5] = 1
sales$Y <- factor(sales$Y, levels=c(0,1), labels = c(0,1))

# removing null
na.omit(sales)

# Split dataset
library(caTools)
set.seed(123)
split <- sample.split(sales$Y, SplitRatio = 0.70)
training_set <- subset(sales, split == TRUE)
test_set <- subset(sales, split == FALSE)

# Feature sacling
training_set[-21] = scale(training_set[-21])
test_set[-21] = scale(test_set[-21])

# x contains the all features and y only the target class
x <- subset(test_set, select=-Y)
y <- test_set$Y


# Fitting classifier to the training set
library(e1071)
classifier = svm(formula = Y ~ .,
                 data = training_set,
                 type = 'C-classification',
                 kernel = 'linear')
summary(classifier)
plot(classifier, training_set, svSymbol = 1, dataSymbol = 2, symbolPalette = rainbow(4),
     color.palette = terrain.colors, X1~X20)

# Prediction
pred <- predict(classifier,x)
system.time(pred <- predict(classifier,x))

# Confusion matrix
table(pred,y)

# accuracy
accuracy <- sum(diag(table(pred,y))) / sum(table(pred,y))
accuracy


# Tuning SVM to find the best cost and gamma
svm_tune <- tune(svm, train.x=x, train.y=y, 
                 kernel="radial", ranges=list(cost=10^(-1:2), gamma=c(.5,1,2)))
print(svm_tune)

# New SVM model
library(e1071)
svm_model_after_tune <- svm(formula = Y ~ .,
                            data = training_set,
                            type = 'C-classification',
                            kernel = 'linear',
                            cost=0.1, gamma=0.5)
summary(svm_model_after_tune)
plot(svm_model_after_tune, training_set, svSymbol = 1, dataSymbol = 2, symbolPalette = rainbow(4),
     color.palette = terrain.colors, X1~X20)

# Prediction again with new model
pred <- predict(svm_model_after_tune,x)
system.time(predict(svm_model_after_tune,x))

# confusion matrix result of prediction
table(pred,y)

# new accuracy
new_accuracy <- sum(diag(table(pred,y))) / sum(table(pred,y))
new_accuracy

# AUC - test set
target = as.numeric(test_set$Y)
x.svm = as.numeric(predict(svm_model_after_tune, newdata=test_set[,-21]))
prediction = prediction(x.svm, target)
auc = as.numeric(performance(prediction, "auc")@y.values)
auc = round(auc,3)
auc*100


# Ref
# https://www.datacamp.com/community/tutorials/support-vector-machines-r
# https://rischanlab.github.io/SVM.html
