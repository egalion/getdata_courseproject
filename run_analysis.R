# STEP 1
# 1. Merge the training and the test sets to create one data set.


# load files that compose the train dataset

x_train <- read.table("data/train/X_train.txt", header = FALSE)
subject_train <- read.table("data/train/subject_train.txt", header = FALSE)
y_train <- read.table("data/train/y_train.txt", header = FALSE)

str(x_train)
str(subject_train)
str(y_train)

# They all have 7352 observations

# Load data that compose the test dataset

x_test <- read.table("data/test/X_test.txt", header = FALSE)
subject_test <- read.table("data/test/subject_test.txt", header = FALSE)
y_test <- read.table("data/test/y_test.txt", header = FALSE)

str(x_test)
str(subject_test)
str(y_test)

# They all have 2947 observations

# concatenate train data by column

train_data <- cbind(subject_train, y_train, x_train)
str(train_data)

# concatenate test data by column

test_data <- cbind(subject_test, y_test, x_test)
str(test_data)

# concatenate train and test data

all_data <- rbind(train_data, test_data)
str(all_data)

# We have a data frame with 10299 observations and 563 variables

# STEP 2

# 2. Extract only the measurements on the mean and 
# standard deviation for each measurement. 

# We need to know where these columns are

# Name the columns
# We know from the readme that the first column is the subject, the
# second is the activity label and the other names we get from the 
# file features.

names_of_columns <- read.table("data/features.txt", stringsAsFactors = FALSE)
str(names_of_columns)
tail(names_of_columns)

# We get a dataframe with two columns. We only need the second.

names_vector <- as.vector(c("subject", "activity_label", names_of_columns$V2))
head(names_vector)

colnames(all_data) <- names_vector
str(all_data)

# now select only the columns with mean() and std() in their names


# We can use base R with grepl
# we search for column names containing the first two columns
# plus any column containing "mean" or "std"

data_mean_std <- all_data[ ,grepl("^subject|^activity_label|mean\\(|std\\(", 
                                  colnames(all_data), ignore.case = TRUE)]
str(data_mean_std)

# or we can use dplyr
# but first we have to clean the names and then make them unique
# because there are duplicates and dlpyr won't like it.


fixed_colnames <- make.names(colnames(all_data))
fixed_colnames <- make.unique(fixed_colnames)
fixed_colnames
duplicated(fixed_colnames)

library(dplyr)

data_tbl <- tbl_df(all_data)
glimpse(data_tbl)
colnames(data_tbl) <- fixed_colnames

# we should exclude columns, containing "meanFreq" and "angle", 
# because they have "mean", but not "mean()" (before fixing the 
# names). After fixing them "mean()" is followed at least by two
# points - "mean.."

data_mean_std_tbl <- select(data_tbl, starts_with("subject"),
                            starts_with("activity_label"),
                            contains("mean.."),
                            contains("std.."),
                            -contains("angle"))

# or we can use matches, which allows regular expressions
# select(data_tbl, matches("^subject|^activity|mean\\.\\.|std\\.\\.", ignore.case = FALSE))

str(data_mean_std_tbl)

# STEP 3

# Uses descriptive activity names to name the activities in 
# the data set

# We can use gsub and replace one by one or with a for loop
# or we can just set the values. The latter is shown in the
# following comments. Or we can convert the vector to factor
# and rename the factor levels. Then reassign the vector. 

# But first we will create a separate vector to work on.

# activityvector <- data_mean_std_tbl$activity_label
# head(activityvector, n = 20)
# 
# activityvector[activityvector == "1"] <- "walking"
# activityvector[activityvector == "2"] <- "walking_upstairs"
# activityvector[activityvector == "3"] <- "walking_downstairs"
# activityvector[activityvector == "4"] <- "sitting"
# activityvector[activityvector == "5"] <- "standing"
# activityvector[activityvector == "6"] <- "laying"
# 
# head(activityvector, n = 20)
# 
# activityvector <- as.factor(activityvector)
# 
# # reorder the levels without changing order of values
# # with this:
# activityvector <- factor(activityvector, 
#                           levels = c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying"))
# # and not with this:
# # levels(activityvector) <- c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying")
# # because it will change the order of the values as well
# 
# data_mean_std_tbl$activity_label <- as.factor(activityvector)

# Using factor levels:

activityvector <- data_mean_std_tbl$activity_label
activityvector <- as.factor(activityvector)
levels(activityvector) <- c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying")
levels(activityvector)
head(activityvector, n = 20)
tail(activityvector, n = 20)

data_mean_std_tbl$activity_label <- activityvector

str(data_mean_std_tbl$activity_label)
head(data_mean_std_tbl$activity_label)

# STEP 4

# 4. Appropriately label the data set with 
# descriptive variable names. 

names(data_mean_std_tbl)

str(data_mean_std_tbl)


clean_names <- names(data_mean_std_tbl)
clean_names

clean_names <- gsub("^t", "time-signals_", clean_names)
clean_names <- gsub("^f", "frequency-signals_", clean_names)
clean_names <- gsub("X$", "X-axis", clean_names)
clean_names <- gsub("Y$", "Y-axis", clean_names)
clean_names <- gsub("Z$", "Z-axis", clean_names)
clean_names <- gsub("BodyAcc", "Body-Acceleration_", clean_names)
clean_names <- gsub("GravityAcc", "Gravity-Acceleration_", clean_names)
clean_names <- gsub("Jerk", "Jerk-signals_", clean_names)
clean_names <- gsub("BodyGyro", "Body-Gyroscope-signals_", clean_names)
clean_names <- gsub("Mag", "Magnitude_", clean_names)
clean_names <- gsub("BodyBody", "Body_Body", clean_names)
clean_names <- gsub("\\.\\.\\.", "_", clean_names)
clean_names <- gsub("\\.", "", clean_names)

names(data_mean_std_tbl) <- clean_names

glimpse(data_mean_std_tbl)

# STEP 5

# 5. From the data set in step 4, creates a second, independent 
# tidy data set with the average of each variable for each 
# activity and each subject.

# create a clean dataset
# first go from wide to long

data_mean_std_tbl$subject <- as.factor(as.character(data_mean_std_tbl$subject))

library(tidyr)
data_long <- gather(data_mean_std_tbl, key = "measurement", value = "value", 3:68)
str(data_long)
glimpse(data_long)

data_long

tidy_data <- data_long %>% group_by(subject, activity_label, measurement) %>% summarise(mean(value)) 
str(tidy_data)
colnames(tidy_data)[2] <- "activity"
colnames(tidy_data)[4] <- "mean_value"

write.table(tidy_data, file = "tidy_data.txt", row.name=FALSE)
