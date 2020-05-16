library(dismo)
# Loading fitted data from modeling setup script
sdmdata <- readRDS("sdm.Rds")
presvals <- readRDS("pvals.Rds")

# Creating presence and background datasets
pres <- sdmdata[sdmdata[,1] == 1, 2:9]
back <- sdmdata[sdmdata[,1] == 0, 2:9]

# Paritioning presence data into 5 groups
# One group will be used for evaluating the model
# While the other four will be for fitting the model
k <- 5
group <- kfold(pres, k)
group[1:10]
unique(group)

# Resulting of the evaluations will be stored
# in 'e'
e <- list()
for (i in 1:k) {
  train <- pres[group != i,]
  test <- pres[group == i,]
  bc <- bioclim(train)
  e[[i]] <- evaluate(p=test, a=back, bc)
}

# From 'e' we can extract the AUC values and
# the “maximum of the sum of the sensitivity 
# and specificity ” threshold (spec_sens)
auc <- sapply(e, function(x){x@auc})
auc
mean(auc)
sapply( e, function(x){ threshold(x)['spec_sens']})

# Removing spatial sorting bias
i <- pwdSample(pres_test, backg_test, pres_train, n=1, tr=0.1)
pres_test_pwd <- pres_test[!is.na(i[,1]), ]
backg_test_pwd <- backg_test[na.omit(as.vector(i)), ]
sb2 <- ssb(pres_test_pwd, backg_test_pwd, pres_train)
sb2[1]/ sb2[2]

bc <- bioclim(predictors, pres_train)
evaluate(bc, p=pres_test, a=backg_test, x=predictors)
evaluate(bc, p=pres_test_pwd, a=backg_test_pwd, x=predictors)

