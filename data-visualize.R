# data visualization practice

library(dplyr)
iris

library(ggplot2)
ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species)) + geom_point(size=3)

summary(iris)
boxplot(iris[,-5], col='lavender', border='blue', main="Statistical distribution of metric variables")
grid(nx=NA, ny=NULL)

str(iris)

barplot(table(iris$Species), main = "Distribution of non-metric variables",
        xlab = "Species", ylab = "Frequency", 
        border = "orange", col = "blue", density = 20)
