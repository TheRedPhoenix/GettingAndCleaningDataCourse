# Remove all the variables in the Environment, to have a clean start
rm(list = ls())

### FUNCTIONs definition in this section ###

#' Downloads from provided url
#'
#' @param url A remote Url.
#' @param destinationFile The file where to download the content of the url
#' @param useCache A logic parameter. If True and the destination file already exists, does not perform the download. Default: False
downloadOrUseCached <- function(url, destinationFile, useCache = F){
  if(!useCache || !file.exists(destinationFile)){
    download.file(file_url, destinationFile)
  }
}

#' Reads from the Wearable Dataset the measurement and labels and returns these in the shape of a dataset
#'
#' @param subject_file The path to the subject_test or subkect_train file of the wearable data set
#' @param x_file The path to the X_Test or X_Train file of the wearable data set
#' @param y_file The path to the y_Test or y_Train file of the wearable data set
#' @return A dataframe with the merged information for the training or the test set provided in input
#' @note This function assumes to solve with dynamic scoping the following variables: activity_labels, features
#'
readWearableMeasurementDataframe <- function(subject_file, x_file, y_file){
  #' Returns a string name for a provided labelId
  #'
  #' @param labelId The numeric identifier for an activity label
  #' @return The readable name associated to the label id
  #' @note This function assumes to solve with dynamic scoping the following variables: activity_labels
  #' @note The purpose of this function is to achieve Step 3 of the test, giving descriptive names to the activities in the dataframe
  getDescriptiveNameFromLabelId <- function(labelId){
    name <- activity_labels[which(activity_labels$Label.ID == labelId), 2]
    name
  }

  # Read Subject Data
  subject <- read.csv(subject_file,
                      sep="",
                      header = F)[, 1]

  # Read X Data
  x_data <- read.csv(x_file,
                         sep = "",
                         header = F,
                         col.names = features$Name,
                     #    check.names = F
                     )

  # Read y data
  y_data = read.csv(y_file,
                    sep = "",
                    header = F)[, 1]

  # apply the getDescriptiveNameFromLabelId to the complete array of y_data[, 1]
  activity = sapply(y_data, getDescriptiveNameFromLabelId)
  # Build the dataframe as a column bind of the collected data
  data_frame = cbind(subject, activity, x_data)
  # return the dataframe
  data_frame
}

### Main scripts starts here ###

# Variables for this test:
file_url          = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destination_file  = "Getting_And_Cleaning_Data_Project.zip"
data_folder_name  = "UCI HAR Dataset"


# Download file:
downloadOrUseCached(file_url, destination_file, T)

# When unzipping the file, a new folder UCI HAR Dataset (name stored in data_folder_name) will be created.
# To avoid unzipping the file at every run, check first if the folder exists.
# If it doesn't, extract it.

if(!file.exists(data_folder_name)){
  unzip(destination_file)
}


### Data collection from internet has now been performed. The data is ready to be processed

activity_labels_file  <- "./UCI HAR Dataset/activity_labels.txt"
features_file         <- "./UCI HAR Dataset/features.txt"

x_train_file          <- "./UCI HAR Dataset/train/X_train.txt"
y_train_file          <- "./UCI HAR Dataset/train/y_train.txt"
subject_train_file    <- "./UCI HAR Dataset/train/subject_train.txt"
x_test_file           <- "./UCI HAR Dataset/test/X_test.txt"
y_test_file           <- "./UCI HAR Dataset/test/y_test.txt"
subject_test_file     <- "./UCI HAR Dataset/test/subject_test.txt"

# Read the activity labels in a dataframe called activity_labels
activity_labels <- read.csv(activity_labels_file,
                            sep = "",
                            header = F,
                            stringsAsFactors = F,
                            col.names = c("Label ID", "Label Name"))


# Read the feature file in a dataframe called features:
features <- read.csv(features_file,
                     sep = "",
                     header = F,
                     stringsAsFactors = F,
                     col.names = c("ID", "Name"))

# Read the training data in the train_data dataframe
test_data <- readWearableMeasurementDataframe(subject_test_file, x_test_file, y_test_file)
train_data <- readWearableMeasurementDataframe(subject_train_file, x_train_file, y_train_file)

# The data is now collected in two differnet dataframes: test_data and train_data and it is ready to be
# furtherly processed

### Step 1 : Merges the training and the test sets to create one data set
merged_data <- rbind(test_data, train_data)

### Step 2 : Extracts only the measurements on the mean and standard deviation for each measurement.
# To accomplish this step, i make use of the select function, in the dplyr library
library(dplyr)

# columns containing mean and standard deviation also carry the mean and std substring in the column name
# Create a relevant_data dataframe with the select function applied on the merged_data dataframe, containing
# the subject and activity columns (untouched) and only the remaining columns which contain (in their name)
# the substrings mean and std

relevant_data <- select(merged_data, subject, activity, contains("mean"), contains("std"))

# Step 3: Uses descriptive activity names to name the activities in the data set
# Step 3 has already been achieved while collecting the data and creating the original dataframe inside
# the function readWearableMeasurementDataframe through the function getDescriptiveNameFromLabelId

# Step 4
# Capitalise subject and activity column names
names(relevant_data)<-gsub("subject", "Subject", names(relevant_data))
names(relevant_data)<-gsub("activity", "Activity", names(relevant_data))

# Rename type of measurement
names(relevant_data)<-gsub("\\.mean", "Mean", names(relevant_data), ignore.case = TRUE)
names(relevant_data)<-gsub("\\.std",  "StandardDeviation", names(relevant_data), ignore.case = TRUE)
names(relevant_data)<-gsub("freq", "Frequency", names(relevant_data), ignore.case = TRUE)

# modify the initial letter of the column name via RegEx (use ^ to identify start of the word)
names(relevant_data)<-gsub("^t", "Time", names(relevant_data))
names(relevant_data)<-gsub("^f", "Frequency", names(relevant_data))

# replace sensor abbreviation with sensor name
names(relevant_data)<-gsub("Acc", "Accelerometer", names(relevant_data))
names(relevant_data)<-gsub("Gyro", "Gyroscope", names(relevant_data))

# Replace phisical measurement abbreviation with its phisycal name
names(relevant_data)<-gsub("BodyBody", "Body", names(relevant_data))
names(relevant_data)<-gsub("Mag", "Magnitude", names(relevant_data))
names(relevant_data)<-gsub("angle", "Angle", names(relevant_data))
names(relevant_data)<-gsub("gravity", "Gravity", names(relevant_data))

# some column name present the time information in the middle of the word and not in the
# beginning. Taking care of them here:
names(relevant_data)<-gsub("tBody", "TimeBody", names(relevant_data))

# Finally, remove the dots "." (automatically added by R when importing the database to replace not allowed
# characters like "-" or "()") from the column name
names(relevant_data)<-gsub("\\.", "", names(relevant_data))

# Step 5: From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject

# First of all, the data has to be grouped by Subject and activity. By doing this, the dataframe will present a number of groups
# that is minor or equal to NumberofSubjects * Number of activities = 30 * 6 = 180. As all the subject executed at least once all
# all of the activities, the number of groups will be exactly 180
# Then, by means of summarise_all and the application of the mean function for the measurements of the single groups, the resulting
# dataframe will have exactly one observation (row) per each group (meaning 180 rows in this case) representing on each row the mean of the
# variable of that column for the group

# Starting with dplyr 0.8.0, funs in summarise_all is "softly deprecated" and it is recommented to use list.
if(packageVersion("dplyr") > "0.8.0"){
  summarised_data <- relevant_data %>%
                      group_by(Subject, Activity) %>%
                      summarise_all(list(~mean))
} else {
  summarised_data <- relevant_data %>%
                      group_by(Subject, Activity) %>%
                      summarise_all(funs(mean))
}
write.table(summarised_data, "summarised_data.txt", row.name=FALSE, quote = FALSE, sep = ";")
