source("modelingMethodsSetup.R")

##########
# Maxent #
##########
# If this is your first time running the code, download the
# required java package for Maxent at the link below
# https://biodiversityinformatics.amnh.org/open_source/maxent/
# Then unzip the files into your \R\win-library\4.0\dismo\java 
# directory
maxent()
xm <- maxent(predictors, pres_train, factors='biome')
plot(xm)

response(xm)

e <- evaluate(pres_test, backg_test, xm, predictors)
e

px <- predict(predictors, xm, ext=ext, progress='')
par(mfrow=c(1,2))
plot(px, main='Maxent, raw values')
plot(wrld_simpl, add=TRUE, border='dark grey')
tr <- threshold(e, 'spec_sens')
plot(px > tr, main='presence/absence')
plot(wrld_simpl, add=TRUE, border='dark grey')
points(pres_train, pch='+')

#################
# Random Forest #
#################
# Uncomment the line below if it is your first time 
# running the code on this machine
#install.packages("randomForest")
library(randomForest)

model <- pa ~ bio1 + bio5 + bio6 + bio7 + bio8 + bio12 + bio16 + bio17
rf1 <- randomForest(model, data=envtrain)

model <- factor(pa) ~ bio1 + bio5 + bio6 + bio7 + bio8 + bio12 + bio16 + bio17
rf2 <- randomForest(model, data=envtrain)
rf3 <- randomForest(envtrain[,1:8], factor(pb_train))
erf <- evaluate(testpres, testbackg, rf1)
erf

pr <- predict(predictors, rf1, ext=ext)
par(mfrow=c(1,2))
plot(pr, main='Random Forest, regression')
plot(wrld_simpl, add=TRUE, border='dark grey')
tr <- threshold(erf, 'spec_sens')
plot(pr > tr, main='presence/absence')
plot(wrld_simpl, add=TRUE, border='dark grey')
points(pres_train, pch='+')
points(backg_train, pch='-', cex=0.25)

###########################
# Support Vector Machines #
###########################
# Uncomment the line below if it is your first time 
# running the code on this machine
#install.packages("kernlab")
library(kernlab)

svm <- ksvm(pa ~ bio1+bio5+bio6+bio7+bio8+bio12+bio16+bio17, data=envtrain)
esv <- evaluate(testpres, testbackg, svm)
esv

ps <- predict(predictors, svm, ext=ext)
par(mfrow=c(1,2))
plot(ps, main='Support Vector Machine')
plot(wrld_simpl, add=TRUE, border='dark grey')
tr <- threshold(esv, 'spec_sens')
plot(ps > tr, main='presence/absence')
plot(wrld_simpl, add=TRUE, border='dark grey')
points(pres_train, pch='+')
points(backg_train, pch='-', cex=0.25)

