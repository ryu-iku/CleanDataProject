This is a R programming to analysis wearable device experimental data.

About files/folders in this repository:

  * `UCI HAR Dataset` (folder) : the target data for analysis, downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
  * `CleanDataProjectResultData.txt` : result data of run_analysis.R
  * `Code Book - Clean Data Project Result Data.txt` : code book of the result data
  * `run_analysis.R` : R programming to analysis the target data

There are 7 parts in run_analysis.R:
### 0. Read data files to make data frames.
  * 4 data frames are made for using:
   `activity_labels`
   `features`
   `train_sets`
   `test_sets`

### 1. Merges the training and the test sets to create one data set.
  * Merges `train_sets` and `test_sets` to create `analysis_data`.
  * `cbind` is used.

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
  * Extracts columns with the name containing `.mean.` or `.std.`.
  * `select` of the `dplyr` library and its helper `contains` are used.

### 3. Uses descriptive activity names to name the activities in the data set
  * Updates the `activity` column of `analysis_data` according to `activity_labels`.
  * `select` and `mutate` of the `dplyr` library are used.

### 4. Appropriately labels the data set with descriptive variable names.
  * Replaces abbreviations in column names of `analysis_data` with proper words, such as replacing "t" with "TimeDomain".
  * And does other necessary replacement to make descriptive variable (column) names.

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  * Groups `analysis_data` with the columns of `activity` and `subject`, then makes average of each columns for each group.
  * `group_by` and `summarise_each` of the `dplyr` library are used.

### 6. Save result data as a file.