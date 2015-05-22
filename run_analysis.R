
#############
# 1. Merging the training and the test sets to create one data set.
#############

  # reading train  data sets
  Xtrain <- read.table('UCI HAR Dataset/train/X_train.txt', header=F)
  Ytrain <- read.table('UCI HAR Dataset/train/Y_train.txt', header=F,col.names='activity')
  subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt', header=F,col.names='subject')
  # merging train data 
  train <- cbind(Xtrain,subject_train,Ytrain)
  
  
  # reading test  data sets
  Xtest <- read.table('UCI HAR Dataset/test/X_test.txt', header=F)
  Ytest<- read.table('UCI HAR Dataset/test/Y_test.txt', header=F,col.names='activity')
  subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt', header=F,col.names='subject')
  # merging test data 
  test<- cbind(Xtest,subject_test,Ytest)
  
  # creating one data set from train and test 
  ds <- rbind(train,test)


#############
# 2. Extracting only the measurements on the mean and standard deviation for each measurement. 
#############

  ## reading features names 
  features <- read.table('UCI HAR Dataset/features.txt', header=F,col.names=c('nr','name'))

  ## finding features which labels that include mean() and std(). It does not include meanFreq(). 
  featuresMean <- grepl('mean[[:punct:]]', features$name)
  featuresStd <- grepl('std[[:punct:]]', features$name)
  featuresExtracted <- features$nr[featuresMean|featuresStd]
  
  ## creating new data set with extracted features 
  #finding numbers for subject and activity
  subAct <- c(match('subject',names(ds)),match('activity',names(ds)))
  
  ds <- ds[,c(featuresExtracted,subAct)]

#############
# 3. Uses descriptive activity names to name the activities in the data set 
#############

  ## reading activity labels
  activityLabels <- read.table('UCI HAR Dataset/activity_labels.txt', header=F,col.names=c('activity','activityLabel'))
 
  ## merging data set to activity labels by activity number 
  ds <- merge(ds,activityLabels, by=c('activity'))
  
  ## replacing activity variable with labels
  ds$activity <- as.factor(ds$activityLabel)
  
  ## deleting redundant variable ("activityLabel")
  ds <- ds[,-match('activityLabel',names(ds))]


############
# 4. Appropriately labels the data set with descriptive variable names. 
#############
  
  ## getting names from extracted features
  featuresNames <- as.character(features$name[featuresExtracted])

  #finding numbers for subject and activity
  subAct <- c(match('subject',names(ds)),match('activity',names(ds)))

  ## labels variables with extracted features names
  colnames(ds)[-subAct] <- featuresNames

#############
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#############

  ## aggregating data by subject and activity
  dsAgg <- aggregate(. ~ subject + activity,data = ds, mean)


  ## removing every file instead of the tidy data set
  rm(list=setdiff(ls(), "dsAgg"))

  ## saving tidy data sret
  write.table(dsAgg, 'dsAgg.txt',row.names = F)
