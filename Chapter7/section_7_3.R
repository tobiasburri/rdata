#######################################################
# section 7.3 Diagnostics of Classifiers
#######################################################

# install some packages
install.packages("ROCR") 

library(ROCR)

## Read the data
setwd("c:/data/")

# training set
banktrain <- read.table("bank-sample.csv",header=TRUE,sep=",")
# drop a few columns
drops <- c("balance", "day", "campaign", "pdays", "previous", "month")
banktrain <- banktrain [,!(names(banktrain) %in% drops)]
# testing set
banktest <- read.table("bank-sample-test.csv",header=TRUE,sep=",")
banktest <- banktest [,!(names(banktest) %in% drops)]
# build the naïve Bayes classifier
nb_model <- naiveBayes(subscribed~.,
                       data=banktrain)
# perform on the testing set
nb_prediction <- predict(nb_model,
                         # remove column "subscribed"
                         banktest[,-ncol(banktest)],
                         type='raw')
score <- nb_prediction[, c("yes")]
actual_class <- banktest$subscribed == 'yes'
pred <- prediction(score, actual_class)
perf <- performance(pred, "tpr", "fpr")

plot(perf, lwd=2, xlab="False Positive Rate (FPR)",
     ylab="True Positive Rate (TPR)")
abline(a=0, b=1, col="gray50", lty=3)

## corresponding AUC score
auc <- performance(pred, "auc")
auc <- unlist(slot(auc, "y.values"))
auc
