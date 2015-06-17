library(shiny)
library(Rcpp)
library(httpuv)
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)

shinyUI(
    pageWithSidebar(
        headerPanel("Survival Prediction on Titanic dataset from Kaggle"),
        sidebarPanel(
            numericInput('Pclass', 'Passenger Class', 1, min = 1, max = 3),
            selectInput('Sex', 'Sex', 
                         choices = list("female" = "female", "male" = "male"),
                         selected = "female"),
            numericInput("Age", "Age", 1, min = 1, max = 99),
            numericInput("SibSp", "Number of Siblings/Spouses Aboard", 0, min = 0, max = 10),
            numericInput("Parch", "Number of Parents/Children Aboard", 0, min = 0, max = 10),
            numericInput("Fare", "Passenger Fare", 1, min = 1, max = 500),
            selectInput('Embarked', 'Port of Embarkation', 
                        choices = list("Cherbourg" = "C", "Queenstown" = "Q", "Southampton" = "S"),
                        selected = "C"),
            submitButton('Submit')
            ),
        mainPanel(
            h3("About"),
            p("To run this app, enter values on the left and press submit button. Prediction is based on decision tree, so one parameters are more important than others. You can see the diagram below."),
            h3("Results"),
            tableOutput("Prediction"),
            plotOutput('plot')
            )
            
            )
        )
    