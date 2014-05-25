# download database and unzip
#download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',destfile='Dataset.zip', method="curl")
#unzip("Dataset.zip")

# Read dataset
Xtrain = read.table("UCI HAR Dataset/train/X_train.txt")
Strain = read.table("UCI HAR Dataset/train/subject_train.txt")
Ytrain = read.table("UCI HAR Dataset/train/Y_train.txt")

Xtest = read.table("UCI HAR Dataset/test/X_test.txt")
Stest = read.table("UCI HAR Dataset/test/subject_test.txt")
Ytest = read.table("UCI HAR Dataset/test/Y_test.txt")

# 1. Merges the training and the test sets to create one data set.
X = rbind(Xtrain,Xtest)
S = rbind(Strain,Stest)
Y = rbind(Ytrain,Ytest)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement
selected_features = read.table("selected-features.txt",col.names=c("columns","measure"))
Xselected = X[,selected_features$columns]
names(Xselected) = selected_features$measure

# 3. Uses descriptive activity names to name the activities in the data set
activities = c('WALKING','WALKING_UPSTAIRS','WALKING_DOWNSTAIRS','SITTING','STANDING','LAYING')

# 4. Appropriately labels the data set with descriptive activity names.
Yf = factor(Y[,1],labels=activities)
data = cbind(Xselected,data.frame(activity=Yf))

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
names(S) = c("subject")
data = cbind(data,S)
tidy = aggregate(data[,1:63],by=list(paste(data$subject,data$activity)),mean)
write.table(tidy,file="tidy.txt")
