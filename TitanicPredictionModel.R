library(shiny)
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)

train <- read.csv("C:/Documents and Settings/Администратор/Shiny App/train.csv", stringsAsFactors=FALSE)
test <- read.csv("C:/Documents and Settings/Администратор/Shiny App/test.csv", stringsAsFactors=FALSE)

train$Child <- 0
train$Child[train$Age < 18] <- 1

train$Fare2 <- '30+'
train$Fare2[train$Fare < 30 & train$Fare >= 20] <- '20-30'
train$Fare2[train$Fare < 20 & train$Fare >= 10] <- '10-20'
train$Fare2[train$Fare < 10] <- '<10'

test$Survived <- 0
test$Survived[test$Sex == 'female'] <- 1
test$Survived[test$Sex == 'female' & test$Pclass == 3 & test$Fare >= 20] <- 0

fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=train, method="class")
fancyRpartPlot(fit)
Prediction <- predict(fit, test, type = "class")
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)
write.csv(submit, file = "result.csv", row.names = FALSE)