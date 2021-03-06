## This file run_analysis.R contains the implementation steps to fulfil the tasks below: 
##1) Merges the training and the test sets to create one data set.
##2) Extracts only the measurements on the mean and standard deviation for each measurement. 
##3) Uses descriptive activity names to name the activities in the data set
##4) Appropriately labels the data set with descriptive variable names. 
##5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##install.packages("reshape2")
library(reshape2)

## set working directory
setwd("C:/getting-cleaning-data-project")

## Read outcome data
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")

##Merge x data
xtraindata <- read.table("./UCI HAR Dataset/train/X_train.txt")
xtestdata <- read.table("./UCI HAR Dataset/test/X_test.txt")
mergexdata <- rbind(xtraindata, xtestdata)
names(mergexdata) = features[,2]

##Extract logical array with features containing "mean" and "std 
extractfeatures <- grepl("mean|std", features[,2])

##Extract x data with features containing "mean" and "std"
mergexdata = mergexdata[,extractfeatures]

##Merge y data
ytraindata <- read.table("./UCI HAR Dataset/train/Y_train.txt")
ytestdata <- read.table("./UCI HAR Dataset/test/Y_test.txt")
mergeydata <- rbind(ytraindata, ytestdata)

##Merge subject data
subjecttraindata <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subjecttestdata <- read.table("./UCI HAR Dataset/test/subject_test.txt")
mergesubjectdata <- rbind(subjecttraindata, subjecttestdata)

##Assign activity labels
mergeydata[,2] = activitylabels[mergeydata[,1]]
names(mergeydata) = c("act_id", "act_label")

##Assign subject labels
names(mergesubjectdata) = "subject"

##Column bind data to form a new table
data <- cbind(mergesubjectdata, mergeydata, mergexdata)

labels <- c("subject", "act_id", "act_label")
datalabels <- setdiff(colnames(data), labels)
meltdata <- melt(data, id = labels, measure.vars = datalabels)

##Apply mean function to dataset using dcast function
tidydata <- dcast(meltdata, subject + act_id ~ variable, mean)

##Output the clean data as a txt file 
write.table(tidydata, file = "./tidy_data.txt", row.name=FALSE)
