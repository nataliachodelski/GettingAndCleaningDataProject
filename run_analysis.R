# This R script downloads a data set and 
# processes it by doing the following. 
#
# 1) Merges the training and the test sets from the downloaded data to create one data set.
# 2) It extracts only the measurements on the mean and standard deviation for each measurement. 
# 3) It applies descriptive activity names to name the activities in the data set
# 4) It labels the data set with descriptive variable names. 
# 5) From the data set in step 4 above, it creates a tidy data set with the average of each variable for each activity and each subject.




################################################
#########   LOAD LIBRARIES  ####################
################################################
################################################

library(data.table) # This is needed for data table operations
library(reshape2) # this is needed for melting the data



################################################
#########   GET THE DATA  ######################
################################################
################################################  

#url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#zipfile <- "mydataset.zip"
#if (!file.exists(zipfile)){
#  download.file(url, zipfile)
#}
#if(!file.exists("UCI HAR Dataset")){
#  unzip(zipfile)
#}



################################################
#########  LOAD THE DATA  ######################
#########  INTO VALUES  ########################
################################################

# Read in the subject indexes that correspond
# to the rows of the actual X_* data
SubjectTrainDataTable <- fread("UCI HAR Dataset/train/subject_train.txt")
SubjectTestDataTable  <- fread("UCI HAR Dataset/test/subject_test.txt" )

# Read in the activity indexes that correspond
# to the rows of the actual X_* data
ActivityTrainDataTable <- fread("UCI HAR Dataset/train/Y_train.txt")
ActivityTestDataTable  <- fread("UCI HAR Dataset/test/Y_test.txt" )

# Read in the actual X_* data
TrainData <- data.table(read.table("UCI HAR Dataset/train/X_train.txt"))
TestData <- data.table(read.table("UCI HAR Dataset/test/X_test.txt"))


# Read in the Features that will be the
# column names of the actual X_* data
FeaturesData <- fread("UCI HAR Dataset/features.txt") 

# Give the Features Data better column names
setnames(FeaturesData, names(FeaturesData), c("featurenumber", "featurename"))



################################################
#########       ONE        #####################
# Merges the training and the test sets from   #
# the downloaded data to create one data set.  #
################################################
################################################

# Union the subject indexes
SubjectDataTable <- rbind(SubjectTrainDataTable, SubjectTestDataTable)

# give the subject data a better column name 
setnames(SubjectDataTable, "V1", "Subject")

# Union the activity indexes
ActivityDataTable <- rbind(ActivityTrainDataTable, ActivityTestDataTable)

# give the activity data a better column name 
setnames(ActivityDataTable, "V1", "ActivityNumber")

# Create the composite data table, and Union
# the actual X_* data into it
dt <- rbind(TrainData, TestData)

# Merge the columns of the subject data, the
# activity data, and the actual X_* data
dt <- cbind(SubjectDataTable, ActivityDataTable, dt)

# Rename the dt columns with the names from the features data table
setnames(dt,names(dt),c(colnames(dt)[1],colnames(dt)[2],FeaturesData$featurename))



################################################
##########    TWO     ##########################
################################################
# Extracts only the measurements on the mean   # 
# and standard deviation for each measurement. # 
################################################
################################################

# get the indexes of the columns where the
# column has mean() or std() in the name
colnums <- which(names(dt) %in% c("Subject","ActivityNumber",grep("mean\\(\\)|std\\(\\)",names(dt),value=TRUE)))

# Convert to dataframe to get all rows where the
# column number is one of colnums calculated
# above, then convert back to data table
dt <- data.table(as.data.frame.matrix(dt)[,colnums])



################################################
##########    THREE   ##########################
################################################
# Uses descriptive activity names to name the  #
# activities in the data set                   #
################################################
################################################

#  Read activity_labels.txt file.
ActivityNamesDataTable <- fread("UCI HAR Dataset/activity_labels.txt")
setnames(ActivityNamesDataTable, names(ActivityNamesDataTable), c("ActivityNumber", "ActivityName"))

# join dt to activity names on the activity 
# number column
dt <- merge(dt, ActivityNamesDataTable, by="ActivityNumber")

# drop extraneous column ActivityNumber
dt <- dt[,ActivityNumber:=NULL]



################################################
##########    FOUR    ##########################
################################################
# Appropriately labels the data set with       #
# descriptive  variable names.                 #
################################################
################################################

# substitute partial names to more meaningful
# names
options(warn=-1)
names(dt) <- sub("^t","Time",names(dt))
names(dt) <- sub("^f","Frequency",names(dt))
names(dt) <- sub("Gyro","Gyroscope",names(dt))
names(dt) <- sub("Acc","Acceleration",names(dt))
names(dt) <- sub("Mag","Magnitude",names(dt))
names(dt) <- sub("mean\\(\\)","Mean",names(dt))
names(dt) <- sub("std\\(\\)","StandardDeviation",names(dt))
names(dt) <- sub("-X","XAxis",names(dt))
names(dt) <- sub("-Y","YAxis",names(dt))
names(dt) <- sub("-Z","ZAxis",names(dt))
names(dt) <- sub("-","",names(dt))
options(warn=0)



################################################
##########    FIVE    ##########################
################################################
# From the data set in step 4, creates a       #
# second, independent tidy data set with the   #
# average of each variable for each activity   #
# and each subject.                            #
################################################
################################################

# MELT THIS DATA TABLE SO IT IS EASIER TO READ 
# AND EASIER TO GROUP AND AVERAGE IN STEP 5 BELOW
tidydt <- melt(dt, id.vars = c("Subject", "ActivityName"))

# set keys for ordering and quicker performance
setkey(tidydt,Subject,ActivityName,variable)

# group on, and calculate the mean for the value of, 
# each subject/activity/variable group
tidydt <- tidydt[, lapply(.SD,mean), by=list(Subject,ActivityName,variable)] 



################################################
##########    WRITE TABLE  #####################
################################################

# write the table to a file
write.table(tidydt,file="data.txt", quote=FALSE, row.name=FALSE)





print("COMPLETE!")




