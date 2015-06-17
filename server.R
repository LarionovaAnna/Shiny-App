library(shiny)
library(Rcpp)
library(httpuv)
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
Prediction <- predict(fit, test, type = "prob")
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)
write.csv(submit, file = "result.csv", row.names = FALSE)

pred_titanic <- function(class, sex, age, sibsp, parch, fare, embarked ){
    input_data <- list(Pclass = class, Sex = sex, Age = age, SibSp = sibsp, Parch = parch, Fare = fare, Embarked = embarked)
    pred_data <- as.data.frame((input_data), stringsAsFactors=FALSE)
    surv_prob <- as.data.frame(predict(fit, pred_data, type = "prob" ))
    colnames(surv_prob) <- c("Chances to die", "Chances to survive")
    return(surv_prob)
}

shinyServer(
    function(input, output) {
        output$Prediction <- renderTable({pred_titanic(input$Pclass, input$Sex, input$Age, input$SibSp, input$Parch, input$Fare, input$Embarked)})
        output$plot <- reactivePlot(function(){
            fancyRpartPlot(fit)
                }
            )
    }
)
