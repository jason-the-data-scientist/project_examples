#Linear Regression

#Key concepts: The linear regression model, least squares method, assessing the fit of a model, multiple linear regression, inference, categorical variables, modeling nonlinear relationships, model fitting, big data and regression.

#Data
mtcars

#Simple Linear Regression----

#Create a scatterplot of MPG as the dependent variable and weight as the independent variable.
#Create scatterplot
plot(mpg~wt, data=mtcars,
     main = "Scatter Plot of MPG vs Weight", 
     col ="blue", 
     pch=19)

# #ggplot
# ggplot(data=mtcars) +
#   geom_point(aes(x=wt, y=mpg), color = "blue") +
#   labs(title = "Scatter Plot of MPG vs Weight")

#Use the data to develop an estimated regression equation. Use MPG as the dependent variable and weight as the independent variable.
mtcars.out <- lm(mpg~wt, data=mtcars)
#lm() is a linear model function. glm() is another function that does the same thing.
#The variable before the ~ is the response (independent) variable and everything after the ~ is the predictor (dependent) variable(s).

#Look at the output
print(mtcars.out)
#This gives the formula and the coefficients

#Look at the summary of it as well.
summary(mtcars.out)
#This gives more detailed information.

#The model is y_hat = 37.2851 - 5.3445*x, where x=weight

#It is extremely important that you check the assumptions of your model before doing any inference. Though in this class the assumptions will almost always be met, in real life, they often are not. To do this, run the following code:
#First check assumptions before doing inference.
par(mfrow=c(2,2)) #This makes it so that you can see all 4 plots
plot(mtcars.out)
par(mfrow=c(1,1)) #This resets the format for future plots
#A flat horizontal line for the Residuals vs Fitted Plots indicates independence.
#A a straight line for the Normal QQ Plot indicates normality.
#A flat horizontal line for the Scale-Location Plot indicates equal variance
#No points over the red dotted lines indicates no influential points for the Residuals vs Leverage graph.

#The summary has a lot of information that we can look at individually.

#What are the estimates of the regression line?
summary(mtcars.out)$coefficients

#How much variation is explained by x?
summary(mtcars.out)$r.squared

#What is the regression formula?
summary(mtcars.out)$call

#What is the standard deviation?
summary(mtcars.out)$sigma

#Conduct a 95% confidence interval the estimates:
confint(mtcars.out, level=0.95)
#Get the p-values of the estimates
summary(mtcars.out)$coefficients[,4]

#What would you predict the mean mpg to be if the weight is 3.0? 
predict(mtcars.out, newdata=data.frame(wt=3.0))
#You can reuse this code by changing the linear model (mtcars.out), the variable (wt) and the variable value (3.0).

#What would you predict the weight to be if the mpg is 25?
approx(x = mtcars.out$fitted.values, y = mtcars$wt, xout = 25)$y
#A warning message will be outputted in the console because it is an approximation.
#To reuse this code, change the linear model (mtcars.out), the y-variable (mtcars$wt), and the input amount (25).



#Multiple Linear Regression----
#Use the data to develop an estimated regression equation. Use MPG as the dependent variable with weight and horsepower as the independent variable.
mtcars.out2 <- lm(mpg~wt+hp, data=mtcars)
#Use + to add more variables to the model

#Look at the output
print(mtcars.out2)

#Look at the summary of it as well. This has more information.
summary(mtcars.out2)

#The model is y_hat = 37.22727 - 3.87783*x1 -0.03177*x2, where x1=weight and x2=horsepower

#It is extremely important that you check the assumptions of your model before doing any inference. Though in this class the assumptions will almost always be met, in real life, they often are not. To do this, run the following code:
#First check assumptions before doing inference.
par(mfrow=c(2,2))
plot(mtcars.out2)
par(mfrow=c(1,1))
#A flat horizontal line for the Residuals vs Fitted Plots indicates independence.
#A a straight line for the Normal QQ Plot indicates normality.
#A flat horizontal line for the Scale-Location Plot indicates equal variance
#No points over the red dotted lines indicates no influential points for the Residuals vs Leverage graph.

#What are the estimates of the regression line?
summary(mtcars.out2)$coefficients
#How much variation is explained by x?
summary(mtcars.out2)$r.squared

#Conduct a 95% confidence interval the estimates:
confint(mtcars.out, level=0.95)
#Get the p-values of the estimates
summary(mtcars.out2)$coefficients[,4]

#What would you predict the mean mpg to be if the weight is 3.5 and horsepower of 100? 
predict(mtcars.out2, newdata=data.frame(wt=3.5, hp=100))
#List the values and their variables in within the data.frame separated by commas.

#Calculate the predicted price and residual for each automobile in the data
predict(mtcars.out2)
resid(mtcars.out2)

#Sort the data by residuals (smallest to largest)
mtcars$predict <- predict(mtcars.out)
mtcars$resid <- resid(mtcars.out)
#Sort the data
library(dplyr)
mtcars %>% arrange(resid)



#Model Selection----
##Use the data to develop an estimated regression equation. Use MPG as the dependent variable and weight, horsepower, number of cylinders, displacement, rear axle ratio, 1/4 mile time, number of forward gears, and number of carburetors as the independent variables.
mtcars.out3 <- lm(mpg~wt+hp+cyl+disp+drat+qsec+gear+carb, data=mtcars)

#Look at the summary coefficients and then determines which variables are not significant. Then rerun the linear model. Use alpha=0.1

#Option 1
summary(mtcars.out3)
#Variables that have a Pr(>|t|) that are greater than 0.05 are not significant and those that have a Pr(>|t|) less than 0.1 are significant. You can look at the summary to find it
#Fit the model to the significant variables
mtcars.out4 <- lm(mpg~wt, data=mtcars)

#Option 2
#Using Code
#This code can be used again with a few edits. This is more automatic. You are not expect to know this code at all. 
toselect.x <- summary(mtcars.out3)$coeff[,4] < 0.05 #p-value is adjustable, change for data file
# select significant variables
relevant.x <- names(toselect.x)[toselect.x == TRUE] 
# formula with only significant variables
mod1 <- paste("mpg~",paste(relevant.x, collapse="+"),sep = "") #Change to adjust for y-variable "mpg"
mtcars.out4 <- lm(mod1,data=mtcars) #adjust for data name

#Since only weight (wt) is a significant variable in this example, we will only use this variable. This model happens to be the same one as the first one we looked at.



#Regression with Categorical Data----

#Create a linear model to predict mpg from weight, engine shape, and transmission type. For the engine type (am), use 0 = V-shaped, 1 = straight. For the transmission type (vs), use 0 = automatic, 1 = manual.

#If the data are strings, convert them to 0 or 1:
#mtcars$vs[mtcars$vs=="string1"] <- 0
#mtcars$am[mtcars$am=="string2"] <- 1
#mtcars$vs <- as.numeric(mtcars$vs)
#mtcars$am <- as.numeric(mtcars$am)
#To reuse this code change the data (mtcars) and variables (vs and am) to match what you are trying to do. Also, change string1 and string2 to match the strings in your dataset. Note that you can run a regression model without changing the values to 0 or 1, however, it could affect your model if you expect a variable to be a 1 and it R treats it like a 0. If there are more than 2 factors, include the variable without any of the above manipulations.

#Model the data with a regression
mtcars.out5 <- lm(mpg~wt+as.factor(vs)+am, data=mtcars)
#Change vs to a factor so that it is treated as a qualitative variable and not a quantitative one.

#First check assumptions before doing inference.
par(mfrow=c(2,2))
plot(mtcars.out5)
par(mfrow=c(1,1))

#What are the estimates of the regression line?
summary(mtcars.out5)

#What is a 95% CI of the parameters?
confint(mtcars.out5, level=0.95)

#Using the first linear model mtcars.out <- lm(mpg~wt, data=mtcars), plot mpg as a function of weight using vs and am as different colors.
#Create scatter plots that color based on transmission type (vs)
plot(mpg~wt, data=mtcars,
     main = "Scatter Plot of MPG by VS", 
     col = as.factor(mtcars$vs), 
     pch = 19)
#Create scatter plots that color based on engine type (am)
plot(mpg~wt, data=mtcars,
     main = "Scatter Plot of MPG by AM", 
     col = as.factor(mtcars$am), 
     pch = 19)



#Quadratic Regression----
#Create a quadratic regression predicting mpg from weight and weight squared.
#Create a new variable that is a value squared
mtcars$wt_2 <- mtcars$wt^2

#Model the quadratic regression
mtcars.out6 <- lm(mpg~wt+wt_2, data=mtcars)

#First check assumptions before doing inference.
par(mfrow=c(2,2))
plot(mtcars.out)
par(mfrow=c(1,1))

#What are the estimates of the regression line?
summary(mtcars.out5)

#What is a 95% CI of the parameters?
confint(mtcars.out6, level=0.95)

#Check if the quadratic linear model is significantly different than a simple linear model. Use alpha=0.05
anova(mtcars.out6,mtcars.out)
#Since the p-value is less alpha, we conclude that the two models are statistically significant. If both models satisfy the assumptions of a linear model, then we are usually want the model with the larger R-squared, given that it fits the model well.
