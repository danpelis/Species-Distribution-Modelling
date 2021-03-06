# Load 'dismo' and 'maptools' packages
library(dismo)
library(maptools)
data(wrld_simpl)

# Gather evironmental data(predictors) from dismo package
predictors <- stack(list.files(file.path(system.file(package="dismo"), 'ex'), pattern='grd$', full.names=TRUE ))
# Load bradypus occurance data from dismo package
file <- file.path(system.file(package="dismo"), "ex/bradypus.csv")
bradypus <- read.table(file,  header=TRUE,  sep=',')
bradypus <- bradypus[,-1]
# Extract presence values from the evironmental dataset using
# the bradypus occurance data
presvals <- extract(predictors, bradypus)
# Randomly choose background points from evironmental dataset
set.seed(0)
backgr <- randomPoints(predictors, 500)
# Extract abesence values from the environmental dataset using
# the chosen background points
absvals <- extract(predictors, backgr)
# Build additional dataset without categorical variables
pred_nf <- dropLayer(predictors, 'biome')

# Randomly split presence and absence datasets into training
# and testing datasets
set.seed(0)
group <- kfold(bradypus, 5)
pres_train <- bradypus[group != 1, ]
pres_test <- bradypus[group == 1, ]

# This limits the area we are looking at in the background dataset
ext <- extent(-90, -32, -33, 23)

set.seed(10)
backg <- randomPoints(pred_nf, n=1000, ext=ext, extf = 1.25)
colnames(backg) = c('lon', 'lat')
group <- kfold(backg, 5)
backg_train <- backg[group != 1, ]
backg_test <- backg[group == 1, ]


# Build datasets with absence and presence data for the 
# Classical regression models and Machine learning methods
train <- rbind(pres_train, backg_train)
pb_train <- c(rep(1, nrow(pres_train)), rep(0, nrow(backg_train)))
envtrain <- extract(predictors, train)
envtrain <- data.frame( cbind(pa=pb_train, envtrain) )
envtrain[,'biome'] = factor(envtrain[,'biome'], levels=1:14)

testpres <- data.frame( extract(predictors, pres_test) )
testbackg <- data.frame( extract(predictors, backg_test) )
testpres[ ,'biome'] = factor(testpres[ ,'biome'], levels=1:14)
testbackg[ ,'biome'] = factor(testbackg[ ,'biome'], levels=1:14)

# Saving data for model evaluation
pb <- c(rep(1, nrow(presvals)), rep(0, nrow(absvals)))
sdmdata <- data.frame(cbind(pb, rbind(presvals, absvals)))
sdmdata[,'biome'] = as.factor(sdmdata[,'biome'])
saveRDS(sdmdata, "sdm.Rds")
saveRDS(presvals, "pvals.Rds")
