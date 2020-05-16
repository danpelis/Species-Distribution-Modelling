#############################
# Generalized Linear Models #
#############################
# Bionmial GLM #
gm1 <- glm(pa ~ bio1 + bio5 + bio6 + bio7 + bio8 + bio12 + bio16 + bio17,
           family = binomial(link = "logit"), data=envtrain)
#summary(gm1)
#coef(gm1)
ge1 <- evaluate(testpres, testbackg, gm1)
ge1


pg1 <- predict(predictors, gm1, ext=ext)
par(mfrow=c(1,2))
plot(pg1, main='GLM/binomial, raw values')
plot(wrld_simpl, add=TRUE, border='dark grey')
tr <- threshold(ge1, 'spec_sens')
plot(pg1 > tr, main='presence/absence')
plot(wrld_simpl, add=TRUE, border='dark grey')
points(pres_train, pch='+')
points(backg_train, pch='-', cex=0.25)


# Gaussian GLM #
gm2 <- glm(pa ~ bio1+bio5 + bio6 + bio7 + bio8 + bio12 + bio16 + bio17,
           family = gaussian(link = "identity"), data=envtrain)
#summary(gm2)
#coef(gm2)

ge2 <- evaluate(testpres, testbackg, gm2)
ge2

pg2 <- predict(predictors, gm2, ext=ext)
par(mfrow=c(1,2))
plot(pg2, main='GLM/gaussian, raw values')
plot(wrld_simpl, add=TRUE, border='dark grey')
tr <- threshold(ge2, 'spec_sens')
plot(pg2 > tr, main='presence/absence')
plot(wrld_simpl, add=TRUE, border='dark grey')
points(pres_train, pch='+')
points(backg_train, pch='-', cex=0.25)


# Poisson GLM #
gm3 <- glm(pa ~ bio1 + bio5 + bio6 + bio7 + bio8 + bio12 + bio16 + bio17,
           family = poisson(link = "log"), data=envtrain)
#summary(gm3)
#coef(gm3)

ge3 <- evaluate(testpres, testbackg, gm3)
ge3

pg3 <- predict(predictors, gm3, ext=ext)
par(mfrow=c(1,2))
plot(pg3, main='GLM/poisson, raw values')
plot(wrld_simpl, add=TRUE, border='dark grey')
tr <- threshold(ge3, 'spec_sens')
plot(pg3 > tr, main='presence/absence')
plot(wrld_simpl, add=TRUE, border='dark grey')
points(pres_train, pch='+')
points(backg_train, pch='-', cex=0.25)

