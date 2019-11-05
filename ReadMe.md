# Assignment for Getting and Cleaning Data course project

## Description

As matter of this assignment, the script *run_analysis.R* perfoms the download and acquisition of the data set of [Human Activity Recognition Using Smartphones](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
A Codebook, this ReadMe and the resulting clean dataset as requested by the assignment, can be find in this repository.

## Content of this repository:

- CodeBook.md: a codebook describing the variables, functions and dataframes obtained during the data acquisition and processing (togheter with some explanations w.r.t. the execution of requests of the assignemnt)

- run_analysis.R: besides downloading the data from internet and acquiring it in several datasets (descrived in the CodeBook.md) the script performs the requests of the assignment, which are hereby listed:

   1. Merges the training and the test sets to create one data set.
   1. Extracts only the measurements on the mean and standard deviation for each measurement.
   1. Uses descriptive activity names to name the activities in the data set
   1. Appropriately labels the data set with descriptive variable names.
   1. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

   Ultimately, the script exports the tidy data in a file named summarised_data.txt. The Codebook.md also indicates a way to reimport the data in order to be able to inspect it.

    The documentation of the functions created in the run_analysis.R is implemented following doxygen guidelines.


- summarised_data.txt: is the product of the execution of run_analysis.R and therefore of the above mentioned 5 steps of data manipulation



