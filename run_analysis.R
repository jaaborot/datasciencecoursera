# Author: Jeffrey A. Aborot

# Coursera Module 3: Getting and cleaning data Course Project

# TODOs
# 1. Create run_analysis.R
# 2. Merge the train and test data set into a single data set, dataset1.
library(dplyr)

########## set up common data ##########

# load the names of features defined in features.txt
features <- read.table(file = "./projectdata/features.txt")
# convert features$V2 from factors to characters
features$V2 <- as.character(features$V2)
features$V2[303:316] <- gsub("\\(\\)","1stSample", features$V2[303:316])
features$V2[317:330] <- gsub("\\(\\)","2ndSample", features$V2[317:330])
features$V2[331:344] <- gsub("\\(\\)","3rdSample", features$V2[331:344])
features$V2[382:395] <- gsub("\\(\\)","1stSample", features$V2[382:395])
features$V2[396:409] <- gsub("\\(\\)","2ndSample", features$V2[396:409])
features$V2[331:344] <- gsub("\\(\\)","3rdSample", features$V2[410:423])
features$V2[461:474] <- gsub("\\(\\)","1stSample", features$V2[461:474])
features$V2[475:488] <- gsub("\\(\\)","2ndSample", features$V2[475:488])
features$V2[489:502] <- gsub("\\(\\)","3rdSample", features$V2[489:502])
features$V2 <- gsub("\\(","", features$V2)
features$V2 <- gsub("\\)","", features$V2)
features$V2 <- gsub(",","", features$V2)
features$V2 <- gsub("-","", features$V2)
features$V2 <- gsub("^t", "time", features$V2)
features$V2 <- gsub("^f", "frequency", features$V2)

# load the activity names
activities <- read.table(file = "./projectdata/activity_labels.txt")

########## test data set ##########
# load the X test data
X_test <- read.table(file = "./projectdata/test/X_test.txt")
X_test_tbl <- tbl_df(X_test)

# replace the variables in X_test with the list of features defined in features.txt
names(X_test_tbl) <- features$V2

# load y test data
y_test <- read.table(file = "./projectdata/test/y_test.txt") 
y_test_tbl <- tbl_df(y_test)
# rename the variables of y_test
y_test_tbl <- rename(y_test_tbl, activity = V1)

# replace numerical indices of activities with activity names
y_test_tbl$activity <- sapply(y_test_tbl$activity, function(x){ as.character(activities$V2[match(x, activities$V1)] ) })
y_test_tbl

# append dependent variable column into the end of the
# independent variables to create a merged data set dataset1 
yX_test_tbl <- mutate(X_test_tbl, activity=y_test_tbl$activity) 
# move the dependent variable column into the first column of the dataset1 
yX_test_tbl <- yX_test_tbl[c(562, 1:561)]

# load subject_test data set
subject_test <- read.table(file = "./projectdata/test/subject_test.txt")

# append the subject data column to the last column of yX_test_tbl 
test_dataset <- mutate(yX_test_tbl, subject = subject_test$V1)
test_dataset_tbl <- tbl_df(test_dataset)

# move the subject data column to the first column of dataset1 
test_dataset_tbl <- test_dataset_tbl[c(563, 1:562)]

#### set up the inertial signals data set

# load body acceleration in the x-axis test data
body_acc_x_test <- read.table(file = "./projectdata/test/Inertial Signals/body_acc_x_test.txt") 
body_acc_x_test_tbl <- tbl_df(body_acc_x_test)
# rename the variables in body_acc_x_test
names(body_acc_x_test_tbl) <- gsub("V","bodyAccelerationXFeature", names(body_acc_x_test_tbl))

# load body acceleration in the y-axis test data
body_acc_y_test <- read.table(file = "./projectdata/test/Inertial Signals/body_acc_y_test.txt") 
body_acc_y_test_tbl <- tbl_df(body_acc_y_test)
# rename the variables in body_acc_x_test
names(body_acc_y_test_tbl) <- gsub("V","bodyAccelerationYFeature", names(body_acc_y_test_tbl))

# load body acceleration in the z-axis test data
body_acc_z_test <- read.table(file = "./projectdata/test/Inertial Signals/body_acc_z_test.txt") 
body_acc_z_test_tbl <- tbl_df(body_acc_z_test)
# rename the variables in body_acc_x_test
names(body_acc_z_test_tbl) <- gsub("V","bodyAccelerationZFeature", names(body_acc_z_test_tbl))

# load body gryo in the x-axis test data
body_gyro_x_test <- read.table(file = "./projectdata/test/Inertial Signals/body_gyro_x_test.txt") 
body_gyro_x_test_tbl <- tbl_df(body_gyro_x_test)
# rename the variables in body_gyro_x_test
names(body_gyro_x_test_tbl) <- gsub("V","bodyGyroXFeature", names(body_gyro_x_test_tbl))

# load body gryo in the y-axis test data
body_gyro_y_test <- read.table(file = "./projectdata/test/Inertial Signals/body_gyro_y_test.txt") 
body_gyro_y_test_tbl <- tbl_df(body_gyro_y_test)
# rename the variables in body_gyro_y_test
names(body_gyro_y_test_tbl) <- gsub("V","bodyGyroYFeature", names(body_gyro_y_test_tbl))

# load body gryo in the z-axis test data
body_gyro_z_test <- read.table(file = "./projectdata/test/Inertial Signals/body_gyro_z_test.txt") 
body_gyro_z_test_tbl <- tbl_df(body_gyro_z_test)
# rename the variables in body_acc_x_test
names(body_gyro_z_test_tbl) <- gsub("V","bodyGyroZFeature", names(body_gyro_z_test_tbl))

# load total acceleration in the x-axis test data
total_acc_x_test <- read.table(file = "./projectdata/test/Inertial Signals/total_acc_x_test.txt") 
total_acc_x_test_tbl <- tbl_df(total_acc_x_test)
# rename the variables in body_acc_x_test
names(total_acc_x_test_tbl) <- gsub("V","totalAccelerationXFeature", names(total_acc_x_test_tbl))

# load total acceleration in the y-axis test data
total_acc_y_test <- read.table(file = "./projectdata/test/Inertial Signals/total_acc_y_test.txt") 
total_acc_y_test_tbl <- tbl_df(total_acc_y_test)
# rename the variables in body_acc_y_test
names(total_acc_y_test_tbl) <- gsub("V","totalAccelerationYFeature", names(total_acc_y_test_tbl))

# load total acceleration in the z-axis test data
total_acc_z_test <- read.table(file = "./projectdata/test/Inertial Signals/total_acc_z_test.txt") 
total_acc_z_test_tbl <- tbl_df(total_acc_z_test)
# rename the variables in body_acc_z_test
names(total_acc_z_test_tbl) <- gsub("V","totalAccelerationZFeature", names(total_acc_z_test_tbl))

# bind the columns of the inertial signals data set
inertial_signals_test_dataset <- cbind(body_acc_x_test_tbl, 
                                  body_acc_y_test_tbl, 
                                  body_acc_z_test_tbl, 
                                  body_gyro_x_test_tbl, 
                                  body_gyro_y_test_tbl, 
                                  body_gyro_z_test_tbl, 
                                  total_acc_x_test_tbl, 
                                  total_acc_y_test_tbl, 
                                  total_acc_z_test_tbl)

########## train data set ##########
# load the X test data
X_train <- read.table(file = "./projectdata/train/X_train.txt")
X_train_tbl <- tbl_df(X_train)

# replace the variables in X_train with the list of features defined in features.txt
names(X_train_tbl) <- features$V2

# load y train data set
y_train <- read.table(file = "./projectdata/train/y_train.txt") 
y_train_tbl <- tbl_df(y_train)
# rename the variables of y_test
y_train_tbl <- rename(y_train_tbl, activity = V1)

# replace numerical indices of activities with activity names
y_train_tbl$activity <- sapply(y_train_tbl$activity, function(x){ as.character(activities$V2[match(x, activities$V1)] ) })
y_train_tbl

# append dependent variable column into the end of the
# independent variables to create a merged data set dataset1 
yX_train_tbl <- mutate(X_train_tbl, activity=y_train_tbl$activity) 
# move the dependent variable column into the first column of the dataset1 
yX_train_tbl <- yX_train_tbl[c(562, 1:561)]

# load subject_test data set
subject_train <- read.table(file = "./projectdata/train/subject_train.txt")

# append the subject data column to the last column of yX_test_tbl 
train_dataset <- mutate(yX_train_tbl, subject = subject_train$V1)
train_dataset_tbl <- tbl_df(train_dataset)

# move the subject data column to the first column of dataset1 
train_dataset_tbl <- train_dataset_tbl[c(563, 1:562)]

#### set up the inertial signals data set

# load body acceleration in the x-axis train data
body_acc_x_train <- read.table(file = "./projectdata/train/Inertial Signals/body_acc_x_train.txt") 
body_acc_x_train_tbl <- tbl_df(body_acc_x_train)
# rename the variables in body_acc_x_train
names(body_acc_x_train_tbl) <- gsub("V","bodyAccelerationXFeature", names(body_acc_x_train_tbl))

# load body acceleration in the y-axis train data
body_acc_y_train <- read.table(file = "./projectdata/train/Inertial Signals/body_acc_y_train.txt") 
body_acc_y_train_tbl <- tbl_df(body_acc_y_train)
# rename the variables in body_acc_x_train
names(body_acc_y_train_tbl) <- gsub("V","bodyAccelerationYFeature", names(body_acc_y_train_tbl))

# load body acceleration in the z-axis train data
body_acc_z_train <- read.table(file = "./projectdata/train/Inertial Signals/body_acc_z_train.txt") 
body_acc_z_train_tbl <- tbl_df(body_acc_z_train)
# rename the variables in body_acc_x_train
names(body_acc_z_train_tbl) <- gsub("V","bodyAccelerationZFeature", names(body_acc_z_train_tbl))

# load body gryo in the x-axis train data
body_gyro_x_train <- read.table(file = "./projectdata/train/Inertial Signals/body_gyro_x_train.txt") 
body_gyro_x_train_tbl <- tbl_df(body_gyro_x_train)
# rename the variables in body_gyro_x_train
names(body_gyro_x_train_tbl) <- gsub("V","bodyGyroXFeature", names(body_gyro_x_train_tbl))

# load body gryo in the y-axis train data
body_gyro_y_train <- read.table(file = "./projectdata/train/Inertial Signals/body_gyro_y_train.txt") 
body_gyro_y_train_tbl <- tbl_df(body_gyro_y_train)
# rename the variables in body_gyro_y_train
names(body_gyro_y_train_tbl) <- gsub("V","bodyGyroYFeature", names(body_gyro_y_train_tbl))

# load body gryo in the z-axis train data
body_gyro_z_train <- read.table(file = "./projectdata/train/Inertial Signals/body_gyro_z_train.txt") 
body_gyro_z_train_tbl <- tbl_df(body_gyro_z_train)
# rename the variables in body_acc_x_train
names(body_gyro_z_train_tbl) <- gsub("V","bodyGyroZFeature", names(body_gyro_z_train_tbl))

# load total acceleration in the x-axis train data
total_acc_x_train <- read.table(file = "./projectdata/train/Inertial Signals/total_acc_x_train.txt") 
total_acc_x_train_tbl <- tbl_df(total_acc_x_train)
# rename the variables in body_acc_x_train
names(total_acc_x_train_tbl) <- gsub("V","totalAccelerationXFeature", names(total_acc_x_train_tbl))

# load total acceleration in the y-axis train data
total_acc_y_train <- read.table(file = "./projectdata/train/Inertial Signals/total_acc_y_train.txt") 
total_acc_y_train_tbl <- tbl_df(total_acc_y_train)
# rename the variables in body_acc_y_train
names(total_acc_y_train_tbl) <- gsub("V","totalAccelerationYFeature", names(total_acc_y_train_tbl))

# load total acceleration in the z-axis train data
total_acc_z_train <- read.table(file = "./projectdata/train/Inertial Signals/total_acc_z_train.txt") 
total_acc_z_train_tbl <- tbl_df(total_acc_z_train)
# rename the variables in body_acc_z_train
names(total_acc_z_train_tbl) <- gsub("V","totalAccelerationZFeature", names(total_acc_z_train_tbl))

# bind the columns of the inertial signals data set

inertial_signals_train_dataset <- cbind(
                                  body_acc_x_train_tbl, 
                                  body_acc_y_train_tbl, 
                                  body_acc_z_train_tbl, 
                                  body_gyro_x_train_tbl, 
                                  body_gyro_y_train_tbl, 
                                  body_gyro_z_train_tbl, 
                                  total_acc_x_train_tbl, 
                                  total_acc_y_train_tbl, 
                                  total_acc_z_train_tbl)

# bind the rows of the inertial signals test and train data sets
inertial_signals_dataset <- rbind(inertial_signals_train_dataset, inertial_signals_test_dataset)

#### row-bind the train and test data set
train_test_dataset <- rbind(train_dataset_tbl, test_dataset_tbl)

#### colum-bind the train and test data set with the inertial signals data set
tidy_dataset1 <- cbind(train_test_dataset, inertial_signals_dataset)

# 3. Extract the mean and standard deviation for each measurement in tidy_dataset1.
tidy_dataset1_means <- lapply(tidy_dataset1[,3:1715], mean)
tidy_dataset1_sd <- lapply(tidy_dataset1[,3:1715], sd)

# 4. Label the dataset1 with descriptive variable names.
# done in the previous lines

# 5. Create a second tidy dataset, dataset2, from dataset1 with the additional data of average of each variable for each activity and each subject.
tidy_dataset2 <- group_by(tidy_dataset1, activity, subject)
for(i in 3:1715){
    colname <- paste0("mean", names(tidy_dataset2[i]))
    tidy_dataset2[[colname]] <- mean(tidy_dataset2[[i]])
}