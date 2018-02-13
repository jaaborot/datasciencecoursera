# README

## Introduction

This repository contains the project sources for the Coursera course **Module 3: Getting and Cleaning Data**: _Data, Connetivity and Intelligence: Data Science Track_. Within the top directory, you will find the **run_analysis.R** file for tidying the given input data set in the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). Given that the project input data set is in the same directory, executing the run_analysis.R script file will generate a tidy data set written in a  **tidy_dataset.txt** file. A [codebook](https://github.com/jaaborot/datasciencecoursera/blob/master/CodeBook.md) is also provided in the top level directory of this repository. The codebook provides some details about the input data set, the variables included in an intermediate data set taken from the set of variables of the input data set, and the variables of the final tidy data set.

## Cleaning process

In this section we discuss about the cleaning process applied to the input data set to generate the output tidy data set. We go through each step in the cleaning process by going through sections the in run\_analysis.R script.

### Loading necessary libraries
For easy manipulation of the input data set, we load the ```dplyr``` R package.

```library(dplyr)```

### Setting up common data
The input data set is divided into a training data set (X_train.txt, y_train.txt) and test data set (X_test.txt, y_test.txt). These data sets share the same variables defined in the features.txt file. We load the list of variables from  features.txt into an object in R and convert the list of variable names from a list of factors into a list of characters.

```
features <- read.table(file = "./projectdata/features.txt")
features$V2 <- as.character(features$V2)
```

We then convert the variable names into a cleaner format.

```
features$V2 <- gsub("\\(","", features$V2)
features$V2 <- gsub("\\)","", features$V2)
features$V2 <- gsub(",","", features$V2)
features$V2 <- gsub("-","", features$V2)
features$V2 <- gsub("^t", "time", features$V2)
features$V2 <- gsub("^f", "frequency", features$V2)
```

We also load the list of activity labels from activity_labels.txt into an object in R for later processing.

```activities <- read.table(file = "./projectdata/activity_labels.txt")```

### Identification of relevant variables

We then identify the variable names which correspond to the mean and standard deviation measurements on the captured tri-axial values in the input data set. We do so by using regular expression for identifying such variable names in the list of variable names derived from the previous step. To find the columns for the mean and standard deviation measurements, we use the ```grep(.)``` function with the input pattern of "\[Mm\]ean" and "\[Ss\]td" applied to the list of variables. However, there are variable names which contain the word "mean" but does not correspond to a mean measurement. Such specific variables are those for computing the angle between two vectors, e.g. ```angle(tBodyAccMean,gravity), angle(tBodyAccJerkMean),gravityMean),..., angle(Z,gravityMean)```, and the mean frequency, e.g. ```fBodyAcc-meanFreq()-X, fBodyAcc-meanFreq()-Y, fBodyAcc-meanFreq()-Z```. We implement these considerations in the following R snippet:

```
mean_cols <- grep("[Mm]ean", features$V2)
std_cols <- grep("[Ss]td", features$V2)
meanFreq_cols <- grep("meanFreq", features$V2)
angle_cols <- grep("angle", features$V2)
mean_std_cols <- setdiff(sort(c(mean_cols, std_cols)), c(angle_cols, meanFreq_cols))
```

The objects ```mean_cols```, ```std_cols```, ```meanFreq_cols```, ```angle_cols```, and ```mean_std_cols``` are all list of indices of variable names. ```mean_cols``` is a list of all variable names which have an occurrence of the pattern ```[Mm]ean```. ```std_cols``` is a list of all variable names which have an occurrence of the pattern ```[Ss]td```. ```meanFreq_cols``` is a list of variable names corresponding to the computed mean frequency value while ```angle_cols``` is a list of variable names which have an occurrence of the pattern ```angle```. The list of indices of variable names which are only relevant to the goal in the course project is computed using the set difference between ```mean_cols``` union ```std_cols``` and ```meanFreq_cols``` union ```angle_cols```. This list is computed using the ```setdiff(.)``` function in R and is assigned to the ```mean_std_cols``` object.

## Loading the test data set
In order to load the test data set, we need to load the contents of X_test.txt, y_test.txt, and subject_test.txt.

X_test is loaded into a data frame using the ```read.table(.)``` function in the ```utils``` package. Only the relevant columns are loaded into the data frame by limiting the columns of X_test into the variable indices defined in ```mean_std_cols``` list.

```
X_test <- read.table(file = "./projectdata/test/X_test.txt")
X_test <- X_test[, sort(mean_std_cols)]
X_test_tbl <- tbl_df(X_test)
```

The variable names in X\_test data frame are replaced with the tidy variable names from the ```features``` list.

```
names(X_test_tbl) <- features$V2[sort(sort(mean_std_cols))]
```

Likewise, y\_test is loaded into a data frame using the ```read.table(.)``` function. We also rename the variable name in y\_test into "activity" since the values in y\_test correspond to the activity labels for each observation in X\_test.

```
y_test <- read.table(file = "./projectdata/test/y_test.txt") 
y_test_tbl <- tbl_df(y_test)
y_test_tbl <- rename(y_test_tbl, activity = V1)
```

We replace the activity indices in y\_test with their corresponding activity labels (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) from the ```activities``` object defined in the first steps.

```
y_test_tbl$activity <- sapply(y_test_tbl$activity, function(x){ as.character(activities$V2[match(x, activities$V1)] ) })
```

We then combine y\_test with X\_test to attach to the observations in X\_test their corresponding activity labels in y\_test. We implement this using the ```mutate(.)``` function in the ```dplyr``` package.

```
yX_test_tbl <- mutate(X_test_tbl, activity = y_test_tbl$activity) 
```

We move the column for the activity variable into the first column of the combined test data set ```yX\_test```.

```
yX_test_tbl <- yX_test_tbl[c(dim(yX_test_tbl)[2], 1:dim(yX_test_tbl)[2]-1)]
```

We also load the corresponding subject data into each observation in ```yX_test_tbl``` from the subjects\_test.txt file.

```
subject_test <- read.table(file = "./projectdata/test/subject_test.txt")
```

Lastly, we attach the subject data into ```yX_test_tbl``` data frame to complete the whole test data set which we denote as ```test_dataset_tbl```.

```
test_dataset <- mutate(yX_test_tbl, subject = subject_test$V1)
test_dataset_tbl <- tbl_df(test_dataset)
```

We also move the column for the subject variable into the first column of ```test_dataset_tbl```.

```
test_dataset_tbl <- test_dataset_tbl[c(dim(test_dataset_tbl)[2], 1:dim(test_dataset_tbl)[2]-1)]
```

## Loading the training data set

For the training data set, we exactly do the same with what we did with the test data set. In this case, we load the data from the X\_train.txt, y\_train.txt and subject\_train.txt files.

```
X_train <- read.table(file = "./projectdata/train/X_train.txt")
X_train <- X_train[, mean_std_cols]
X_train_tbl <- tbl_df(X_train)

names(X_train_tbl) <- features$V2[sort(mean_std_cols)]

y_train <- read.table(file = "./projectdata/train/y_train.txt") 
y_train_tbl <- tbl_df(y_train)
y_train_tbl <- rename(y_train_tbl, activity = V1)

y_train_tbl$activity <- sapply(y_train_tbl$activity, function(x){ as.character(activities$V2[match(x, activities$V1)] ) })

yX_train_tbl <- mutate(X_train_tbl, activity = y_train_tbl$activity) 
yX_train_tbl <- yX_train_tbl[c(dim(yX_train_tbl)[2], 1:dim(yX_train_tbl)[2]-1)]

subject_train <- read.table(file = "./projectdata/train/subject_train.txt")

train_dataset <- mutate(yX_train_tbl, subject = subject_train$V1)
train_dataset_tbl <- tbl_df(train_dataset)

train_dataset_tbl <- train_dataset_tbl[c(dim(train_dataset_tbl)[2], 1:dim(train_dataset_tbl)[2]-1)]
```

## Combining the training and test data set

To construct the intermediate data set, we combine the rows of the training data set and the test data set. We do so by using the ```rbind(.)``` function from the base R package with the train\_dataset\_tbl and test\_dataset\_tbl data frames as input. The resulting data frame is assigned to a new data frame train\_test\_dataset.

```
train_test_dataset <- rbind(train_dataset_tbl, test_dataset_tbl)
```

## Generating the tidy data

The variables of the tidy data set which will be generated correspond to the average of the variables in the generated ```train_test_dataset``` data frame. To construct such data set, we use the ```aggregate(.)``` function of the ```stats``` package in R. We specify as input into the ```aggregate``` function the 3rd up to the last column of the ```train_test_dataset```, the ```activity``` and ```subject``` variables of the ```train_test_dataset``` data frame as grouping elements of the averages, and the ```mean(.)``` function of the base R package as the function to be applied to the variables in ```train_test_dataset```.

```r
tidy_dataset <- aggregate(train_test_dataset[, 3:dim(train_test_dataset)[2]], list(train_test_dataset$activity, train_test_dataset$subject), mean)
```

<!--

########## construct the test data set out of X_test, y_test, activity and subject ##########


########## construct the train data set out of X_train, y_train, activity and subjects ##########


# 4. Label the dataset1 with descriptive variable names.
# done in the previous lines

# 5. Create a second tidy dataset, dataset2, from dataset1 with the additional data of average of each variable for each activity and each subject.
# train_test_dataset_gby <- group_by(train_test_dataset, activity, subject)

######## Step 5 ########
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# tidy the name of each variable
names(tidy_dataset)[1] <- 'activity'
names(tidy_dataset)[2] <- 'subject'
names(tidy_dataset)[3:length(names(tidy_dataset))] <- paste0(toupper(substring(names(tidy_dataset)[3:length(names(tidy_dataset))], 1, 1)), substring(names(tidy_dataset)[3:length(names(tidy_dataset))], 2, nchar(names(tidy_dataset)[3:length(names(tidy_dataset))])))
names(tidy_dataset)[3:length(names(tidy_dataset))] <- paste0("avg", names(tidy_dataset)[3:length(names(tidy_dataset))])

# compute for the average of each variable
# for(i in 3:dim(train_test_dataset_gby)[2]){
#     colname <- paste0("avg", names(train_test_dataset_gby)[i])
#     train_test_dataset_gby[[colname]] <- mean(train_test_dataset_gby[[i]])
# }

# create a tidy data set out of the computed average of the mean and standard deviation variables
# tidy_dataset <- train_test_dataset_gby[, (length(mean_std_cols) + 2 + 1): dim(train_test_dataset_gby)[2]]

# write the tidy data set into file
write.table(tidy_dataset, file = "tidy_dataset.txt", row.names = FALSE)
write.table(names(tidy_dataset), file = "names_tidy_dataset.txt")

-->
