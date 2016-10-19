#######################################################
# section 7.2 Naïve Bayes
#######################################################

# install some packages
install.packages("rpart.plot") 

##########################################
# section 7.2.2 Naïve Bayes Classifier
##########################################

library("rpart")
library("rpart.plot")

## Read the data
setwd("c:/data/")

banktrain <- read.table("bank-sample.csv",header=TRUE,sep=",")

## drop a few columns to simplify the model
drops<-c("balance", "day", "campaign", "pdays", "previous", "month")
banktrain <- banktrain [,!(names(banktrain) %in% drops)]
summary(banktrain)

## testing set
# banktest <- read.table("bank-sample-test.csv",header=TRUE,sep=",")
# banktest <- banktest [,!(names(banktest) %in% drops)]
# summary(banktest)


## manually compute the conditional probabilities

maritalCounts <- table(banktrain[,c("subscribed", "marital")])
maritalCounts <- maritalCounts/rowSums(maritalCounts)
maritalCounts

maritalCounts["yes","divorced"]

jobCounts <- table(banktrain[,c("subscribed", "job")])
jobCounts <- jobCounts/rowSums(jobCounts)
jobCounts

educationCounts <- table(banktrain[,c("subscribed", "education")])
educationCounts <- educationCounts/rowSums(educationCounts)
educationCounts

defaultCounts <- table(banktrain[,c("subscribed", "default")])
defaultCounts <- defaultCounts/rowSums(defaultCounts)
defaultCounts

housingCounts <- table(banktrain[,c("subscribed", "housing")])
housingCounts <- housingCounts/rowSums(housingCounts)
housingCounts

loanCounts <- table(banktrain[,c("subscribed", "loan")])
loanCounts <- loanCounts/rowSums(loanCounts)
loanCounts

contactCounts <- table(banktrain[,c("subscribed", "contact")])
contactCounts <- contactCounts/rowSums(contactCounts)
contactCounts

poutcomeCounts <- table(banktrain[,c("subscribed", "poutcome")])
poutcomeCounts <- poutcomeCounts/rowSums(poutcomeCounts)
poutcomeCounts


##########################################
# section 7.2.5 Naïve Bayes in R
##########################################

install.packages("e1071") # install package e1071
library(e1071) # load the library

sample <- read.table("sample1.csv",header=TRUE,sep=",")
print(sample)

# read the data into a table from the file
sample <- read.table("sample1.csv",header=TRUE,sep=",")
# define the data frames for the NB classifier
traindata <- as.data.frame(sample[1:14,])
testdata <- as.data.frame(sample[15,])
traindata
testdata

tprior <- table(traindata$Enrolls)
tprior
tprior <- tprior/sum(tprior)
tprior

ageCounts <- table(traindata[,c("Enrolls", "Age")])
ageCounts

ageCounts <- ageCounts/rowSums(ageCounts)
ageCounts

incomeCounts <- table(traindata[,c("Enrolls", "Income")])
incomeCounts <- incomeCounts/rowSums(incomeCounts)
incomeCounts

jsCounts <- table(traindata[,c("Enrolls", "JobSatisfaction")])
jsCounts <- jsCounts/rowSums(jsCounts)
jsCounts

desireCounts <- table(traindata[,c("Enrolls", "Desire")])
desireCounts <- desireCounts/rowSums(desireCounts)
desireCounts

prob_yes <-
  ageCounts["Yes",testdata[,c("Age")]]*
  incomeCounts["Yes",testdata[,c("Income")]]*
  jsCounts["Yes",testdata[,c("JobSatisfaction")]]*
  desireCounts["Yes",testdata[,c("Desire")]]*
  tprior["Yes"]

prob_no <-
  ageCounts["No",testdata[,c("Age")]]*
  incomeCounts["No",testdata[,c("Income")]]*
  jsCounts["No",testdata[,c("JobSatisfaction")]]*
  desireCounts["No",testdata[,c("Desire")]]*
  tprior["No"]

prob_yes
prob_no
max(prob_yes,prob_no)

model <- naiveBayes(Enrolls ~ Age+Income+JobSatisfaction+Desire,
                    traindata)

# display model
model

# predict with testdata
results <- predict (model,testdata)
# display results
results

# use the NB classifier with Laplace smoothing
model1 = naiveBayes(Enrolls ~., traindata, laplace=.01)
# display model
model1

# predict with testdata
results1 <- predict (model1,testdata)
# display results
results1

