# Assignment for Getting and Cleaning Data course project

## Description

As matter of this assignment, the script *run_analysis.R* perfoms the download and acquisition of the data set of [Human Activity Recognition Using Smartphones](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
A Codebook, this ReadMe and the resulting clean dataset as requested by the assignment, can be find in this repository.

## Dataset used for the analysis

[Human Activity Recognition Using Smartphones](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## Files in this repository and brief description

- CodeBook.md: a codebook describing the variables, functions and dataframes obtained during the data acquisition and processing (togheter with some explanations w.r.t. the execution of requests of the assignemnt)

- run_analysis.R: besides downloading the data from internet and acquiring it in several datasets (descrived in the CodeBook.md) the script performs the requests of the assignment, on the downloaded (or previously cached data) present in the working directory, by executing the following steps hereby listed:

   1. Merges the training and the test sets to create one data set.
      - this activity is executed by means of the **cbind** function, which merge the data of Subject, Activity and measurement into two separate dataframes (*test_data* and *train_data*) which are then merged vertically via **rbind** funtion.
   1. Extracts only the measurements on the mean and standard deviation for each measurement.
         - as described in the Codebook.md, the **select** function from dplyr library is used to extract the measurement which variable names contain the keyword "mean" and "std" and stored in the *relevant_data* dataframe
   1. Uses descriptive activity names to name the activities in the data set
         - the activity_labels file is parsed to created a match of activity id and descriptive activity name. This match is used to provide proper naming to the Activity column of the relevant_data dataframe
   1. Appropriately labels the data set with descriptive variable names.
         - gsub and regular expressions are used to rename the measurement in the *relevant_data* dataframe with more descriptive names according to the feature_info.txt file
   1. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
         - a new dataframe called *summarised_data* is created via first grouping the data w.r.t. Subject and Activity columns and the applying the mean function to the measurement of every single group

   Ultimately, the script exports the tidy data in a file named summarised_data.txt. The Codebook.md also indicates a way to reimport the data in order to be able to inspect it.

    The documentation of the functions created in the run_analysis.R is implemented following doxygen guidelines.


- summarised_data.txt: is the product of the execution of run_analysis.R and therefore of the above mentioned 5 steps of data manipulation



