#===================================================================================================
# File: run_analysis.R
# Author: Phil Sophity
# Date: 6/14/2015
# Description: Create a tidy data set from the source ""Human Activity Recognition Using Smartphones Dataset".
# Usage: source("run_analysis.R")
# Requirements: These files must be in your working directory:
#   * activity_labels.txt
#   * subject_train.txt
#   * y_train.txt
#   * X_train.txt
#   * subject_test.txt
#   * y_test.txt
#   * X_test.txt
#   " features.txt
# See also:
#    1. README.md
#    2. PhilsCodeBook.txt
#
#===================================================================================================
# File contents:
#   1. Helper functions are at the beginning of the file.
#      * cleanStr
#      * namesBase
#      * descriptiveNames
#   2. The main execution steps follow after the Helper functions
#      * Step 1. Merges the training and the test sets to create one data set.
#      * Step 2. Extract only the measurements on the mean and standard deviation for each measurement. 
#      * Step 3. Uses descriptive activity names to name the activities in the data set
#      * Step 4. Appropriately labels the data set with descriptive variable names. 
#      * Step 5. From the data set in #4, creates a second, independent tidy data set.
#===================================================================================================
require("stringr");
require("plyr")

# For debug output, set TRUE, otherwise set FALSE
DEBUG=FALSE
rd_nrows=-1 # for production
if(DEBUG) rd_nrows=10 # for debugging

###==================================================================
## Helper functions
###==================================================================
# Remove "()","-","," from string x
# eg: x<-"tBodyAcc-arCoeff()-X,1"
cleanStr<-function(x){
    y<-str_replace_all(x, "[-(),]", "_")
    y<-str_replace_all(y, "___", "_");
    y<-str_replace_all(y, "__", "_")
    y<-str_replace_all(y, "BodyBody", "Body")	# We assume that names like "fBodyBodyAccJerkMag..." can be safely renamed to "fBodyAccJerkMag..."
    return(y)
}

# Get a list of all the basic measurments
namesBase<-function() {
# Note: There was some variations of "BodyBody" vs "Body" in the original codebook. 
#       This appearant error is handled in function 'cleanStr'
namesBase<-c(
    "tBodyAcc_"		,
    "tGravityAcc_"	,
    "tBodyAccJerk_"	,
    "tBodyGyro_"	,
    "tBodyGyroJerk_"	,
    "tBodyAccMag"	,
    "tGravityAccMag"	,
    "tBodyAccJerkMag"	,  
    "tBodyGyroMag"	,
    "tBodyGyroJerkMag"	,
    "fBodyAcc_"		,
    "fBodyAccJerk_"	,
    "fBodyGyro_"	,
    "fBodyAccMag"	,
    "fBodyAccJerkMag"	,
    "fBodyGyroMag"	,
    "fBodyGyroJerkMag"    
    )
    return(namesBase)
}    

# This list has more descriptive names for the dataset
descriptiveNames<-function(){
descriptiveNames<-c(
"1","subjid"			    ,		"subjectId"				    ,
"2","actcode"			    ,		"activityCode"				    ,
"3","tort"			    ,		"subjectPartition"			    ,
"4","tBodyAcc_mean_X"		    ,		"timeDomainBodyAccelerationXAxisMean"	    ,
"5","tBodyAcc_mean_Y"		    ,		"timeDomainBodyAccelerationYAxisMean"	    ,
"6","tBodyAcc_mean_Z"		    ,		"timeDomainBodyAccelerationZAxisMean"	    ,
"7","tBodyAcc_std_X"		    ,		"timeDomainBodyAccelerationXAxisStd"	    ,
"8","tBodyAcc_std_Y"		    ,		"timeDomainBodyAccelerationYAxisStd"	    ,
"9","tBodyAcc_std_Z"		    ,		"timeDomainBodyAccelerationZAxisStd"	    ,
"10","tGravityAcc_mean_X"	    ,		"timeDomainGravityAccelerationXAxisMean"	    ,
"11","tGravityAcc_mean_Y"	    ,		"timeDomainGravityAccelerationYAxisMean"	    ,
"12","tGravityAcc_mean_Z"	    ,		"timeDomainGravityAccelerationZAxisMean"	    ,
"13","tGravityAcc_std_X"	    ,		"timeDomainGravityAccelerationXAxisStd"	    ,
"14","tGravityAcc_std_Y"	    ,		"timeDomainGravityAccelerationYAxisStd"	    ,
"15","tGravityAcc_std_Z"	    ,		"timeDomainGravityAccelerationZAxisStd"	    ,
"16","tBodyAccJerk_mean_X"	    ,		"timeDomainBodyAccelerationJerkXAxisMean"	    ,
"17","tBodyAccJerk_mean_Y"	    ,		"timeDomainBodyAccelerationJerkYAxisMean"	    ,
"18","tBodyAccJerk_mean_Z"	    ,		"timeDomainBodyAccelerationJerkZAxisMean"	    ,
"19","tBodyAccJerk_std_X"	    ,		"timeDomainBodyAccelerationJerkXAxisStd"	    ,
"20","tBodyAccJerk_std_Y"	    ,		"timeDomainBodyAccelerationJerkYAxisStd"	    ,
"21","tBodyAccJerk_std_Z"	    ,		"timeDomainBodyAccelerationJerkZAxisStd"	    ,
"22","tBodyGyro_mean_X"		    ,		"timeDomainBodyGyroscopeXAxisMean"		    ,
"23","tBodyGyro_mean_Y"		    ,		"timeDomainBodyGyroscopeYAxisMean"		    ,
"24","tBodyGyro_mean_Z"		    ,		"timeDomainBodyGyroscopeZAxisMean"		    ,
"25","tBodyGyro_std_X"		    ,		"timeDomainBodyGyroscopeXAxisStd"		    ,
"26","tBodyGyro_std_Y"		    ,		"timeDomainBodyGyroscopeYAxisStd"		    ,
"27","tBodyGyro_std_Z"		    ,		"timeDomainBodyGyroscopeZAxisStd"		    ,
"28","tBodyGyroJerk_mean_X"	    ,		"timeDomainBodyGyroscopeJerkXAxisMean"	    ,
"29","tBodyGyroJerk_mean_Y"	    ,		"timeDomainBodyGyroscopeJerkYAxisMean"	    ,
"30","tBodyGyroJerk_mean_Z"	    ,		"timeDomainBodyGyroscopeJerkZAxisMean"	    ,
"31","tBodyGyroJerk_std_X"	    ,		"timeDomainBodyGyroscopeJerkXAxisStd"	    ,
"32","tBodyGyroJerk_std_Y"	    ,		"timeDomainBodyGyroscopeJerkYAxisStd"	    ,
"33","tBodyGyroJerk_std_Z"	    ,		"timeDomainBodyGyroscopeJerkZAxisStd"	    ,
"34","tBodyAccMag_mean_"	    ,		"timeDomainBodyAccelerationMagnitudeMean"	    ,
"35","tBodyAccMag_std_"		    ,		"timeDomainBodyAccelerationMagnitudeStd"		    ,
"36","tGravityAccMag_mean_"	    ,		"timeDomainGravityAccelerationMagnitudeMean"	    ,
"37","tGravityAccMag_std_"	    ,		"timeDomainGravityAccelerationMagnitudeStd"	    ,
"38","tBodyAccJerkMag_mean_"	    ,		"timeDomainBodyAccelerationJerkMagnitudeMean"	    ,
"39","tBodyAccJerkMag_std_"	    ,		"timeDomainBodyAccelerationJerkMagnitudeStd"	    ,
"40","tBodyGyroMag_mean_"	    ,		"timeDomainBodyGyroscopeMagnitudeMean"		    ,
"41","tBodyGyroMag_std_"	    ,		"timeDomainBodyGyroscopeMagnitudeStd"		    ,
"42","tBodyGyroJerkMag_mean_"	    ,		"timeDomainBodyGyroscopeJerkMagnitudeMean"		    ,
"43","tBodyGyroJerkMag_std_"	    ,		"timeDomainBodyGyroscopeJerkMagnitudeStd"		    ,
"44","fBodyAcc_mean_X"		    ,		"frequencyDomainBodyAccelerationXAxisMean"		    ,
"45","fBodyAcc_mean_Y"		    ,		"frequencyDomainBodyAccelerationYAxisMean"		    ,
"46","fBodyAcc_mean_Z"		    ,		"frequencyDomainBodyAccelerationZAxisMean"		    ,
"47","fBodyAcc_std_X"		    ,		"frequencyDomainBodyAccelerationXAxisStd"		    ,
"48","fBodyAcc_std_Y"		    ,		"frequencyDomainBodyAccelerationYAxisStd"		    ,
"49","fBodyAcc_std_Z"		    ,		"frequencyDomainBodyAccelerationZAxisStd"		    ,
"50","fBodyAccJerk_mean_X"	    ,		"frequencyDomainBodyAccelerationJerkXAxisMean"	    ,
"51","fBodyAccJerk_mean_Y"	    ,		"frequencyDomainBodyAccelerationJerkYAxisMean"	    ,
"52","fBodyAccJerk_mean_Z"	    ,		"frequencyDomainBodyAccelerationJerkZAxisMean"	    ,
"53","fBodyAccJerk_std_X"	    ,		"frequencyDomainBodyAccelerationJerkXAxisStd"	    ,
"54","fBodyAccJerk_std_Y"	    ,		"frequencyDomainBodyAccelerationJerkYAxisStd"	    ,
"55","fBodyAccJerk_std_Z"	    ,		"frequencyDomainBodyAccelerationJerkZAxisStd"	    ,
"56","fBodyGyro_mean_X"		    ,		"frequencyDomainBodyGyroscopeXAxisMean"		    ,
"57","fBodyGyro_mean_Y"		    ,		"frequencyDomainBodyGyroscopeYAxisMean"		    ,
"58","fBodyGyro_mean_Z"		    ,		"frequencyDomainBodyGyroscopeZAxisMean"		    ,
"59","fBodyGyro_std_X"		    ,		"frequencyDomainBodyGyroscopeXAxisStd"		    ,
"60","fBodyGyro_std_Y"		    ,		"frequencyDomainBodyGyroscopeYAxisStd"		    ,
"61","fBodyGyro_std_Z"		    ,		"frequencyDomainBodyGyroscopeZAxisStd"		    ,
"62","fBodyAccMag_mean_"	    ,		"frequencyDomainBodyAccelerationMagnitudeMean"	    ,
"63","fBodyAccMag_std_"		    ,		"frequencyDomainBodyAccelerationMagnitudeStd"	    ,
"64","fBodyAccJerkMag_mean_"	    ,		"frequencyDomainBodyAccelerationJerkMagnitudeMean"	    ,
"65","fBodyAccJerkMag_std_"	    ,		"frequencyDomainBodyAccelerationJerkMagnitudeStd"	    ,
"66","fBodyGyroMag_mean_"	    ,		"frequencyDomainBodyGyroscopeMagnitudeMean"	    ,
"67","fBodyGyroMag_std_"	    ,		"frequencyDomainBodyGyroscopeMagnitudeStd"		    ,
"68","fBodyGyroJerkMag_mean_"	    ,		"frequencyDomainBodyGyroscopeJerkMagnitudeMean"	    ,
"69","fBodyGyroJerkMag_std_"	    ,		"frequencyDomainBodyGyroscopeJerkMagnitudeStd"	    ,
"70","activity"			    ,		"activity"					    );
return(descriptiveNames)
}

#######
## MAIN
####
run_analysis.main<-function() {

###==================================================================
## Step 1. Merges the training and the test sets to create one data set.
###==================================================================

fn="subject_train.txt";	f<-read.table(fn);	subject_train<-f;	    # 7352    1
fn="y_train.txt";	f<-read.table(fn);      y_train<-f;
fn="X_train.txt";	f<-read.table(fn);      X_train<-f;		    # 7352  561

fn="subject_test.txt";	f<-read.table(fn);	subject_test<-f;            # 2947    1
fn="y_test.txt";	f<-read.table(fn);	y_test<-f;
fn="X_test.txt";	f<-read.table(fn);	X_test<-f;		    # 2947  561

fn="features.txt";	f<-read.table(fn);	features<-f;
features[,2]<-sapply(features[,2],cleanStr)
names(X_train)<-features[,2]
names(X_test)<-features[,2]

ftest<-cbind(subject_test,   actcode=y_test,  X_test, tort=rep("test",times=nrow(X_test)))  ; names(ftest)[1:2] <-c("subjid","actcode");
ftrain<-cbind(subject_train, actcode=y_train, X_train,tort=rep("train",times=nrow(X_train))); names(ftrain)[1:2]<-c("subjid","actcode");
fall<-rbind(ftest,ftrain)

## Debug support, cache file
if(DEBUG) write.csv(fall,file="fall.csv",row.names = FALSE);
if(DEBUG) fall<-read.csv(file="fall.csv",stringsAsFactors =FALSE,nrows=rd_nrows);

###==================================================================
## Step 2.  Extract only the measurements on the mean and standard deviation for each measurement. 
###==================================================================
##    See the notes in README.md which explains which features are captured here, and why.

namesAll<-names(fall)
namesKeep<-c("subjid","tort","actcode");  # these are columns we added during merging of the datasets


namesBase<-namesBase()
patA<-paste0(namesBase,collapse = "|")	 # regex pattern, any from namesBase
patB<-"mean_|std_"			 # regex pattern, either _mean_ or _std_
pat<-paste0("(",patA,").*","(",patB,")") # regex pattern: patA...patB

colKeep1<-which(namesAll %in% namesKeep)
colKeep2<-grep(pat,namesAll,ignore.case = TRUE)
colKeep<-c(colKeep1,colKeep2)
fint<-fall[,colKeep]                     # fint, the data.frame with just columns we want to keep


## Debug support, cache file
### Write the fields we're keeping and which fields we are dropping for visual inspection and documentation.
namesKeep<-namesAll[colKeep]
namesDrop<-namesAll[-colKeep]
if(DEBUG) write.csv(namesKeep,file="features_keep.txt",row.names = FALSE);
if(DEBUG) write.csv(namesDrop,file="features_drop.txt",row.names = FALSE);
#---

## Debug support, cache file
## Write fint to a temporary cache file
if(DEBUG) write.csv(fint,file="fint.csv",row.names = FALSE);
if(DEBUG) fint<-read.csv(file="fint.csv",stringsAsFactors = FALSE,nrows=rd_nrows);

###==================================================================
## Step 3.    Uses descriptive activity names to name the activities in the data set
###==================================================================
fn="activity_labels.txt";	f<-read.table(fn,stringsAsFactors = FALSE);	activity_labels<-f;
names(activity_labels)<-c("actcode","desc")
# Fortunately the row index is the same as the activity code.
fint$activity<-activity_labels[fint$actcode,2]

## Debug support, cache file
## Write fint to a temporary cache file
if(DEBUG) write.csv(fint,file="fint.csv",row.names = FALSE);
if(DEBUG) fint<-read.csv(file="fint.csv",stringsAsFactors = FALSE,nrows=rd_nrows);

###==================================================================
## Step 4.    Appropriately labels the data set with descriptive variable names. 
###==================================================================

# Get the list of our descriptive names
descriptiveNames<-descriptiveNames()
fint_names<-data.frame(matrix(descriptiveNames,nrow=70,ncol=3,byrow=TRUE),stringsAsFactors = FALSE);
names(fint)<-fint_names[,3];


###==================================================================
## Step 5. From the data set in 4, creates a second, independent tidy data set with the average
##   of each variable for each activity and each subject. (write.table(row.name=FALSE))
###==================================================================
#
# The columns that have measurments are fint[,4:69]
meanByIdActivity<-ddply(fint,c("activity","subjectId"),summarize,
	mean(fint[,4]),	mean(fint[,5]),	mean(fint[,6]),	mean(fint[,7]),	mean(fint[,8]),	mean(fint[,9]),
	mean(fint[,10]),mean(fint[,11]),mean(fint[,12]),mean(fint[,13]),mean(fint[,14]),mean(fint[,15]),mean(fint[,16]),mean(fint[,17]),mean(fint[,18]),mean(fint[,19]),
	mean(fint[,20]),mean(fint[,21]),mean(fint[,22]),mean(fint[,23]),mean(fint[,24]),mean(fint[,25]),mean(fint[,26]),mean(fint[,27]),mean(fint[,28]),mean(fint[,29]),
	mean(fint[,30]),mean(fint[,31]),mean(fint[,32]),mean(fint[,33]),mean(fint[,34]),mean(fint[,35]),mean(fint[,36]),mean(fint[,37]),mean(fint[,38]),mean(fint[,39]),
	mean(fint[,40]),mean(fint[,41]),mean(fint[,42]),mean(fint[,43]),mean(fint[,44]),mean(fint[,45]),mean(fint[,46]),mean(fint[,47]),mean(fint[,48]),mean(fint[,49]),
	mean(fint[,50]),mean(fint[,51]),mean(fint[,52]),mean(fint[,53]),mean(fint[,54]),mean(fint[,55]),mean(fint[,56]),mean(fint[,57]),mean(fint[,58]),mean(fint[,59]),
	mean(fint[,60]),mean(fint[,61]),mean(fint[,62]),mean(fint[,63]),mean(fint[,64]),mean(fint[,65]),mean(fint[,66]),mean(fint[,67]),mean(fint[,68]),mean(fint[,69])
	);
# add column names
y<-names(fint)[4:69]
z<-paste0(y,"MeanByActivitySubjectId")	    # append "MeanByActivitySubjectId" to each ot the descriptive column names
# names(meanByIdActivity)[1:2]<-c("activity","subjectId")
names(meanByIdActivity)[3:ncol(meanByIdActivity)]<-z;
write.table(meanByIdActivity,file = "meanbysubjectactivity.txt",row.name=FALSE)
} # end run_analysis.main()
#######

# run_analysis.main()();
if (!DEBUG) cat("Enter \"run_analysis.main()\" to execute.\n");

