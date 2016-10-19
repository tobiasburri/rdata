#######################################################
# section 5.5 An Example: Transactions in a Grocery Store
#######################################################

#install.packages('arules') 
#install.packages('arulesViz')
library('arules')
library('arulesViz')


##########################################
# section 5.5.1 The Groceries Dataset
##########################################

data(Groceries)
Groceries
summary(Groceries)
class(Groceries)

# display the first 20 grocery labels
Groceries@itemInfo[1:20,]

# display the 10th to 20th transactions
apply(Groceries@data[,10:20], 2, 
      function(r) paste(Groceries@itemInfo[r,"labels"], collapse=", ")
)


##########################################
# section 5.5.2 Frequent Itemset Generation
##########################################

# frequent 1-itemsets
itemsets <- apriori(Groceries, parameter=list(minlen=1, maxlen=1, support=0.02, target="frequent itemsets"))
summary(itemsets)
inspect(head(sort(itemsets, by = "support"), 10))

# frequent 2-itemsets
itemsets <- apriori(Groceries, parameter=list(minlen=2, maxlen=2, support=0.02, target="frequent itemsets"))
summary(itemsets)
inspect(head(sort(itemsets, by ="support"),10))

# frequent 3-itemsets
itemsets <- apriori(Groceries, parameter=list(minlen=3, maxlen=3, support=0.02, target="frequent itemsets"))
inspect(sort(itemsets, by ="support"))

# frequent 4-itemsets
itemsets <- apriori(Groceries, parameter=list(minlen=4, maxlen=4, support=0.02, target="frequent itemsets"))
inspect(sort(itemsets, by ="support"))

# run Apriori without setting the maxlen parameter
itemsets <- apriori(Groceries, parameter=list(minlen=1, support=0.02,
                                              target="frequent itemsets"))


##########################################
# section 5.5.3 Rule Generation and Visualization
##########################################

rules <- apriori(Groceries, parameter=list(support=0.001,
                                           confidence=0.6, target = "rules"))
summary(rules)

plot(rules)
plot(rules@quality)

# displays rules with top lift scores
inspect(head(sort(rules, by="lift"), 10))

confidentRules <- rules[quality(rules)$confidence > 0.9]
confidentRules

plot(confidentRules, method="matrix", measure=c("lift", "confidence"),
     control=list(reorder=TRUE))

# select the 5 rules with the highest lift
highLiftRules <- head(sort(rules, by="lift"), 5)

plot(highLiftRules, method="graph", control=list(type="items"))

