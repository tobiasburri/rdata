
data(mtcars)
dotchart(mtcars$mpg, labels=row.names(mtcars),cex=.7, main='Miles per Gallon (MPG) of Car Models', xlab='MPG')
barplot(table(mtcars$cyl), main="Distribution of Car Cylinder Counts", xlab='Number of Cylinders')


income = rlnorm(4000, meanlog=4, sdlog =0.7)
summary(income)
income = income * 1000

hist(income, breaks=500, xlab= "Income", main="Histogram of Income")

plot(density(log10(income), adjust=0.5), main ="Distribution of Income (log10 scale)" )
rug(log10(income))


library("ggplot2")
data(diamonds)
niceDiamonds = diamonds[diamonds$cut == "Premium" | diamonds$cut == "Ideal",]

summary(niceDiamonds$cut)



ggplot(niceDiamonds, aes(x=price, fill=cut)) +
  geom_density(alpha = 0.3, color =NA)

ggplot(niceDiamonds, aes(x=log10(price), fill=cut)) +
  geom_density(alpha = 0.3, color =NA)


################################
# 2 Variables
################################

x = runif(75, 0, 10)
x = sort(x)
y = 200 + x^3 - 10 * x^2 + x + rnorm(75, 0, 20)


lr = lm( y ~ x)
poly = loess(y ~ x)

fit = predict(poly)
plot(x,y)


points(x, lr$coefficients[1] + lr$coefficients[2] *x, type = "l", col = 2 )
points(x, fit, type='l', col=4)


################################
# Box-and-Whiser Plot
################################

library('ggplot2')

ggplot(data = DF, aes(x=as.factor(Zip1)))








