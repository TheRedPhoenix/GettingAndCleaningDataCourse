# Codebook

This is the codebook for the Getting and Cleaning Data course end project. The purpose of this codebook is to provide an overview on the *run_analysis.R* script and the executed steps to proceess the raw data and provide the resulting dataframe.

## Getting the data
The *run_analysis.R* script executes the download of the data from the provided url:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
and stores the file in the current working directory. 
The file is then extracted in the folder *UCI HAR Dataset* which contains the data to be processed.

For this section, the used variables and functions are:

| Variable              | Type          | Description |
| --------------------- | :-------------: | ----------- |
| *file_url*                | string        | Contains the above mentioned url 
| *destination_file*        | string        | Represents the file where to download the data contained at the above mentioned link
| *data_folder_name*        | string        | Contains the name of the extracted folder, *UCI HAR Dataset*
| *downloadOrUseCached()*   | function      | Performs the download, with the option of using cached data (previously downloaded data) if enabled

## Step 1 ~ Data Processing and Merging datasets

At this stage the data is collected in the working directory and can be processed. To proceed with the processing, the following entities are defined:

| Variable | Type   | Description |
| ---------| :----: | ----------- |
| *activity_labels_file* | string | Contains the path to the activity_labels.txt file in the dataset 
| *features_file* | string | Contains the path to the features.txt file in the dataset 
| *x_train_file* | string | Contains the path to the X_train.txt file in the dataset folder
| *y_train_file* | string | Contains the path to the y_train.txt file in the dataset folder
| *subject_train_file*| string | Contains the path to the subject_train.txt file in the dataset folder
| *x_test_file* | string | Contains the path to the X_test.txt file in the dataset folder
| *y_test_file* | string | Contains the path to the y_test.txt file in the dataset folder
| *subject_test_file* | string | Contains the path to the subject_test.txt file in the dataset folder

Activity Labels and Features data is acquired and stored into two dataframes named activity_labels and features.

Through the function readWearableMeasurementDataframe() the train data and test data is acquired into two different dataframes respectively train_data and test_data and consequently merged into a merged_data dataframe. 

(Information about the acquisition process in the documentation of readWearableMeasurementDataframe() function) 

Hereby the information about the above mentioned dataframes 

| Dataframe | Observations (# of Rows)   | Variables (# of Columns) | Additional Info |
| ---------| :----: | :----: | ---- |
| features | 561 |  2  | Acquired from *features.txt*, contains a mapping between a feature ID (1st column) and its name (2nd column)
| activity_labels | 6 | 2 | Acquired from *activity_labels.txt*, contains a mapping between an activity ID (1st column) and its descriptive Name (2nd column)
| test_data | 2947 | 563 | The dataframe of the test data, comprehending the performing subject (1st column), the activity associated with the measurement (2nd column) followed by the 561 measurement obtained from the X_test.txt file
| train_data | 7352 | 563 | The dataframe of the test data, comprehending the performing subject (1st column), the activity associated with the measurement (2nd column) followed by  561 measurement obtained from the X_train.txt file
| merged_data | 10299 | 563 | The result of **rbind** of test_data and train_data

## Step 2 ~ Selection of relevant data

As part of the request of the assignment, step 2 request is to *extract only the measurements on the mean and standard deviation for each measurement*

This result is obtained via the **select** function in the *dplyr* library. From the *merged_data* dataframe, only the subject column, the activity column and all the columns containing _mean_ or _std_ in their name are extracted and saved in the *relevant_data* dataframe

| Dataframe | Observations (# of Rows)   | Variables (# of Columns) | Additional Info |
| ---------| :----: | :----: | ---- |
| relevant_data | 10299 |  88  | A selection of specific columns from the *merged_data* dataframe using the **select** funciton

## Step 3 ~ Data Refinement

As part of the request of the assignment, step 3 request is to *use descriptive activity names to name the activities in the data set*

This is already covered in the **Step 1**, since when the data from y_train.txt and y_test.txt is acquired, the activity information is already replace with a decriptive label describing the relevat activity. The *merged_data* and *relevant_data* dataframes at this stage implement already this feature.

## Step 4 ~ Tidying up column names

As part of the request of the assignment, step 4 request is to *Appropriately label the data set with descriptive variable names*

The following modifications are applied to the *relevant_data* dataframe:

1. Capitalise subject and activity column names
   - column "subject" is renamed into "Subject"
   - column "activity" is renamed into "Activity"

1. Rename measurement type
   - ".mean" in column names is replaced with "Mean" 
   - ".std" in column names is replaced with "StandardDeviation"
   - "freq" in column names is replaced with "Frequency"

1. Replace initial letter indicating time and frequency measurement type
   - "t" in the beginning of the name of a column ("^t") is replaced with "Time"
   - "f" in the beginning of the name of a column ("^f") is replaced with "Frequency

1. Replace sensor abbreviation with sensor name 
   - "Acc" is replaced with "Accelerometer" in column names
   - "Gyro" is replaced with "Gyroscope" in column names

1. Physical measurement is replaced with a descriptive name or capitalised
   - "BodyBody" is replaced with "Body" in column names
   - "Mag" is replaced with "Magnitude" in column names
   - "angle" is replaced with "Angle" in column names
   - "gravity" is replaced with "Gravity" in column names

1. Additional refinement:
   - "tBody" is replaced with "TimeBody" in the middle of column names
   - "." character added during import of strings from file are removed (i.e. replaced with "")

## Step 5 ~ Grouping, applying Mean and Export the dataframe

As last point of the assignment, step 5 requests to perform the following: 
*From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject*

This is achieved by means of grouping the *relevant_data* dataframe by Subject and Activity information and then applying the mean function per each variable (column) of each group.
The resulting dataframe has the following characteristics

| Dataframe | Observations (# of Rows)   | Variables (# of Columns) | Additional Info |
| ---------| :----: | :----: | ---- |
| summarised_data | 180 |  88  | A dataframe containing the mean of all measurement of *relevant_data* for the groups identified by the unique combinations of Subject and Activity 

The **summmarised_data** dataframe is exported to the **summarised_data.txt** file and uploaded to this github repository.

The **summarised_data.txt** is exported via the following command:

    write.table(summarised_data, "summarised_data.txt", row.name=FALSE, quote = FALSE, sep = ";")

meaning that:

    row.name=FALSE
 no row names are written along with the dataframe *summarised_data*

     quote = FALSE
 no quotes are wrapping string variables (e.g. the content of the Activity column)

     sep=";"
the resulting file will be have the csv format (although the extension will be *.txt) with columns separated by the character ";"

##### Additional note: it is possible to import the **summarised_data.txt** via the following command:
    read.csv2("summarised_data.txt")
