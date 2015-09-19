#load data.table package#

library(data.table)

#load dplyr#
library(plyr)
library(dplyr)

#load tidyr#
library(tidyr)

#download and unzip dataset#


if(!file.exists("./finalproject")){dir.create("./finalproject")}

fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  "
download.file(fileUrl, destfile = "./finalproject/prodata.zip",mode='wb')
list.files("./finalproject")


unzip(zipfile="./finalproject/prodata.zip", exdir="./finalproject")

filesPath<- file.path("./finalproject" , "UCI HAR Dataset")

files<-list.files(filesPath,recursive=TRUE)
files

#Read data files for train and test#
dataTrain <- tbl_df(read.table(file.path(filesPath, "train", "X_train.txt" )))
dataTest  <- tbl_df(read.table(file.path(filesPath, "test" , "X_test.txt" )))

# Read subject files for train and test#
SubjectTrain <- tbl_df(read.table(file.path(filesPath, "train", "subject_train.txt")))
SubjectTest  <- tbl_df(read.table(file.path(filesPath, "test" , "subject_test.txt" )))

# Read activity files for train and test#
ActivityTrain <- tbl_df(read.table(file.path(filesPath, "train", "Y_train.txt")))
ActivityTest  <- tbl_df(read.table(file.path(filesPath, "test" , "Y_test.txt" )))



#merge activity and subject rows
#and rename variables as "subject" and "activityNum"
Subjects <- rbind(SubjectTrain, SubjectTest)
setnames(Subjects, "V1", "subject")

Activity<- rbind(ActivityTrain, ActivityTest)
setnames(Activity, "V1", "activityNum")

#combine the data files for training and test#

dataTable <- rbind(dataTrain, dataTest)

# name data variables to match those in features.txt#

dataFeatures <- tbl_df(read.table(file.path(filesPath, "features.txt")))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(dataTable) <- dataFeatures$featureName

#column names for activity labels
activityLabels<- tbl_df(read.table(file.path(filesPath, "activity_labels.txt")))
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))

# Merge columns, first activity and subject, then data#

firstcols<- cbind(Subjects, Activity)
dataTable <- cbind(firstcols, dataTable)


# Reading "features.txt" and extracting only the mean and standard deviation columns#

MeanStddata <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE)

# Taking only measurements for the mean and standard deviation and add "subject","activityNum"

MeanStddata <- union(c("subject","activityNum"), MeanStddata)
dataTable<- subset(dataTable,select=MeanStddata)

##enter name of activity into dataTable
dataTable <- merge(activityLabels, dataTable , by="activityNum", all.x=TRUE)
dataTable$activityName <- as.character(dataTable$activityName)

## create dataTable with variable means sorted by subject and Activity#
dataTable$activityName <- as.character(dataTable$activityName)
dataAggr<- aggregate(. ~ subject - activityName, data = dataTable, mean) 
dataTable<- tbl_df(arrange(dataAggr,subject,activityName))

#Assign names to headers in data columns#


names(dataTable)<-gsub("^t", "time", names(dataTable))
names(dataTable)<-gsub("^f", "frequency", names(dataTable))
names(dataTable)<-gsub("Acc", "Accelerometer", names(dataTable))
names(dataTable)<-gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable)<-gsub("Mag", "Magnitude", names(dataTable))
names(dataTable)<-gsub("BodyBody", "Body", names(dataTable))



write.table(dataTable, "tidydataset.txt", row.name=FALSE)
