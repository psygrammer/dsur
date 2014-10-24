#---------------------------------------------------------------------------------------------------------
#R Code for Chapter 17 of:
#
#Field, A. P., Miles, J. N. V., & Field, Z. C. (2012). Discovering Statistics Using R: and Sex and Drugs and Rock 'N' Roll. #London Sage
#
#(c) 2011 Andy P. Field, Jeremy N. V. Miles & Zoe C. Field
#-----------------------------------------------------------------------------------------------------------




#----Set the working directory------
#setwd("~/Dropbox/Zoe/R Book Chapter 7 Stuff")

#setwd("~/Documents/Academic/Data/DSU_R/Chapter 17 (PCA)")
setwd("~/Documents/Study/DSUR/aall_data_files")

#imageDirectory<-"~/Documents/Academic/Books/Discovering Statistics/DSU R/DSU R I/DSUR I Images"
imageDirectory<-"~/Documents/Study/DSUR/images"


#----Install Packages-----
#install.packages("corpcor")
#install.packages("GPArotation")
#install.packages("psych")
#install.packages("pastecs")



#------And then load these packages, along with the boot package.-----

library(corpcor)
library(GPArotation)
library(psych)


#********************* RAQ Example ********************

#load data
#raq.dat: designed to predict how anxious a given individual would be about learning how to use R (FIGURE 17.6) consists of 23 questionaire from score 1~5
raqData<-read.delim("raq.dat", header = TRUE)

#create a correlation matrix
raqMatrix<-cor(raqData)
round(raqMatrix, 2)
# First, scan the matrix for correlations greater than .3, 
#then look for variables that only have a small number of correlations greater than this value. Then scan the correlation coefficients themselves and look for any greater than .9.
#any are found then you should be aware that a problem could arise because of linearity in the data.

#break down the matrix to make it easier to put in the book
round(raqMatrix[,1:8], 2)
round(raqMatrix[,9:16], 2)
round(raqMatrix[,17:23], 2)

#Bartlett's test to examines whether the population correlation matrix resembles an identity matrix. (17.4.2)
# => every variable correlates very badly with all other variables (all correlation coefficients =~ 0) => independent

cortest.bartlett(raqData)
cortest.bartlett(raqMatrix, n = 2571) #provide the sample size 
#Bartlett's test is highly significant,X2(253) = 19,334,P< .001,and therefore factor analysis is appropriate.

#KMO test


# KMO (Kaiser-Meyer-Olkin) Measure of Sampling Adequacy
# at least >= 0.5 for a satisfactory factor analysis to proceed
# Function by G. Jay Kerns, Ph.D., Youngstown State University (http://tolstoy.newcastle.edu.au/R/e2/help/07/08/22816.html)

kmo = function( data ){
  library(MASS) 
  X <- cor(as.matrix(data)) 
  iX <- ginv(X) 
  S2 <- diag(diag((iX^-1)))
  AIS <- S2%*%iX%*%S2                      # anti-image covariance matrix
  IS <- X+AIS-2*S2                         # image covariance matrix
  Dai <- sqrt(diag(diag(AIS)))
  IR <- ginv(Dai)%*%IS%*%ginv(Dai)         # image correlation matrix
  AIR <- ginv(Dai)%*%AIS%*%ginv(Dai)       # anti-image correlation matrix
  a <- apply((AIR - diag(diag(AIR)))^2, 2, sum)
  AA <- sum(a) 
  b <- apply((X - diag(nrow(X)))^2, 2, sum)
  BB <- sum(b)
  MSA <- b/(b+a)                        # indiv. measures of sampling adequacy
  AIR <- AIR-diag(nrow(AIR))+diag(MSA)  # Examine the anti-image of the correlation matrix. That is the  negative of the partial correlations, partialling out all other variables.
  kmo <- BB/(AA+BB)                     # overall KMO statistic
  # Reporting the conclusion 
   if (kmo >= 0.00 && kmo < 0.50){test <- 'The KMO test yields a degree of common variance unacceptable for FA.'} 
      else if (kmo >= 0.50 && kmo < 0.60){test <- 'The KMO test yields a degree of common variance miserable.'} 
      else if (kmo >= 0.60 && kmo < 0.70){test <- 'The KMO test yields a degree of common variance mediocre.'} 
      else if (kmo >= 0.70 && kmo < 0.80){test <- 'The KMO test yields a degree of common variance middling.' } 
      else if (kmo >= 0.80 && kmo < 0.90){test <- 'The KMO test yields a degree of common variance meritorious.' }
       else { test <- 'The KMO test yields a degree of common variance marvelous.' }

       ans <- list( overall = kmo,
                  report = test,
                  individual = MSA,
                  AIS = AIS,
                  AIR = AIR )
    return(ans)
} 

#To use this function:
kmo(raqData) #DSUR package??

#Determinent (execute one of these):
det(raqMatrix)
det(cor(raqData))
#Determinant : the ‘area’ of the data => determinant (area)=0: lowest correlation; 1: biggest.

#PCA

#General form
#pcModel<-principal(dataframe/R-matrix, nfactors = number of factors, rotate = "method of rotation", scores = TRUE)
#nfactors: how many factors/components you want to extract (see tion 17.3.8) as a number. default: 1
#rotate: a method of factor rotation (see section 17.3.9) using a text string. default: varimax rotation
#scores: obtain factor scores (TRUE) or not (FALSE). default: FALSE.


#On raw data

pc1 <-  principal(raqData, nfactors = 23, rotate = "none") #from the raw data
#pc1 <- principal(raqMatrix, nfactors = 23, rotate = "none") #from the correlation matrix, same as above line
pc1 <-  principal(raqData, nfactors = length(raqData), rotate = "none")
plot(pc1$values, type = "b") #plots the eigenvalues (y) against the factor number (x), b: both a line and points on the same graph

pc1
names(pc1)
pc1$values #eigenvalues – useful for a scree plot
round(pc1$values/length(raqData)*100,2) #explanation %

pc2 <-  principal(raqData, nfactors = 4, rotate = "none") #extract four components if we use Kaiser's criterion (eigenvalues>1)
#pc2 <- principal(raqMatrix, nfactors = 4, rotate = "none")

pc2
plot(pc2$values, type = "b")  #unchanged from the previous factor loading matrix except communalities (=h2 column) and uniquenesses (=u2 column)
#after extraction, some of the factors are discarded and so some information is lost

#Explore residuals
factor.model(pc2$loadings) #reproduce correlations, loadings: factor loading matrix
reproduced<-round(factor.model(pc2$loadings), 3) #format for book
reproduced[,1:9]  #format for book

factor.residuals(raqMatrix, pc2$loadings) #residual: difference between the reproduced and actual correlation matrices
resids<-round(factor.residuals(raqMatrix, pc2$loadings), 3) #format for book
resids[,1:9] #format for book

pc2$fit.off #fit.off: how well are the off diagonal elements reproduced?

residuals<-factor.residuals(raqMatrix, pc2$loadings)
residuals
residuals<-as.matrix(residuals[upper.tri(residuals)]) #upper.tri(): extracting only the elements above the diagonal (so we discard the diagonal elements and the elements below the diagonal)
#as.matrix(): makes sure that the residuals are stored as a matrix
large.resid<-abs(residuals) > 0.05 #how many large residuals there are
sum(large.resid)
sum(large.resid)/nrow(residuals) #If more than 50% > 0.05 for concern. 36% => do not worry
sqrt(mean(residuals^2))
hist(residuals) #approximately normal, no outliers

#Extract the residuals from the matrix entered into the function.
#compute the number and proportion of absolute values > 0.05
#and the root mean squared residual
#and plot a histogram.
residual.stats<-function(matrix){
	residuals<-as.matrix(matrix[upper.tri(matrix)])
	large.resid<-abs(residuals) > 0.05
	numberLargeResids<-sum(large.resid)
	propLargeResid<-numberLargeResids/nrow(residuals)
	rmsr<-sqrt(mean(residuals^2))
	
	cat("Root means squared residual = ", rmsr, "\n")
	cat("Number of absolute residuals > 0.05 = ", numberLargeResids, "\n")
	cat("Proportion of absolute residuals > 0.05 = ", propLargeResid, "\n")
	hist(residuals)
}

#Calculate residual matrix
resids <- factor.residuals(raqMatrix, pc2$loadings )
residual.stats(resids)
#residual.stats(factor.residuals(raqMatrix, pc2$loadings))


#Factor rotation

pc3 <-  principal(raqData, nfactors = 4, rotate = "varimax")
# loadings and eigenvalues (55 loadings) have changed, but the h2 (communality) and (uniqueness) columns have not. 
print.psych(pc3, cut = 0.3, sort = TRUE)
# print.psych: 1)removes loadings that are below a certain value
#              2)reorders the items to try to put them into their factors (using sort option).
# cut = 0.3: use a lower cut-off(0.3) than you are interested(0.4) =>  don’t miss a loading .39
# sort =TRUE: sorting items by the size of their loadings

#Before rotation, most variables loaded highly on the first factor and 
#the remaining factors didn’t really get a look in. 
#After rotation: there are four factors and variables load very highly onto only one factor (with the exception of one question).
#The suppression of loadings less than .3 and ordering variables by loading size also make interpretation considerably easier

pc4 <- principal(raqData, nfactors = 4, rotate = "oblimin")
print.psych(pc4, cut = 0.3, sort = TRUE) 
#final matrix gives us a guide to whether it is reasonable to assume independence between factors.
#we cannot assume independence. => unstrusted orthogonal rotation! more meaningful oblique rotation!

#Pattern matrix contains the factor loadings and is comparable to the factor matrix for orthogonal rotation. more simple!
#Structure matrix considers the relationship between factors (in fact it is a product of the pattern matrix and the matrix containing the correlation coefficients between factors). useful double-check!
# => different in oblique rotation, same in orthogonal rotation

# Calculate structure matrix: multiply the factor loading matrix by the correlation matrix of the factors.
pc4$loadings%*%pc4$Phi

factor.structure <- function(fa, cut = 0.2, decimals = 2){
	structure.matrix <- fa.sort(fa$loadings %*% fa$Phi)
	structure.matrix <- data.frame(ifelse(abs(structure.matrix) < cut, "", round(structure.matrix, decimals)))
	return(structure.matrix)
	}
	
factor.structure(pc4, cut = 0.3) #in DSUR package
#pattern matrix is preferable for interpretative reasons
#because it contains information about the contribution of a variable to a factor.
#conclusion: expect a fairly strong relationship between fear of maths, fear of statistics and fear of computers.

#Factor scores : used to assess the relative fear of one person compared to another. 
pc5 <- principal(raqData, nfactors = 4, rotate = "oblimin", scores = TRUE) #scores = TRUE : calculation for factor score
pc5$scores
head(pc5$scores, 10)
raqData <- cbind(raqData, pc5$scores) #cbind: add the factor scores into our dataframe

#self test

cor(pc5$scores)
round(cor(pc5$scores), 2)

#self test
round(cor(pc5$scores, raqData$Q01),2)
round(cor(pc5$scores, raqData$Q06),2)
round(cor(pc5$scores, raqData$Q18),2)

#On an R matrix

pc1 <- principal(raqMatrix, nfactors = 23, rotate = "none")
pc1 <- principal(raqMatrix, nfactors = length(raqMatrix[,1]), rotate = "none")
pc2 <- principal(raqMatrix, nfactors = 4, rotate = "none") #????: ????ġ ??�� ?ɺ??Դϴ? in:
"pc1 <- principal(raqMatrix, nfactors = length(raqMatrix[,1], rotate = "none")
pc2"
pc3 <- principal(raqMatrix, nfactors = 4, rotate = "varimax")
pc4 <- principal(raqMatrix, nfactors = 4, residuals = TRUE, rotate = "oblimin")
pc5 <- principal(raqMatrix, nfactors = 4, rotate = "oblimin", scores = TRUE)


#Reliability analysis

computerFear<-raqData[,c(6, 7, 10, 13, 14, 15, 18)]
statisticsFear <- raqData[, c(1, 3, 4, 5, 12, 16, 20, 21)]
mathFear <- raqData[, c(8, 11, 17)]
peerEvaluation <- raqData[, c(2, 9, 19, 22, 23)]

# number of item dependant, alpha>0.8=:good reliablity
# raw_alpha: values of the overall 
# G6 if the item is removed 
# Item statistics-r(=item-total correlations): correlations between each item and the total score from the questionnaire.
# Item statistics-r.drop(=item-rest correlation,corrected item-total correlation): correlation of that item with the scale total if that item isn't included in the scale total.
# r.drop <~ .3 => problems and shold be removed! a particular item does not correlate very well with the scale overall.
# final part of table: percentage of people gave each response to each of the items
alpha(computerFear)
alpha(statisticsFear, keys = c(1, -1, 1, 1, 1, 1, 1, 1)) # keys option => variable in the data set is nagative!
alpha(mathFear)
alpha(peerEvaluation)
alpha(statisticsFear) #for illustrative pruposes
#경고메시지:
#In alpha(statisticsFear) :
#  Some items were negatively correlated with total scale and were automatically reversed.

# If the deletion of an item increases Cronbach’s then this means that the deletion of that item improves reliability.
# =>  any items that have values of a in this column greater than the overall a may need to be deleted from the scale to improve its reliability.

#------Labcoat Leni------------------------------


#load data (p797. Internet addiction research)
internetData<-read.delim("Nichols & Nicki (2004).dat", header = TRUE)

#create a correlation matrix
internetMatrix<-cor(internetData)
round(internetMatrix, 2)

#break down the matrix to make it easier to put in the book
round(internetMatrix[,1:12], 2)
round(internetMatrix[,13:24], 2)
round(internetMatrix[,25:36], 2)

#Look at the mean correlation:
#install.packages("pastecs")
library(pastecs)

round(stat.desc(internetMatrix),2)

#break down the descriptives to make it easier to put in the book
round(stat.desc(internetMatrix[,1:12]), 2)
round(stat.desc(internetMatrix[,13:24]), 2)
round(stat.desc(internetMatrix[,25:36]), 2)


#Calculate the mean and variance of the internetData to 2 decimal places:
internetDescriptives<-stat.desc(internetData)
round(internetDescriptives,2)

#break down the descriptives to make it easier to put in the book
round(internetDescriptives[,1:12], 2)
round(internetDescriptives[,13:24], 2)
round(internetDescriptives[,25:36], 2)

#Removing the variables from the dataframe: 
#install.packages("gdata")
library(gdata)

# The authors dropped two items because they had low means and variances, and dropped three others because of relatively low correlations with other items. They performed a principal components analysis on the remaining 31 items.
internetData.2<-remove.vars(internetData, c("ias13", "ias22", "ias32", "ias23", "ias34"))

#Bartlett's test
#Bartlett's test of sphericity tests the hypothesis that your correlation matrix is an identity matrix, which would indicate that your variables are unrelated and therefore unsuitable for structure detection. Small values (less than 0.05) of the significance level indicate that a factor analysis may be useful with your data.
cortest.bartlett(internetData.2)

#KMO test
#The Kaiser-Meyer-Olkin Measure of Sampling Adequacy is a statistic that indicates the proportion of variance in your variables that might be caused by underlying factors. High values (close to 1.0) generally indicate that a factor analysis may be useful with your data. If the value is less than 0.50, the results of the factor analysis probably won't be very useful.
#To use the function (make sure you have executed the function from the book chapter first):
kmo(internetData.2)

#Determinent:shold be < 0.00001 for avoiding multicollinearity
det(cor(internetData.2))

#PCA

#pcModel<-principal(dataframe/R-matrix, nfactors = number of factors, rotate = "method of rotation", scores = TRUE)

#On raw data
pc1 <-  principal(internetData.2, nfactors = 31, rotate = "none")
pc1 <-  principal(internetData.2, nfactors = length(internetData.2), rotate = "none")
plot(pc1$values, type = "b") 

pc2 <-  principal(internetData.2, nfactors = 5, rotate = "none")

print.psych(pc2, cut = 0.3, sort = TRUE)

#----------Smart Alex Task 1-----------------------
#load data (Figure 17.9 The Teaching of Statistics for Scientific Experiments-Revised (TOSSE-R))
#tossData<-read.delim("Tosse-r.dat", header = TRUE)
tossData<-read.delim("tosse.r.dat", header = TRUE)


#create new dataset without missing data 
tossData.2<-na.omit(tossData)

#create a correlation matrix
tossMatrix<-cor(tossData.2)


#Bartlett's test
cortest.bartlett(tossData.2)


#KMO test
#To use the function (make sure you have executed the function from the book chapter first):
kmo(tossData.2)
kmo(tossData.2)$overall

#Determinent:
det(cor(tossData.2))


#PCA

#pcModel<-principal(dataframe/R-matrix, nfactors = number of factors, rotate = "method of rotation", scores = TRUE)

#On raw data
pc1 <-  principal(tossData.2, nfactors = 28, rotate = "none")

#Extract 5 factors:
pc2 <-  principal(tossData.2, nfactors = 5, rotate = "none")

#Scree plot:
plot(pc1$values, type = "b") 

#Oblique rotation on 5 factors:
pc3 <- principal(tossData.2, nfactors = 5, rotate = "oblimin")
print.psych(pc3, cut = 0.3, sort = TRUE)

#Oblique rotation on 3 factors:
pc4 <- principal(tossData.2, nfactors = 3, rotate = "oblimin")
print.psych(pc4, cut = 0.3, sort = TRUE)

#----------Smart Alex Task 2-----------------------
#load data (FIGURE 17.10 Williams’s organizational ability questionnaire)
williamsData<-read.delim("Williams.dat", header = TRUE)

#create new dataset without missing data 
williamsData.1<-na.omit(williamsData)

williamsData.2<-williamsData.1[,1]+williamsData.1[,4:31]

#create a correlation matrix
williamsMatrix<-cor(williamsData.2)

#Bartlett's test
cortest.bartlett(williamsData.2)

#KMO test
#To use the function (make sure you have executed the function from the book chapter first):
kmo(williamsData.2)

#calculate the Determinent:
det(cor(williamsData.2))

#PCA

#pcModel
#On raw data, extract 5 factors, varimax rotation:
pc1 <-  principal(williamsData.2, nfactors = 5, rotate = "varimax")

#Scree plot:
plot(pc1$values, type = "b") 

#Pattern Matrix in a nice format:
print.psych(pc1, cut = 0.3, sort = TRUE)

