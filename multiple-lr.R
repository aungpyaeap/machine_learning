# Multiple linear regression

dataset = read.csv('dataset/50_Startups.csv')

# ecnoding categorial data
dataset$State = factor(dataset$State,
                       levels = c('New York','California','Florida'),
                       labels = c(1,2,3))

# split data
library(caTools)
set.seed(123)
split = sample.split(dataset$Profit, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set =  subset(dataset, split == FALSE)

# fit MLR
regressor = lm(formula = Profit ~ R.D.Spend + Administration + Marketing.Spend + State,
               data = training_set)
summary(regressor)

regressor = lm(formula = Profit ~ R.D.Spend + Administration + Marketing.Spend,
               data = training_set)
summary(regressor)

regressor = lm(formula = Profit ~ R.D.Spend + Marketing.Spend,
               data = training_set)
summary(regressor)

regressor = lm(formula = Profit ~ R.D.Spend,
               data = training_set)
summary(regressor)

# predict test set
y_pred = predict(regressor, newdata = test_set)
y_pred

# plot
require(ggplot2)
ggplot(training_set,aes(y=Profit,x=R.D.Spend))+geom_point()+geom_smooth(method="lm")

require(ggiraph)
require(ggiraphExtra)
require(plyr)
ggPredict(regressor,se=T,interactive = F, show.summary = T)

ggplot(training_set,aes(y=Profit,x=R.D.Spend))+geom_point()+stat_smooth(method="lm",se=FALSE)

plot(regressor)


# Residual Standard Error (RSE)
sigma(regressor)/mean(training_set$Profit)


# REF
# http://www.sthda.com/english/articles/40-regression-analysis/168-multiple-linear-regression-in-r/
# https://cran.r-project.org/web/packages/ggiraphExtra/vignettes/ggPredict.html
