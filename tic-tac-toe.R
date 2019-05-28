# TIC-TAC-TOE ENDGAME
# All possible board configurations at the end of game

dataset <- read.table("dataset/tic-tac-toe.data", header = F, sep = ",")

names(dataset)[1] <- "top-left-square"
names(dataset)[2] <- "top-middle-square"
names(dataset)[3] <- "top-right-square"
names(dataset)[4] <- "middle-left-square"
names(dataset)[5] <- "middle-middle-square"
names(dataset)[6] <- "middle-right-square"
names(dataset)[7] <- "botton-left-square"
names(dataset)[8] <- "botton-middle-square"
names(dataset)[9] <- "botton-right-square"
names(dataset)[10] <- "class"

counts <- table(dataset$class)
barplot(counts, main="Distribution of target variable",
        xlab="Satisfication",ylab = "Frequency",
        border="orange",col="skyblue",density=100)

write.csv(dataset, file = "tic-tac-toe-endgame.csv", row.names = FALSE)


library(caTools)
set.seed(123)
split = sample.split(dataset$class, SplitRatio = 0.75)
train_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)


library(party)
output.tree <- ctree(class ~ ., data = train_set)
summary(output.tree)

predict_values = predict(output.tree, test_set[-10])

confusion_m = table(test_set$class, predict_values)
print(confusion_m)

accuracy <- sum(diag(confusion_m)) / sum(confusion_m)
print(accuracy)

plot(output.tree)