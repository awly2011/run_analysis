# Dataset has been downloaded into the local file "UCIHARDataset"
# Set work directory
setwd("C:/Users/awl_y/Desktop/R-chuanfu/class3/Finalproject/UCIHARDataset")

# Read "test" file data set
test_subject <- read.table("./test/subject_test.txt")
test_activities <- read.table("./test/y_test.txt")
test_data <- read.table("./test/X_test.txt")
test_set <- cbind(test_subject, test_activities, test_data)

# Read "train" file data set
train_subject <- read.table("./train/subject_train.txt")
train_activities <- read.table("./train/y_train.txt")
train_data <- read.table("./train/X_train.txt")
train_set <- cbind(train_subject, train_activities, train_data)

# Merge "test" and "train" data sets together
test_train <- rbind(test_set, train_set)
##################Step 1 finished#####################################


# Read features
features <- read.table("features.txt")

# Change the features to character
features_characters <- as.character(features[[2]])


# Create a vector to rename the merged data set names
descriptive_names <- c("Subject", "Activity", features_characters)

# Rename the merged data set
names(test_train) <- descriptive_names

# Order the merged data set based on subject and activities
test_train <- test_train[order(test_train$Subject, test_train$Activity),]

# Extract the mean and std for each measurments
variable_names <- names(test_train)
goodmatch <- grep("mean|std", variable_names)
goodmatch <- c(c(1, 2), goodmatch)
test_train <- test_train[goodmatch]
##################Step 2 finished#####################################


# Label the activity names
activity_labels <- read.table("activity_labels.txt")
test_train$Activity <- factor(test_train$Activity, levels = activity_labels[[1]], labels = activity_labels[[2]])
##################Step 3 finished#####################################


# Rename the variable names appropriately
names(test_train) <- gsub("-", "", names(test_train))
names(test_train) <- gsub("()", "", names(test_train))
names(test_train) <- gsub("mean", "Mean", names(test_train))
names(test_train) <- gsub("std", "Std", names(test_train))
##################Step 4 finished#####################################

# Melt the data, and recast the data which is calculated by mean function
test_train$Subject <- as.factor(test_train$Subject)
test_train_melt <- melt(test_train, id = c("Subject","Activity"))
test_train_mean <- dcast(test_train_melt, Subject + Activity ~ variable, mean)
##################Step 5 finished#####################################


# Output the tidy data
write.table(test_train_mean, "Tidy data.txt", quote = FALSE, row.names = FALSE)

