# Adapting the Intensity Gradient for Use with Count-Based Accelerometry Data in Children and Adolescents
# Intensity gradient analysis
# Christina Alexander
# MyMSK - Faculty of Kinesiology, University of Calgary
# June 28, 2023 - revised Dec 6, 2024
# remove objects 
rm(list = ls())
# load libraries
library(ggplot2)
library(dplyr)
# set path name for working directory as the folder where your acceleration data is stored
setwd("")
# load data frame with acceleration data (counts and accelerations)
data <- read.csv("NAMEOFFILE.csv")
# create and open pdf to export the BA plot
pdf(file = "NAMEOFPDF.pdf")
# create data frame to store intensity gradient 
accIG <- data.frame(ID = c(unique(data$ID)))
## INTENSITY GRADIENT FOR COUNTS ##
# number of bins used taken from Rowlands et al: Beyond Cut Points: Accelerometer Metrics that Capture the Physical Activity Profile 
# set incrementing variable
i = 1
# create an IG for each participant by looping once per participant 
for(x in unique(data$ID)){
  
  # create data frame with data from one participant
  pData <- subset(data, data$ID == x)
  
  # create bins
  breaks <- seq(0, 4000, by = 25)
  
  # tag counts into the above specified bins
  tags <- cut(pData$acc, breaks = breaks, include.lowest = TRUE, right = FALSE, labels = c(1:160))
  
  # create data frame with counts and the tag 
  taggedData <- data.frame(pData, tags)
  
  # counts number of data points with each tag
  freqTag <- taggedData %>% count(tags, name = "freq")
  # omit na values
  freqTag <- na.omit(freqTag)
  
  # create data frame
  # create column in data frame with midpoints of all the bins
  midpoints <- data.frame(tags = c(1:160), midpoint = seq(12.5, 3987.5, by = 25))
  
  # merge midpoints and freqTag based on matching value in "tags" column of both
  bData <- merge(freqTag, midpoints, by.x = "tags", by.y = "tags")
  # order data based on tags column 
  binDataX <- bData[order(bData$tags),]
  
  # create column with log of counts 
  binDataX$lFreq <- log(binDataX$freq)
  
  # create column with log of midpoints
  binDataX$lMid <- log(binDataX$midpoint)
  
  # convert to long format
  #binDataL <- gather(binDataX, key = "acc", value = "counts", 2)
  
  # graph the intensity gradient
  IG <- ggplot(binDataX, aes(x = lMid, y = lFreq)) +
    geom_point() +
    geom_smooth(method = "lm", se = FALSE, color = "black") +
    labs(x = "Intensity (ln)", y = "Time Accumulated (ln)") +
    ggtitle(paste("Original Count IG - ", x)) +
    theme_bw() +
    xlim(0, 8) +
    ylim(0, 10) +
    theme_light() +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
  plot(IG)
  
  # perform linear regression on time accumulated and intensity 
  lm <- lm(lFreq ~ lMid, binDataX)
  
  # add IG value to a vector
  accIG$cIG[i] <- lm$coefficients[2]
  # add intercept value to data frame
  accIG$cIntercept[i] <- lm$coefficients[1]
  # add R^2 value to data frame
  accIG$cR2[i] <- summary(lm)$r.squared
  
  # increment i 
  i = i + 1
  
}
## INTENSITY GRADIENT FOR COUNTS - ADJUSTED BINS ##
# number of bins adjusted to match number of points on the count IG graph to the number that appear on the acc IG graph
# set incrementing variable
i = 1
# create an IG for each participant by looping once per participant 
for(x in unique(data$ID)){
  
  # create data frame with data from one participant
  pData <- subset(data, data$ID == x)
  
  # create bins
  breaks <- seq(0, 4000, by = 100)
  
  # tag counts into the above specified bins
  tags <- cut(pData$acc, breaks = breaks, include.lowest = TRUE, right = FALSE, labels = c(1:40))
  
  # create data frame with counts and the tag 
  taggedData <- data.frame(pData, tags)
  
  # counts number of data points with each tag
  freqTag <- taggedData %>% count(tags, name = "freq")
  # omit na values
  freqTag <- na.omit(freqTag)
  
  # create data frame
  # create column in data frame with midpoints of all the bins
  midpoints <- data.frame(tags = c(1:40), midpoint = seq(50, 3950, by = 100))
  
  # merge midpoints and freqTag based on matching value in "tags" column of both
  bData <- merge(freqTag, midpoints, by.x = "tags", by.y = "tags")
  # order data based on tags column 
  binDataX <- bData[order(bData$tags),]
  
  # create column with log of counts 
  binDataX$lFreq <- log(binDataX$freq)
  
  # create column with log of midpoints
  binDataX$lMid <- log(binDataX$midpoint)
  
  # convert to long format
  #binDataL <- gather(binDataX, key = "acc", value = "counts", 2)
  
  # graph the intensity gradient
  IG <- ggplot(binDataX, aes(x = lMid, y = lFreq)) +
    geom_point() +
    geom_smooth(method = "lm", se = FALSE, color = "black") +
    labs(x = "Intensity (ln)", y = "Time Accumulated (ln)") +
    ggtitle(paste("Adjusted Count IG - ", x)) +
    theme_bw() +
    xlim(0, 8) +
    ylim(0, 10) +
    theme_light() +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
  plot(IG)
  
  # perform linear regression on time accumulated and intensity 
  lm <- lm(lFreq ~ lMid, binDataX)
  
  # add IG value to data frame
  accIG$adjCIG[i] <- lm$coefficients[2]
  # add intercept value to data frame
  accIG$adjCIntercept[i] <- lm$coefficients[1]
  # add R^2 value to data frame
  accIG$adjCR2[i] <- summary(lm)$r.squared
  
  # increment i 
  i = i + 1
  
}
## EXPORT TABLE & FIGURES ##
# export the IG values to output 
write.csv(accIG, file = "NAMEOFCSV.csv", row.names = FALSE)
# save and close pdf
dev.off()
