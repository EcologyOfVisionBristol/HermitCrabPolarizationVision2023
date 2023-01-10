
# Statistical Analysis for manuscript "Polarization Vision in Terrestrial Hermit Crabs". 
# Martin J How, Alasdair Robertson, Samuel P Smithers, David Wilby (2023)

#Script last edited January 2023

#For statistical analysis we used mixed effects binary logistic regression, fitted using the lme4 package.
#We used the DHARMa package to run residual diagnostics. The binary response variable was whether the crab 
#responded. Stimulus contrast (i.e., intensity or polarization contrast) and presentation order were 
#included as fixed effects. The latter was included to test for habituation. Crab ID was included as a 
#random effect to control for repeated measures. To test for a significant effect of stimulus contrast and 
#presentation order we used a likelihood ratio test to compare the full model with the same model but with
#the effect of interest removed.

library(lme4) # used for fitting models 
library(DHARMa) # For residual diagnostics. 
#See website for more details about using 'DHARMa' for residual diagnostics:
#https://cran.r-project.org/web/packages/DHARMa/vignettes/DHARMa.html

rm(list=ls(all=TRUE))
#Set working directory
setwd("~/PATH TO WORKING DIRECTORY")

##########################################################
######## Mixed effects binary logistic regression ########
##########################################################

#### Polarization results for Purple hermit Crab (C. brevimanus)  ####
#Load raw data
data<-read.csv("20200218_PurpleHermit_(C.brevimanus)_P_response.csv",header=T)
data <-na.omit(data)#Remove any rows contain NA 
data$Binary_response <-factor(data$Binary_response) #set binary response to a factor
data$Crab_ID<-factor(data$Crab_ID) # Set crab ID to a factor

#Check data format is correct
str(data)

#Fit full mixed effects binary logistic regression model 
m1 <- glmer(Binary_response ~ Contrast + Order + (1|Crab_ID), family="binomial", data=data)

#Plot model residual and check residual diagnostics.
simulationOutput <- simulateResiduals(fittedModel = m1, plot = T)
# Both plots look good and diagnostic tests are all non significant.  

# Test significant of the fixed effects using a likelihood ratio rest to compare the full model 
# with the same model but with the fixed effect of interest removed. 
m2a <- update(m1, ~.-Contrast)
anova(m1, m2a, test = "Chisq") # Chisq(1)= 2.4245, p=0.1195) 
m2b <- update(m1, ~.-Order)
anova(m1, m2b, test = "Chisq") # Chisq(1)= 4.9288, p=0.02641 *) 

# Polarization contrast comes out as nonsignificant, however this does not mean the crab's aren't
# responding to the polarization contrasts, particularly as the result figure shows a clear response. 
# The non significant result may be because the response curve is symmetrical either side of the 
# control so the small sample size could might mean the mode lacks the power to detect the difference
# that is there. To test this we repeat the above analysis but exclude data for either negative or 
# positive contrasts. 
rm(m1,m2a,m2b,simulationOutput)

# Test for control and positive pol contrasts. 
# Subset data to exclude trials that used a negative pol contrast
data_excludeNeg <- subset(data, Contrast >= 0)

# Construct full mixed effects binary logistic regression model 
m1 <- glmer(Binary_response ~ Contrast + Order + (1|Crab_ID), family="binomial", data=data_excludeNeg)

# Plot model residual and check residual diagnostics.
simulationOutput <- simulateResiduals(fittedModel = m1, plot = T)
# Both plots look good and diagnostic tests are all non significant.  

# Test significant of the fixed effects using a likelihood ratio rest to compare the full model 
# with the same model but with the fixed effect of interest removed. 
m2a <- update(m1, ~.-Contrast)
anova(m1, m2a, test = "Chisq") # Chisq(1)= 28.362, p=1.006e-07 ***) 
# Note that here we do not test for an effect of Order because the model does not contain data
# for all of the trials.
rm(data_excludeNeg,m1,m2a,simulationOutput)

# Test for control and negative pol contrasts.
# Subset data to exclude trials that used a negative pol contrast
data_excludePos <- subset(data, Contrast <= 0)

#Construct full mixed effects binary logistic regression model 
m1 <- glmer(Binary_response ~ Contrast + Order + (1|Crab_ID), family="binomial", data=data_excludePos)

#Plot model residual and check residual diagnostics.
simulationOutput <- simulateResiduals(fittedModel = m1, plot = T)
# Both plots look good and diagnostic tests are all non significant.  

# Test significant of the fixed effects using a likelihood ratio rest to compare the full model 
# with the same model but with the fixed effect of interest removed. 
m2a <- update(m1, ~.-Contrast)
anova(m1, m2a, test = "Chisq") # Chisq(1)= 25.399, p=4.662e-07 ***) 
# Note that here we do not test for an effect of Order because the model does not contain data
# for all of the trials.
rm(data,data_excludePos,m1,m2a,simulationOutput)

#### Intensity results for Purple hermit Crab (C. brevimanus) ####
#Load raw data
data<-read.csv("20200221_PurpleHermit_(C.brevimanus)_I_response.csv",header=T)
data <-na.omit(data)#Remove any rows contain NA 
data$Binary_response <-factor(data$Binary_response) #set binary response to a factor
data$Crab_ID<-factor(data$Crab_ID) # Set crab ID to a factor

#Check data format is correct
str(data)

#Fit full mixed effects binary logistic regression model 
m1 <- glmer(Binary_response ~ Contrast + Order + (1|Crab_ID), family="binomial", data=data)

#Plot model residual and check residual diagnostics.
simulationOutput <- simulateResiduals(fittedModel = m1, plot = T)
# Both plots look acceptable and diagnostic tests are all non significant.  

# Test significant of the fixed effects using a likelihood ratio rest to compare the full model 
# with the same model but with the fixed effect of interest removed. 
m2a <- update(m1, ~.-Contrast)
anova(m1, m2a, test = "Chisq") # Chisq(1)= 30.4, p=3.515e-08 ***) 
m2b <- update(m1, ~.-Order)
anova(m1, m2b, test = "Chisq") # Chisq(1)= 1.5961, p=0.2065) 

rm(data,m1,m2a,m2b,simulationOutput)

#### Polarization results for Pale hermit Crab (C. rugosus) ####
#Load raw data
data<-read.csv("20200212_PaleHermit_(C.rugosus)_P_response.csv",header=T)
data <-na.omit(data)#Remove any rows contain NA 
data$Binary_response <-factor(data$Binary_response) #set binary response to a factor
data$Crab_ID<-factor(data$Crab_ID) # Set crab ID to a factor

#Check data format is correct
str(data)

#Fit full mixed effects binary logistic regression model 
m1 <- glmer(Binary_response ~ Contrast + Order + (1|Crab_ID), family="binomial", data=data)

#Plot model residual and check residual diagnostics.
simulationOutput <- simulateResiduals(fittedModel = m1, plot = T)
# Both plots look good and diagnostic tests are all non significant.  

# Test significant of the fixed effects using a likelihood ratio rest to compare the full model 
# with the same model but with the fixed effect of interest removed. 
m2a <- update(m1, ~.-Contrast)
anova(m1, m2a, test = "Chisq") # Chisq(1)= 32.155, p=1.423e-08 ***) 
m2b <- update(m1, ~.-Order)
anova(m1, m2b, test = "Chisq") # Chisq(1)= 25.461, p=4.514e-07 ***) 

rm(data,m1,m2a,m2b,simulationOutput)

#### Intensity results for Pale hermit Crab (C. rugosus) ####
#Load raw data
data<-read.csv("20200216_PaleHermit_(C.rugosus)_I_response.csv",header=T)
data <-na.omit(data)#Remove any rows contain NA 
data$Binary_response <-factor(data$Binary_response) #set binary response to a factor
data$Crab_ID<-factor(data$Crab_ID) # Set crab ID to a factor

#Check data format is correct
str(data)

#Fit full mixed effects binary logistic regression model 
m1 <- glmer(Binary_response ~ Contrast + Order + (1|Crab_ID), family="binomial", data=data)

#Plot model residual and check residual diagnostics.
simulationOutput <- simulateResiduals(fittedModel = m1, plot = T)
# The residuals look irregular..

# We can try adding a quadratic effect. 
m1_QE <- glmer(Binary_response ~ Contrast + Order + I(Contrast^2) + (1|Crab_ID), family="binomial", data=data)
# But when we do this we get a warning message suggesting we rescale some of the predictors. 

# We can address the warning and make it disappear by rescaling Order. 
m1_QE_RS <- glmer(Binary_response ~ Contrast + I(Order/10) + I(Contrast^2) + (1|Crab_ID), family="binomial", data=data)
# Rescaling Order removes the warning. HOWEVER...
anova(m1_QE_RS, m1_QE, test = "Chisq")
# ...comparing the two models shows no difference between them at all. Thus for consistency, we will stick with m1_QE.
# (Note that rescaling order to remove the warning also makes no difference to the final results.) 

#Finally we plot model residual for m1_QE and check residual diagnostics to see if the quadratic effect improves
#the model fit.
simulationOutput <- simulateResiduals(fittedModel = m1_QE, plot = T)
#Adding the quadratic effect seems to have done the trick. The residual vs predicted plot looks much better now. 

#Use a likelihood ratio test to confirm the quadratic effect significantly improves the fit?
anova(m1, m1_QE, test = "Chisq") # Chisq(1)= 131.33, p< 2.2e-16 ***
#It does.

# Test significant of the fixed effects using a likelihood ratio rest to compare the full model 
# with the same model but with the fixed effect of interest removed. 
m2a <- update(m1_QE, ~.-Contrast)
anova(m1_QE, m2a, test = "Chisq") # Chisq(1)= 81.531, p< 2.2e-16 ***
m2b <- update(m1_QE, ~.-Order)
anova(m1_QE, m2b, test = "Chisq") # Chisq(1)= 5.4257 , p=0.01984 *

rm(data,m1,m2a,m2b,simulationOutput,m1_QE,m1_QE_RS)

#### Polarization results for Pagurus ####
#Load raw data
data<-read.csv("Pagurus_P_response.csv",header=T)
data <-na.omit(data)#Remove any rows contain NA 
data$Binary_response <-factor(data$Binary_response) #set binary response to a factor
data$Crab_ID<-factor(data$Crab_ID) # Set crab ID to a factor

#Check data format is correct
str(data)

#Fit full mixed effects binary logistic regression model 
m1 <- glmer(Binary_response ~ Contrast + Order + (1|Crab_ID), family="binomial", data=data)

#Plot model residual and check residual diagnostics.
simulationOutput <- simulateResiduals(fittedModel = m1, plot = T)
# Both plots look good or acceptable and overall diagnostic tests are non significant.  

# Test significant of the fixed effects using a likelihood ratio rest to compare the full model 
# with the same model but with the fixed effect of interest removed. 
m2a <- update(m1, ~.-Contrast)
anova(m1, m2a, test = "Chisq") # Chisq(1)= 12.306, p=0.0004514 ***) 
m2b <- update(m1, ~.-Order)
anova(m1, m2b, test = "Chisq") # Chisq(1)= 0.7876, p=0.3748) 

rm(data,m1,m2a,m2b,simulationOutput)

################# Graphs to check data ############################
#The plots below are solely for the purpose of data visualization and are not the plots generated for the paper. 
library(Hmisc) #For calculating confidence intervals
library(ggplot2)
Graph.theme<-theme_bw()+
  theme(axis.text=element_text(size=12,colour="black"),
        axis.title=element_text(size=15),
        axis.title.y=element_text(vjust=1),axis.title.x=element_text(vjust=-1),
        legend.text=element_text(size=20),
        legend.title=element_text(size=20),
        legend.key.size=unit(1, "cm"),
        legend.background=element_rect(),
        legend.key = element_blank(), #this gets ride of the annoying box around each of
        panel.border = element_rect(colour = "black", size= 1),
        #panel.border=element_blank(), axis.line=element_line(colour = "black", size= 1),
        panel.grid.major=element_blank(),panel.grid.minor=element_blank(),
        panel.spacing = unit(0, "lines")) + #set the size of the space between subplots when using facet_grid()
  theme(strip.background = element_blank(),strip.text.x = element_blank())#This removes the lables that appear above each facet

# Function to check for Pseudoreplication and count the number of responses to each stimulus type.
ResCounter <- function(data){
  Stims <- unique(data["Contrast"])
  XNP1 = matrix(nrow=nrow(Stims), ncol=4)
  for (row in 1:nrow(Stims)){
    mm1<-subset(data, Contrast==Stims[row,"Contrast"])
    Replication_check <-as.data.frame(table((duplicated(mm1$Crab_ID, incomparables = FALSE))))
    XNP1[row,3]<- Replication_check[2,2] #number of pseudoreplicates (NA=good)
    XNP1[row,1]<- sum(mm1$Binary_response) #total number of responses (Notes that response is numeric here and not a factor as it was in the model)
    XNP1[row,2]<- nrow(mm1) #n 
    XNP1[row,4]<- mm1[1,"Contrast"] #Stimulus
  }
  return(XNP1)
}

# Function to calculate response probability and Wilsons CI. 
CalPropWithCI <- function (XNP1){
  E_CI = matrix(nrow=nrow(XNP1), ncol=6)
  E_CI[,1:5] <- binconf(XNP1[,1],XNP1[,2], alpha=0.05,
                         method=c("wilson"),
                         include.x=TRUE, include.n=TRUE, return.df=FALSE)
  E_CI[,6] <- XNP1[,4]
 
  return(E_CI) 
}

#### Polarization results for Purple hermit Crab (C. brevimanus) ###
data<-read.csv("20200218_PurpleHermit_(C.brevimanus)_P_response.csv",header=T)
data <-na.omit(data)#Remove any rows contain NA 

XNP1<- ResCounter(data)
#Pseudoreplication check
XNP1 #Check 3rd column is all 'NA' (i.e. no pseudoreplicates)

DataToPlot <- CalPropWithCI(XNP1)
colnames(DataToPlot) <- c("X","N","PointEst","Lower","Upper","Contrast")
DataToPlot <- data.frame(DataToPlot)
DataToPlot
min(DataToPlot$N)
max(DataToPlot$N)

Fig <-ggplot(DataToPlot, aes(x=Contrast, y=PointEst)) + geom_point(color="black",size=3) +
  geom_errorbar(aes(ymin=Lower, ymax=Upper),width=.05)+ xlab("Stimulus contrast
                                                             ") + 
  scale_y_continuous(breaks= seq(0,1,.1), limits=c(0, 1.05),expand = c(0,0), name="Response probability
                     ") + Graph.theme
Fig

#### Intensity results for Purple hermit Crab (C. brevimanus) ###
data<-read.csv("20200221_PurpleHermit_(C.brevimanus)_I_response.csv",header=T)
data <-na.omit(data)#Remove any rows contain NA 
XNP1<- ResCounter(data)
#Pseudoreplication check
XNP1 #Check 3rd column is all 'NA' (i.e. no pseudoreplicates)
DataToPlot <- CalPropWithCI(XNP1)
colnames(DataToPlot) <- c("X","N","PointEst","Lower","Upper","Contrast")
DataToPlot <- data.frame(DataToPlot)
DataToPlot
min(DataToPlot$N)
max(DataToPlot$N)

Fig <-ggplot(DataToPlot, aes(x=Contrast, y=PointEst)) + geom_point(color="black",size=3) +
  geom_errorbar(aes(ymin=Lower, ymax=Upper),width=.05)+ xlab("Stimulus contrast
                                                             ") + 
  scale_y_continuous(breaks= seq(0,1,.1), limits=c(0, 1.05),expand = c(0,0), name="Response probability
                     ")+ Graph.theme
Fig

#### Polarization results for Pale hermit Crab (C. rugosus) ###
data<-read.csv("20200212_PaleHermit_(C.rugosus)_P_response.csv",header=T)
data <-na.omit(data)#Remove any rows contain NA 
XNP1<- ResCounter(data)
#Pseudoreplication check
XNP1 #Check 3rd column is all 'NA' (i.e. no pseudoreplicates)
DataToPlot <- CalPropWithCI(XNP1)
colnames(DataToPlot) <- c("X","N","PointEst","Lower","Upper","Contrast")
DataToPlot <- data.frame(DataToPlot)
DataToPlot
min(DataToPlot$N)
max(DataToPlot$N)

Fig <-ggplot(DataToPlot, aes(x=Contrast, y=PointEst)) + geom_point(color="black",size=3) +
  geom_errorbar(aes(ymin=Lower, ymax=Upper),width=.05)+ xlab("Stimulus contrast
                                                             ") + 
  scale_y_continuous(breaks= seq(0,1,.1), limits=c(0, 1.05),expand = c(0,0), name="Response probability
                     ") + Graph.theme
Fig

#### Intensity results for Pale hermit Crab (C. rugosus) ###
data<-read.csv("20200216_PaleHermit_(C.rugosus)_I_response.csv",header=T)
data <-na.omit(data)#Remove any rows contain NA 
XNP1<- ResCounter(data)
#Pseudoreplication check
XNP1 #Check 3rd column is all 'NA' (i.e. no pseudoreplicates)
DataToPlot <- CalPropWithCI(XNP1)
colnames(DataToPlot) <- c("X","N","PointEst","Lower","Upper","Contrast")
DataToPlot <- data.frame(DataToPlot)
DataToPlot
min(DataToPlot$N)
max(DataToPlot$N)

Fig <-ggplot(DataToPlot, aes(x=Contrast, y=PointEst)) + geom_point(color="black",size=3) +
  geom_errorbar(aes(ymin=Lower, ymax=Upper),width=.05)+ xlab("Stimulus contrast
                                                             ") + 
  scale_y_continuous(breaks= seq(0,1,.1), limits=c(0, 1.05),expand = c(0,0), name="Response probability
                     ") + Graph.theme
Fig

#### Polarization results for P. bernhardus ###
data<-read.csv("Pagurus_P_response.csv",header=T)
data <-na.omit(data)#Remove any rows contain NA 
XNP1<- ResCounter(data)
#Pseudoreplication check
XNP1 #Check 3rd column is all 'NA' (i.e. no pseudoreplicates)
DataToPlot <- CalPropWithCI(XNP1)
colnames(DataToPlot) <- c("X","N","PointEst","Lower","Upper","Contrast")
DataToPlot <- data.frame(DataToPlot)
DataToPlot
min(DataToPlot$N)
max(DataToPlot$N)

Fig <-ggplot(DataToPlot, aes(x=Contrast, y=PointEst)) + geom_point(color="black",size=3) +
  geom_errorbar(aes(ymin=Lower, ymax=Upper),width=.05)+ xlab("Stimulus contrast
                                                             ") + 
  scale_y_continuous(breaks= seq(0,1,.1), limits=c(0, 1.05),expand = c(0,0), name="Response probability
                     ") + Graph.theme
Fig
