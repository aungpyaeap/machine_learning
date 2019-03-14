library(neuralnet)

data <- read.csv("BreastCancer.csv", header = TRUE)
data <- data[,-1] # Removing the response variable
str(data)

# Min-Max Normalization
data$V2 <- (data$V2 - min(data$V2))/(max(data$V2)-min(data$V2))
data$V3 <- (data$V3 - min(data$V3))/(max(data$V3)-min(data$V3))
data$V4 <- (data$V4 - min(data$V4))/(max(data$V4)-min(data$V4))
data$V5 <- (data$V5 - min(data$V5))/(max(data$V5)-min(data$V5))
data$V6 <- (data$V6 - min(data$V6))/(max(data$V6)-min(data$V6))
data$V7 <- (data$V7 - min(data$V7))/(max(data$V7)-min(data$V7))
data$V8 <- (data$V8 - min(data$V8))/(max(data$V8)-min(data$V8))
data$V9 <- (data$V9 - min(data$V9))/(max(data$V9)-min(data$V9))
data$V10 <- (data$V10 - min(data$V10))/(max(data$V10)-min(data$V10))

# Prediction variable changing values
data$V11 <- factor(data$V11, levels=c(2,4), labels=c(0,1))
str(data)

# Data Partition
set.seed(222)
ind <- sample(2, nrow(data), replace = TRUE, prob = c(0.7, 0.3))
training <- data[ind==1,]
testing <- data[ind==2,]

# Neural Networks
library(neuralnet)
set.seed(333)
# ce - cross entropy
n <- neuralnet(V11~V2+V3+V4+V5+V6+V8+V9+V10,
               data = training,
               hidden = 5,
               err.fct = "ce",
               linear.output = FALSE)
plot(n)

# Prediction
output <- compute(n, training) # Computes the response for the training data
head(output$net.result)
head(training[1,])


# Confusion Matrix & Misclassification Error - training data
output <- compute(n, training)
p1 <- output$net.result
pred1 <- ifelse(p1>0.5, 1, 0)
tab1 <- table(pred1, training$V11)
tab1
1-sum(diag(tab1))/sum(tab1)

# Confusion Matrix & Misclassification Error - testing data
output <- compute(n, testing[,-1])
p2 <- output$net.result
pred2 <- ifelse(p2>0.5, 1, 0)
tab2 <- table(pred2, testing$admit)
tab2
1-sum(diag(tab2))/sum(tab2)