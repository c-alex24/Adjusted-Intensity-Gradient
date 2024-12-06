# Adapted-Intensity-Gradient
This code is used to generate the adjusted intensity gradient proposed by Alexander et al in https://www.mdpi.com/1424-8220/24/10/3019

The intensity gradient was designed for use with raw acceleration data (gravitational units). This code generates intensity gradients from ActiGraph count data. 

This code will generate both the adjusted intensity gradient proposed in the aforementioned research article and an "unadjusted one" using the same number of bins as proposed by Rowlands et al in 2016 (https://journals.lww.com/acsm-msse/fulltext/2018/06000/beyond_cut_points__accelerometer_metrics_that.25.aspx). 

This code will output two files a pdf and a csv. The PDF includes a visualization of each intensity gradient and the csv includes the adjusted and unadjusted intensity gradients along with the intercept and R^2 for each line.  

In order to run this code you need a file in long format that includes 2 columns:
  ID - with the ID of the participant
  acc - with a count for each 15 second epoch
  e.g.,
  ID    acc
  P01   100
  P01   90
  P01   85
  P02   34
  P02   68
  P02   45
  
