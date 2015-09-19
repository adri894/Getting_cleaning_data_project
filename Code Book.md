# Getting_cleaning_data_project

Data source

The dataset is derived from the "Human Activity Recognition Using Smartphones Data Set" which was originally made avaiable here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Assumptions:

The code assumes a directory called "UCI HAR Dataset" will be present in the working directory. 
Also, that the packages at the beginning will be pre-installed (dplyr,plyr,tidyr,data.table)

Overview

The "UCI HAR Dataset" contains a Readme file, there a description of variables in each dataset is explained

As per the spec, I selected only the data that had "mean" or "std" in the description, as well as subject data and activity data (located in X_train, Y_train,X_test, Y_test)

The R file merges test and train data for each variable, then merges everything into a single dataset. 

It then selects a subset of the data where "mean" or "std" are present, and adds descriptive labels to both activity and feature by the means of adding a variable name "ActivityName" and modifying the titles of the features with gsub, as per the readme file in the zip folder. Specifically:

t = "time"
f=frequency
Acc=Accelerometer
Gyro= "Gyroscope"
Mag="Magnitude"
BodyBody="Body"

Lastly, the resulting table is generated as a new file (tidydataset.txt) in the working directory with write.table(). 





