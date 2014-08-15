## Script Name: run_analysis.R
## Course Name: John Hopkins Univeristy Getting and Cleaning Data
## Student Name: Sherri Verdugo
## Date: August 13, 2014
## Version: 1.1_14

## Libraries needed
library(utils)

## Pre-Step One: Set working directory
setwd("~/Google Drive/Coursera_R_studio/get_data/courseproject")

## Step One Part One: Initial unzipping of the files
my.file = "getdata_prj1.zip"
if (!file.exists(my.file)) {
  retval = download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
",
                         destfile = my.file,
                         method = "curl")
}

prj1.read <- read.csv(unzip(my.file)) ## unzips the file :)

## Step One Part Two: read in the data
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

## Step 2: Merge the data
join.data <- rbind(train.data, test.data)
dim(join.data)

join.label <- rbind(train.label, test.label)
dim(join.label)

join.subject <- rbind(train.subject, test.subject)
dim(join.subject)

## Step 2: Extract only the measurements on the mean and st. dev. 
data.features <- read.table("./datasets/features.txt")
dim(data.features)#561 x 2

mean.stdev <- grep("mean\\(\\)|std\\(\\)", data.features[,2])
length(mean.stdev) ## 66

join.data <- join.data[, mean.stdev]
dim(join.data) #10299 x 66

#cleaning
#remove the "()"
names(join.data) <- gsub("\\(\\)", "", data.features[mean.stdev, 2]) 
#Capitalize S
names(join.data) <- gsub("std", "Std", names(join.data))
#Capitalize M
names(join.data) <- gsub("mean", "Mean", names(join.data))
#Remove the "-" in column names
names(join.data) <- gsub("-", "", names(join.data))

## Step 3: Use descriptive activity names to name activities in data set
activities <- read.table("./datasets/activity_labels.txt")
#change to lower case to prevent typos
activities[, 2] <- tolower(gsub("_", "", activities[, 2]))
substr(activities[2, 2], 8, 8) <- toupper(substr(activities[2,2], 8, 8))
substr(activities[3, 2], 8, 8) <- toupper(substr(activities[3,2], 8, 8))
activities.label <- activities[join.label[,1], 2]
join.label[, 1] <- activities.label
names(join.label) <- "activities"

## Step 4: 
###Appropriately label the data set with descriptive variable names
names(join.subject) <- "subjects"
clean.data <- cbind(join.subject, join.label, join.data)
dim(clean.data) ## 10299 x 68
head(clean.data, 2)
write.table(clean.data, "merged_data.txt") ##writes the first dataset

## Step 5: 
###Create a second independent tidy data set that contains the 
####average of each variable for each activity and each subject
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
