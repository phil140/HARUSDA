# Analysis of Human Activity Recognition Using Smartphones Dataset

Version 1.0
Author: Phil Sophity
Date:   6/11/2015

## Introduction

This document explains what the analysis files did. 

## Description of Data Analysis 

1. Merges the training and the test sets to create one data set.
1. Extracts only the measurements on the mean and standard deviation for each measurement. 
1. Uses descriptive activity names to name the activities in the data set
1. Appropriately labels the data set with descriptive variable names. 


## Notes on requirement #2 "Extract only the measurements on the mean and standard deviation for each measurement."
 The exact requirement here is a bit unclear.
 From the features.info file we find these base measurements
 We interpret the requirement as
   "Extract only the mean and standard deviation of each base measurement. "
"For each measurement" means "for each of these":
    tBodyAcc-XYZ
    tGravityAcc-XYZ
    tBodyAccJerk-XYZ
    tBodyGyro-XYZ
    tBodyGyroJerk-XYZ
    tBodyAccMag
    tGravityAccMag
    tBodyAccJerkMag
    tBodyGyroMag
    tBodyGyroJerkMag
    fBodyAcc-XYZ
    fBodyAccJerk-XYZ
    fBodyGyro-XYZ
    fBodyAccMag
    fBodyAccJerkMag
    fBodyGyroMag
    fBodyGyroJerkMag
The mean of a measurement is indicated as:
    -mean() (appended with one or none of :-X, -Y, or -Z)
The standard deviation of a measurement is indicated as:
    -std() (appended with one or none of :-X, -Y, or -Z)
Features indicated by "meanFreq()" are not included because the requirements do not seem to indicate a need for it.

## Data Source, Acknowlegments

This analysis is based on work provided by the following:

==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - University degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

==================================================================