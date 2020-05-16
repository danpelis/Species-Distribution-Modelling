# Species-Distribution-Modelling
Building different types of SDMs in R for my Quantitative Biology Project. Code was sourced from the following tutorial **https://rspatial.org/raster/sdm/index.html**. The author's repo can be found here, **https://github.com/rspatial/rspatial-raster-web**.

The included code was written and compiled for my EN 250 final project. It is a modified version of the code from the links to fit my project's needs. It fits data imported from the dismo library and implements various methods to create SDMs. It also includes a script for evaluating a Bioclim SDM. The methods for creating SDMs used include:
  * [Profile methods (Bioclim, Domain, Mahalanobis Distance)](profileMethods.R)
  * [Classic Linear Regression methods (Bionomial GLM, Guassian GLM, Poisson GLM)](classicalRegressionModels.R)
  * [Machine Learning Methods (Maxent, Random Forests, Support Vector Machines)](machineLearningMethods.R)
  
