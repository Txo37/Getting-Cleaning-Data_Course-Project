## READING FILES

# Features:
features<- read.table("C:/Users/txomi/Documents/Week4/UCI HAR Dataset/features.txt")
View(features)
dim(features) #561 2

# Activity Labels:
activity_labels<- read.table("C:/Users/txomi/Documents/Week4/UCI HAR Dataset/activity_labels.txt")
View(activity_labels)
dim(activity_labels) #6 2
head(activity_labels)

# Train Data:
subject_train<- read.table("C:/Users/txomi/Documents/Week4/UCI HAR Dataset/train/subject_train.txt")
X_train<- read.table("C:/Users/txomi/Documents/Week4/UCI HAR Dataset/train/X_train.txt")
Y_train<- read.table("C:/Users/txomi/Documents/Week4/UCI HAR Dataset/train/Y_train.txt")
dim(subject_train) #7352 1
dim(X_train) #7352 561
dim(Y_train) #7352 1


# Test Data:
subject_test<- read.table("C:/Users/txomi/Documents/Week4/UCI HAR Dataset/test/subject_test.txt")
X_test<- read.table("C:/Users/txomi/Documents/Week4/UCI HAR Dataset/test/X_test.txt")
Y_test<- read.table("C:/Users/txomi/Documents/Week4/UCI HAR Dataset/test/Y_test.txt")
dim(subject_test) #2947 1
dim(X_test) #2947 561
dim(Y_test) #2947 1


## 1. Merge the training and the test sets to create one data set
datasubject<- rbind(subject_train, subject_test)
datax<- rbind(X_train, X_test)
datay<- rbind(Y_train, Y_test)
str(datasubject)
str(datax)
str(datay)
data<- cbind(datax, datasubject, datay) # Merge total columns.
dim(data) # 10299 563


## 2. Extract only the measurements on the mean and standard deviation for each measurement.
data1<- datax[, grep("-mean\\(\\)|-std\\(\\)", features[, 2])]
names(data1)<- features[grep("-mean\\(\\)|-std\\(\\)", features[, 2]), 2]
View(data1)
dim(data1)

## 3. Uses descriptive activity names to name the activities in the data set
datay[, 1] <- activity_labels[datay[, 1], 2]
names(datay) <- "Activity"
View(datay)

## 4. Appropriately labels the data set with descriptive variable names. 
names(datasubject)<- "Subject"
View(datasubject)
Data<- cbind(data1, datay, datasubject) #turning datasets into one
dim(Data) # 10299 68

names(Data) <- make.names(names(Data)) # renaming columns
names(Data) <- gsub("^t","TimeDomain.", names(Data))
names(Data) <- gsub("^f","FrequencyDomain.", names(Data))
names(Data) <- gsub("Acc", "Acceleration", names(Data))
names(Data) <- gsub('GyroJerk',"AngularAcceleration", names(Data))
names(Data) <- gsub('Gyro',"AngularSpeed", names(Data))
names(Data) <- gsub('Mag',"Magnitude", names(Data))
names(Data) <- gsub('\\.mean',".Mean", names(Data))
names(Data) <- gsub('\\.std',".StandardDeviation", names(Data))
names(Data) <- gsub('Freq\\.',"Frequency.", names(Data))
names(Data) <- gsub('Freq$',"Frequency", names(Data))
names(Data)
View(Data) # OK

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Data1<-aggregate(. ~Subject + Activity, Data, mean)
Data1<-Data1[order(Data1$Subject,Data1$Activity),]
write.table(Data1, file = "tidydata.txt",row.name=FALSE)


