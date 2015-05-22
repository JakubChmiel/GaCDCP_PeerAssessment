# GaCDCP_PeerAssessment
Peer Assessments /Getting and Cleaning Data Course Project


How script works:

1. It reads training and test data sets and merges them into one. train and test data set contains from 3 files(file with features, file with activity, file with subject). 
This is merged with cbind function to one data frame. After that test and train data frames are connected with rbind function to create one data set (ds)

2. Feature names file is read and features which are them mean() (without weighted means) and std() of signals are selected by using grepl function. Only selected features and activity and subject remains in the data set.

3. The file with descriptions of activities is read and numbers are replaced by names of activities.

4. All selected features get labels from features names data frame.

5. All features in data set are averaged by aggregate function. Aggregation is made for each activity and each subject. All objects in R except final data set dsAgg are being removed from environment. The final data set is written to txt file. 