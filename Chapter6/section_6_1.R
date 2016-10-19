###############################################################
# This code covers the code presented in 
# Section 6.1 Linear Regression
###############################################################

###############################################################
# Section 6.1.2
###############################################################

# Example in R

income_input = as.data.frame(  read.csv("d:/bigdata/Chapter6/income.csv")   )
income_input[1:10,]

summary(income_input)

library(lattice)

splom(~income_input[c(2:5)],  groups=NULL, data=income_input, 
      axis.line.tck = 0,
      axis.text.alpha = 0)

results <- lm(Income~Age + Education + Gender, income_input)
summary(results)

results2 <- lm(Income ~ Age + Education, income_input)
summary(results2)

###############################################################
# this code from the text is for illustrative purposes only
# the income_input variable does not contain the U.S. states
results3 <- lm(Income~Age + Education,
               + Alabama,
               + Alaska,
               + Arizona,
               .
               .
               .
               + WestVirginia,
               + Wisconsin,
               income_input)
###############################################################

# compute confidence intevals for the model parameters
confint(results2, level = .95)

# compute a confidence interval on the expected income of a person
Age <- 41
Education <- 12
new_pt <- data.frame(Age, Education)

conf_int_pt <- predict(results2, new_pt, level=.95, interval="confidence")
conf_int_pt 

# compute a prediction interval on the income of the same person
pred_int_pt <- predict(results2, new_pt, level=.95, interval="prediction")
pred_int_pt

###############################################################
# section 6.1.3 Diagnostics 
###############################################################

with(results2, {
  plot(fitted.values, residuals,ylim=c(-40,40) )
  points(c(min(fitted.values),max(fitted.values)), c(0,0), type = "l")})

hist(results2$residuals, main="")

qqnorm(results2$residuals, ylab="Residuals", main="")
qqline(results2$residuals) 


