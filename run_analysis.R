library(dplyr)

# 0. Read data files to make data frames.
# Read files of activity lables and features, and convert them to data frame.
setwd("UCI HAR Dataset")
activity_labels <- read.table(file("activity_labels.txt", "r"), 
                              col.names = c("number", "activity.label"),
                              colClasses = c("integer", "character"))
features <- read.table(file("features.txt", "r"), 
                       col.names = c("number", "feature.name"),
                       colClasses = c("integer", "character"))

# Read files of training data, and combine them as a data frame "train_sets".
setwd("train")
X_train <- read.table(file("X_train.txt", "r"), col.names = features$feature.name)
y_train <- read.table(file("y_train.txt", "r"), col.names = "activity")
subject_train <- read.table(file("subject_train.txt", "r"), col.names = "subject")
cbind(X_train, y_train, subject_train) %>%
    mutate(partition = "train") -> train_sets

# Read files of test data, and combine them as a data frame "test_sets".
setwd("../test/")
X_test <- read.table(file("X_test.txt", "r"), col.names = features$feature.name)
y_test <- read.table(file("y_test.txt", "r"), col.names = "activity")
subject_test <- read.table(file("subject_test.txt", "r"), col.names = "subject")
cbind(X_test, y_test, subject_test) %>%
    mutate(partition = "test") -> test_sets

# 1. Merges the training and the test sets to create one data set.
analysis_data <- rbind(train_sets, test_sets)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
analysis_data <- select(analysis_data, contains(".mean."), contains(".std."), activity:partition)

# 3. Uses descriptive activity names to name the activities in the data set
new_activity_col <- sapply(analysis_data$activity, function(x){
    activity_labels[activity_labels[, "number"] == x,]$activity.label
})

analysis_data %>%
    select(-activity) %>%
    mutate(activity = new_activity_col) -> analysis_data

# 4. Appropriately labels the data set with descriptive variable names.

# Make a text list of before and after regex for text replacement.
s <- "^t,TimeDomain\\.
^f,FrequencyDomain\\.
Acc,Acceleration\\.
Gyro,Gyroscope\\.
Mag,Magnitude\\.
Jerk,JerkSignal\\.
std,StandardDeviation\\.
BodyBody,Body
\\.+,\\.
\\.+$,"

d <- read.table(textConnection(s), header = F, sep = ",", 
                col.names = c("before", "after"),
                colClasses = c("character", "character"))
n <- names(analysis_data)

sapply(d$before, function(x){
    after <- d[d$before == x,]$after
    n <<- gsub(x, after, n)
})

names(analysis_data) <- n

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

analysis_data %>%
    select(-partition) %>%
    group_by(activity, subject) %>%
    summarise_each(funs(mean)) -> analysis_data

# 6. Save result data as a file.
setwd("../..")
write.table(analysis_data, "CleanDataProjectResultData.txt", row.names = FALSE)
