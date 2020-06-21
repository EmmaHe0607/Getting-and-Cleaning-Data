getwd()
setwd("/Users/heshiqi/Desktop/Coursera-R/Course3-week4")
install.packages("plyr")
library(plyr)
library(data.table)
fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('UCI HAR Dataset.zip')){
    download.file(fileurl,'UCI HAR Dataset.zip', method = "curl")
    unzip("UCI HAR Dataset.zip", exdir = getwd())
}

## Read data
## Training data:
xtrain <- read.table('UCI HAR Dataset/train/X_train.txt', header=FALSE)
ytrain <- read.csv('./UCI HAR Dataset/train/y_train.txt', header=FALSE)
subjectTrain <- read.csv('./UCI HAR Dataset/train/subject_train.txt', header=FALSE)

## Test data:
xtest<- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE)
ytest<- read.table("UCI HAR Dataset/test/Y_test.txt", header=FALSE)
subjectTest <-read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE)

## Features and activities
features<-read.table("UCI HAR Dataset/features.txt", header=FALSE)
activity<-read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE)

## Step 1: Merges the training and the test sets to create one data set.
xData <- rbind(xtrain, xtest)
yData <- rbind(ytrain, ytest)
subjectData <- rbind(subjectTrain, subjectTest)

dim(xData)
dim(yData)
dim(subjectData)
dim(mergeData)

## Step 2: Extracts only the measurements on the mean and standard deviation for each 
## measurement.
index <- grep("mean\\(\\)|std\\(\\)", features[,2]) 
length(index) ## count of features
xData <- xData[,index] 
dim(xData) 

## Step 3: Uses descriptive activity names to name the activities in the data set
yData[,1] <- activity[yData[,1],2]
head(yData) 
View(yData)

## Step 4: Appropriately labels the data set with descriptive variable names.
mergeData <- cbind(subjectData, yData, xData) ## merge all datasets

names(subjectData) <- "Subject"
names(yData) <- "Activity"
names(xData) <- names

names(mergeData) <- make.names(names(mergeData))
names(mergeData) <- gsub('Acc',"Acceleration",names(mergeData))
names(mergeData) <- gsub('GyroJerk',"AngularAcceleration",names(mergeData))
names(mergeData) <- gsub('Gyro',"AngularSpeed",names(mergeData))
names(mergeData) <- gsub('Mag',"Magnitude",names(mergeData))
names(mergeData) <- gsub('^t',"TimeDomain.",names(mergeData))
names(mergeData) <- gsub('^f',"FrequencyDomain.",names(mergeData))
names(mergeData) <- gsub('\\.mean',".Mean",names(mergeData))
names(mergeData) <- gsub('\\.std',".StandardDeviation",names(mergeData))
names(mergeData) <- gsub('Freq\\.',"Frequency.",names(mergeData))
names(mergeData) <- gsub('Freq$',"Frequency",names(mergeData))

View(mergeData)

## Step 5: From the data set in step 4, creates a second, independent tidy 
## data set with the average of each variable for each activity and each 
## subject.

mergeData<-data.table(mergeData)
tidy <- mergeData[, lapply(.SD, mean), by = 'Subject,Activity']
write.table(tidy, file = "Tidy.txt", row.names = FALSE)
