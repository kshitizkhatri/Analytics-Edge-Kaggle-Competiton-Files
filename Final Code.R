## Loading all the necessary libraries

library (caret)
library (caTools)
library (xgboost)
library (randomForest)
library (e1071)
library (mice)

train <- read.csv("train2016.csv", na.strings = c("", NA))

test <- read.csv("test2016.csv", na.strings = c("", NA))

test$Party <- "Democrat"

test_usr_id <- test$USER_ID
test_idx <- which (total$USER_ID %in% test_usr_id)

total <- rbind (train, test)
View (total)
total$Age <- 2016 - total$YOB
total$YOB <- NULL
total <- total [, c(1,6,108,2:5,7:107)]

total$Age[total$Age < 14] <- 14
total$Age[total$Age > 100] <- 100

total <- complete (mice (total))

total_sparse <- cbind (total[,c(1,2), drop = FALSE], model.matrix(~-1+., total[,-c(1,2)]))

training <- total_sparse[-test_idx,]
testing <- total_sparse[test_idx,]
testing$Party <- NULL

split <- sample.split (training$Party, SplitRatio = 0.7)
training_data <- subset (training, split == TRUE)
test_data <- subset (training, split == FALSE)

testModel <- function(trainedModel, test_data) {
  r = table (test_data$Party, predict (trainedModel, newdata = test_data))
  result_df = as.data.frame(r)
  percent = (result_df[1,3] + result_df[4,3])/nrow(test_data)
  
  return (percent)
}

tr.Control <- trainControl(method = "cv", number = 4, repeats = 4)

## Creating models for predicting party variable with cross validation

trainMultipleModels <- function (f, training_data, test_data){
  partyRFInteraction <- train(form=f, data = training_data, trControl = tr.Control)
  rf_accu = testModel(partyRFInteraction, test_data)
  cat('Random Forest: ', rf_accu, '\n') 
  partySVM1 <- svm(form = f, data = training_data, C = 1, cross = 3)
  svm_accu = testModel(partySVM1, test_data)
  cat('SVM: ', svm_accu, '\n') 
  
  return(c(rf_accu, svm_accu))
}

print('Training with education variables')
f = as.formula(Party ~ Q98869Yes + Q113181Yes + Q109244Yes + Q115611Yes 
               + Income_25_50 + Income_75_100 
               + Income_50_75 + EducationLevelDoctoralDegree + EducationLevelHighSchoolDiploma)

trainMultipleModels (f)

## Preparing files for submission

predPartyRF <- predict (partyRFInteraction, newdata = testing)
predPartySVM <- predict (partySVM1, newdata = testing)

MySubmissionRF = data.frame(USER_ID = testing$USER_ID, Predictions = predPartyRF)
MySubmissionSVM = data.frame(USER_ID = testing$USER_ID, Predictions = predPartySVM)

write.csv(MySubmissionRF, "SubmissionRF.csv", row.names=FALSE)
write.csv(MySubmissionSVM, "SubmissionSVM.csv", row.names=FALSE)


