#######################################################
# section 7.1 Decision Trees
#######################################################

install.packages("rpart.plot") # install package rpart.plot

##########################################
# section 7.1.1 Overview of a Decision Tree
##########################################

library("rpart")
library("rpart.plot")

# Read the data
setwd("c:/data/")
banktrain <- read.table("bank-sample.csv",header=TRUE,sep=",")

## drop a few columns to simplify the tree
drops<-c("age", "balance", "day", "campaign", "pdays", "previous", "month")
banktrain <- banktrain [,!(names(banktrain) %in% drops)]
summary(banktrain)

# Make a simple decision tree by only keeping the categorical variables
fit <- rpart(subscribed ~ job + marital + education + default + housing + loan + contact + poutcome, 
             method="class", 
             data=banktrain,
             control=rpart.control(minsplit=1),
             parms=list(split='information'))
summary(fit)
# Plot the tree
rpart.plot(fit, type=4, extra=2, clip.right.labs=FALSE, varlen=0, faclen=3)


##########################################
# section 7.1.2 The General Algorithm
##########################################

# Entropy of coin flips
x <- sort(runif(1000))
y <- data.frame(x=x, y=-x*log2(x)-(1-x)*log2(1-x))
plot(y, type="l", xlab="P(X=1)", ylab=expression("H"["X"]))
grid()

# include a numeric variable "duration" into the model
fit <- rpart(subscribed ~ job + marital + education + default + housing + loan + contact + duration + poutcome, 
             method="class", 
             data=banktrain,
             control=rpart.control(minsplit=1),
             parms=list(split='information'))
summary(fit)
# Plot the tree
rpart.plot(fit, type=4, extra=2, clip.right.labs=FALSE, varlen=0, faclen=3)

# Predict
newdata <- data.frame(job="retired", 
                      marital="married", 
                      education="secondary",
                      default="no",
                      housing="yes",
                      loan="no",
                      contact = "cellular",
                      duration = 598,
                      poutcome="unknown")
newdata
predict(fit,newdata=newdata,type=c("class"))


##########################################
# section 7.1.5 Decision Trees in R
##########################################

library("rpart") # load libraries
library("rpart.plot")

# Read the data
play_decision <- read.table("DTdata.csv", header=TRUE, sep=",")
play_decision
summary(play_decision)

# build the decision tree
fit <- rpart(Play ~ Outlook + Temperature + Humidity + Wind,
             method="class",
             data=play_decision,
             control=rpart.control(minsplit=1),
             parms=list(split='information'))
summary(fit)

?rpart.plot
rpart.plot(fit, type=4, extra=1)
rpart.plot(fit, type=4, extra=1)
rpart.plot(fit, type=4, extra=2, clip.right.labs=FALSE,
           varlen=0, faclen=0)

newdata <- data.frame(Outlook="rainy", Temperature="mild",
                      Humidity="high", Wind=FALSE)
newdata

predict(fit,newdata=newdata,type="prob")
predict(fit,newdata=newdata,type="class")
