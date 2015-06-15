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

## Program Details
### Description: 
Create a tidy data set from the source ""Human Activity Recognition Using Smartphones Dataset".

### Usage:

 ```
   source("run_analysis.R");
   run_analysis.main()

```
### Files required:
 These files must be in your working directory:
* activity_labels.txt
* subject_train.txt
* y_train.txt
* X_train.txt
* subject_test.txt
* y_test.txt
* X_test.txt
* features.txt

### run_analysis.R file contents:

1  Helper functions are at the beginning of the file.
* cleanStr
* namesBase
* descriptiveNames

2 The main execution steps follow after the Helper functions
* Step 1. Merges the training and the test sets to create one data set.
* Step 2. Extract only the measurements on the mean and standard deviation for each measurement. 
* Step 3. Uses descriptive activity names to name the activities in the data set
* Step 4. Appropriately labels the data set with descriptive variable names. 
* Step 5. From the data set in #4, creates a second, independent tidy data set.

3 Required libraries
* stringr
* plyr

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

## See also:
* PhilsCodeBook.txt
