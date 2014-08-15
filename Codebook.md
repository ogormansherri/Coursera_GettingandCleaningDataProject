# Instructions for Coursera
Course Title:| Getting and Cleaning Data     | 
------------ | ----------------------------- | 
*Project*    | Tidy Data:  Smart Phone Data  | 
*Name:*      | Sherri Verdugo                |
*Date:*      | August 13, 2014               |
*Github:*    | https://github.com/verdu103   |
*Rpubs:*     | rpubs.com/geekgirl72          |

---

## Table of Contents

	Short Description
	Computer Information
	Original Data Location
	Participant Information
	Project Process
		Libraries 
		Processing the Data
			Loading the data
		Pre-processing steps
			Merging the training and testing sets
			Extracted Measurements
				Mean for each measurement
				Standard deviation for each measurement
		Descriptive Naming Process
			Labeling with descriptive names
			Create new data set
		Create new second independent tidy data set
			Contains the average of each variable:
				activity
				subject
	Codebook Variable Names
---
## Short Description
	This codebook describes the collection, processing and cleaning data steps 	needed for the course project. Data was collected from accelerometers from 	the Samsung Galaxy S smartphone. In addition, each section represents a portion 
	of the requested items for the course project:
		1. Tidy data set described on the Project_Description.md
		2. Link to Github repository with script for the analysis: run_analysis.R
		3. Codebook for variables
	

---
## Computer and Programming Environment 
### Computer System
	Operating System: Mac OS X Version 10.9.4
	Processor: 1.7 GHz Intel Core i5
	Platform: x86_64-apple-darwin13.1.0 (64-bit)
### Programming Environment
	R: version 3.1.0 (2014-04-10) --"Spring Dance"
	RStudio: Version 0.98.953 – © 2009-2013 RStudio, Inc.

---
## Original Data Location
The original data was provided through a link on the Coursera website for the Getting and Cleaning Data course. 

* Website for data
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>
* Link for downloading data
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

---
## Dataset and Participant Information
### Dataset Information
	* Number of participants: 30 volunteers
	* Age range of participants: 19-48 years old
	* No of activities: 6
	* WALKING
	* WALKING_UPSTAIRS
	* WALKING_DOWNSTAIRS
	* SITTING
	* STANDING
	* LAYING

### Participant and Data Information	
	* Participants wore a smartphone (Samsung Galaxy S) on the waist
	* Additional embedded equipment
		* Accelerometer
		* Gyroscope
	* Data captured @ a constant rate of 50Hz
		* 3-axial linear acceleration 
		* 3-axial angular velocity 
	* Video-recorded experiments to label data manually
	* Partitioned data
		* Training data: 70% of the volunteers
		* Testing data: 30% of the volunteers
	* Sensor signals for accelerator & gyroscope
		* Pre-processed via application of noise filters
		* Sampled into fixed-width sliding windows of: 2.56 sec & 50% overlap
			* 128 readings/window
	* Sensor acceleration signal components:
		* gravitational 
		* body motion
	* Signals separated by a Butterworth low-pass filter into body acceleration and gravity
	* Gravitation force assumptions for low frequency components 
		* Filter with 0.3 Hz cutoff frequency
	* Each window had a vector of features by calculating variables from time and frequency
	* Attribute information
		* Triaxial acceleration from the accelerator
			*total acceleration
			* estimated body acceleration
		* Triaxial angular velocity from the gyroscope
		* 561-feature vector with time and frequency domain variables
		* Activity label
		*Identifier of the subject that performed the experiment

---	
## Processing the Data
###Loading the data
The entire script and all files are available for review and use in the github repository. For purposes of the codebook and instructions, the code used to create the new tidy data set are referenced in this portion of the codebook. Cheers.

#### Part one: Preliminaries
1. Locate the script named `run_analysis.R` in the repository for the Getting and Cleaning Data Project
2. Library needed for analysis: `library(utils)`
3. Set your working directory with the `setwd("~/filelocation/courseproject")` command
4. Obtaining the data
	* Caveat: be sure that you are working in the directory you specified above
5. Download and unzip the dataset for the project

```
my.file = "getdata_prj1.zip"
if (!file.exists(my.file)) {
  retval = download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
",
                         destfile = my.file,
                         method = "curl")
}

prj1.read <- read.csv(unzip(my.file)) ## unzips the file :)
```

#### Part two: Read in the datasets for the project
```
train.data <- read.table("./datasets/train/X_train.txt")
dim(train.data); head(train.data, 1)

train.label <- read.table("./datasets/train/y_train.txt")
table(train.label)

train.subject <- read.table("./datasets/train/subject_train.txt")
dim(train.subject)

test.data <- read.table("./datasets/test/X_test.txt")
dim(test.data)

test.label <- read.table("./datasets/test/y_test.txt")
table(test.label)

test.subject <- read.table("./datasets/test/subject_test.txt")
dim(test.subject)
```


#### Part three: Merging the training and testing sets
```
join.data <- rbind(train.data, test.data)
dim(join.data)

join.label <- rbind(train.label, test.label)
dim(join.label)

join.subject <- rbind(train.subject, test.subject)
dim(join.subject)
```

#### Part four: Extracted Measurements
	In this portion of the project we are finding the mean and Standard 	deviation for each measurement. The following code does exactly that.
	
```
data.features <- read.table("./datasets/features.txt")
dim(data.features)#561 x 2

mean.stdev <- grep("mean\\(\\)|std\\(\\)", data.features[,2])
length(mean.stdev) ## 66

join.data <- join.data[, mean.stdev]
dim(join.data) #10299 x 66
```

#### Part five: Cleaning

```
## remove the "()"
names(join.data) <- gsub("\\(\\)", "", data.features[mean.stdev, 2]) 
## Capitalize S
names(join.data) <- gsub("std", "Std", names(join.data))
##Capitalize M
names(join.data) <- gsub("mean", "Mean", names(join.data))
##Remove the "-" in column names
names(join.data) <- gsub("-", "", names(join.data))
```

#### Part six: Descriptive naming process 
```
##Use descriptive activity names to name activities in data set
activities <- read.table("./datasets/activity_labels.txt")
#change to lower case to prevent typos
activities[, 2] <- tolower(gsub("_", "", activities[, 2]))
substr(activities[2, 2], 8, 8) <- toupper(substr(activities[2,2], 8, 8))
substr(activities[3, 2], 8, 8) <- toupper(substr(activities[3,2], 8, 8))
activities.label <- activities[join.label[,1], 2]
join.label[, 1] <- activities.label
names(join.label) <- "activities"
###Appropriately label the data set with descriptive variable names
names(join.subject) <- "subjects"
clean.data <- cbind(join.subject, join.label, join.data)
dim(clean.data) ## 10299 x 68
head(clean.data, 2)
write.table(clean.data, "merged_data.txt") ##writes the first dataset
```
#### Part seven: Create new tidy data set
	* New second independent tidy data set
	* Contains the average of each variable for each
		* activity
		* subject
		
```
subject.len <- length(table(join.subject))
activities.len <- dim(activities)[1] ## 6
column.len <- dim(clean.data)[2] ##68
results <- matrix(NA, nrow=subject.len*activities.len, ncol=column.len)
colnames(results) <- colnames(clean.data)
row <- 1
for (i in 1:subject.len){
  for (j in 1:activities.len){
    results[row, 1] <- sort(unique(join.subject)[,1])[i]
    results[row, 2] <- activities[j,2]
    bools1 <- i == clean.data$subject
    bools2 <- activities[j, 2] == clean.data$activities
    results[row, 3:column.len] <- colMeans(clean.data[bools1&bools2, 3:column.len])
    row <- row + 1
  }
}

head(results, 1)
write.table(results, "data_means.txt") #write out the second dataset
```

---

## Codebook: Variable Names
The final data contains one row for each subject/activity pair with columns for the subject, activity, and all extracted features that had a mean or standard deviation from the original dataset. The resulting file is called: data_means.txt. The dimensions are: 180 rows x 68 columns.

__ID Fields__
	
	* subjects: Participant of the study ('the subject')
		subjects               
		1 : 				6
		10: 				6
		11: 				6
		12: 				6
		13: 				6
		14: 				6
		Other:				144
	* activities: six activities
		laying: 			30
		sitting:			30
		standing:			30
		walking:			30
		walkingDownstairs:	30
		walkingUpstairs:	30	
		
fieldname:      | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
----------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*subjects*      | 1    | 180 | 15.5 | 8.68 |  15.5  |  15.5  |11.12|  1 | 30 |   29 |   0 |  -1.22  |0.65|
*activities*    | 2    | 180 | 3.5  | 1.71 |   3.5  |   3.5  |2.22 |  1 |  6 |    5 |   0 |  -1.29  |0.13|

__Feature Extractions & Field Names__

*tBodyAcc: Mean and St. Deviation*

fieldname:      | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
----------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*tBodyAccMeanX* | 3    |180  |90.5  | 52.11|   90.5 |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|
*tBodyAccMeanY* | 4    |180  |90.5  | 52.11|   90.5 |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|
*tBodyAccMeanZ* | 5    |180  |90.5  | 52.11|   90.5 |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|
*tBodyAccStdX*  | 6    |180  |90.5  | 52.11|   90.5 |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|
*tBodyAccStdY*  | 7    |180  |90.5  | 52.11|   90.5 |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|
*tBodyAccStdZ*  | 8    |180  |90.5  | 52.11|   90.5 |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|

*tGravityAcc: Mean and St. Deviation*

fieldname:        | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
------------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*tGravityAccMeanX*| 9    |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|
*tGravityAccMeanY*| 10   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|
*tGravityAccMeanZ*| 11   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|
*tGravityAccStdX* | 12   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|
*tGravityAccStdY* | 13   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|
*tGravityAccStdZ* | 14   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|

*tBodyAccJerk: Mean and St. Deviation*

fieldname:         | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
-------------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*tBodyAccJerkMeanX*| 15   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|  179 |   0 |   -1.22 |3.88|
*tBodyAccJerkMeanY*| 16   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|  179 |   0 |   -1.22 |3.88|
*tBodyAccJerkMeanZ*| 17   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|  179 |   0 |   -1.22 |3.88|
*tBodyAccJerkStdX* | 18   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|  179 |   0 |   -1.22 |3.88|
*tBodyAccJerkStdY* | 19   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|  179 |   0 |   -1.22 |3.88|
*tBodyAccJerkStdZ* | 20   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|  179 |   0 |   -1.22 |3.88|

*tBodyGyro: Mean and St. Deviation*

fieldname:      | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
----------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*tBodyGyroMeanX*| 21   | 180 |90.5  |52.11 |  90.5  |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|
*tBodyGyroMeanY*| 22   | 180 |90.5  |52.11 |  90.5  |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|
*tBodyGyroMeanZ*| 23   | 180 |90.5  |52.11 |  90.5  |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|
*tBodyGyroStdX* | 24   | 180 |90.5  |52.11 |  90.5  |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|
*tBodyGyroStdY* | 25   | 180 |90.5  |52.11 |  90.5  |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|
*tBodyGyroStdZ* | 26   | 180 |90.5  |52.11 |  90.5  |  90.5  |66.72|  1 |180 |  179 |   0 |   -1.22 |3.88|

*tBodyGyroJerk: Mean and St. Deviation*

fieldname:          | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
--------------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*tBodyGyroJerkMeanX*| 27   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72| 1  | 180| 179  |  0  |  -1.22  |3.88|
*tBodyGyroJerkMeanY*| 28   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72| 1  | 180| 179  |  0  |  -1.22  |3.88|
*tBodyGyroJerkMeanZ*| 29   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72| 1  | 180| 179  |  0  |  -1.22  |3.88|
*tBodyGyroJerkStdX* | 30   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72| 1  | 180| 179  |  0  |  -1.22  |3.88|
*tBodyGyroJerkStdY* | 31   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72| 1  | 180| 179  |  0  |  -1.22  |3.88|
*tBodyGyroJerkStdZ* | 32   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72| 1  | 180| 179  |  0  |  -1.22  |3.88|

*tBodyAccMag: Mean and St. Deviation*

fieldname:       | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
-----------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*tBodyAccMagMean*|  33  |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*tBodyAccMagStd* |  34  |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|

*tGravityAccMagMean: Mean and St. Deviation*

fieldname:          | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
--------------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*tGravityAccMagMean*| 35   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*tGravityAccMagStd* | 36   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|

*tBodyAccJerkMag: Mean and St. Deviation*

fieldname:           | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
---------------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*tBodyAccJerkMagMean*| 37   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*tBodyAccJerkMagStd* | 38   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|

*tBodyGyroMag: Mean and St. Deviation*

fieldname:        | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
------------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*tBodyGyroMagMean*|  39  |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*tBodyGyroMagStd* |  40  |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|

*tBodyGyroJerkMag: Mean and St. Deviation*

fieldname:            | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
----------------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*tBodyGyroJerkMagMean*| 41   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*tBodyGyroJerkMagStd* | 42   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|

*fBodyAcc: Mean and St. Deviation*

fieldname:      | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
----------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*fBodyAccMeanX* | 43   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyAccMeanY* | 44   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyAccMeanZ* | 45   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyAccStdX*  | 46   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyAccStdY*  | 47   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyAccStdZ*  | 48   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|

*fBodyAccJerk: Mean and St. Deviation*

fieldname:         | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
-------------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*fBodyAccJerkMeanX*| 49   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyAccJerkMeanY*| 50   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyAccJerkMeanZ*| 51   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyAccJerkStdX* | 52   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyAccJerkStdY* | 53   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyAccJerkStdZ* | 54   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|


*fBodyGyro: Mean and St. Deviation*

fieldname:      | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
----------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*fBodyGyroMeanX*| 55   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyGyroMeanY*| 56   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyGyroMeanZ*| 57   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyGyroStdX* | 58   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyGyroStdY* | 59   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyGyroStdZ* | 60   |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|

*fBodyAccMag: Mean and St. Deviation*

fieldname:       | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
-----------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*fBodyAccMagMean*|   61 |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyAccMagStd* |   62 |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|

*fBodyBodyAccJerkMag: Mean and St. Deviation*

fieldname:               | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
-------------------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*fBodyBodyAccJerkMagMean*|    63| 180 |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyBodyAccJerkMagStd* |    64| 180 |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|

*fBodyBodyGyroMag: Mean and St. Deviation*

fieldname:            | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
----------------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*fBodyBodyGyroMagMean*|   65 |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyBodyGyroMagStd* |   66 |180  |90.5  |52.11 |  90.5  |  90.5  |66.72|   1| 180|   179|    0|    -1.22|3.88|

*fBodyBodyGyroJerkMag: Mean and St. Deviation*

fieldname:                | vars | n   | mean | sd   | median |trimmed | mad |min |max |range |skew |kurtosis |se  |
--------------------------|----- |-----|------|------|--------|--------|-----|----|----|------|-----|---------|----| 
*fBodyBodyGyroJerkMagMean*|   67 |180  |90.5  |52.11 |   90.5 |   90.5 |66.72|   1| 180|   179|    0|    -1.22|3.88|
*fBodyBodyGyroJerkMagStd* |   68 |180  |90.5  |52.11 |   90.5 |   90.5 |66.72|   1| 180|   179|    0|    -1.22|3.88|
	
---