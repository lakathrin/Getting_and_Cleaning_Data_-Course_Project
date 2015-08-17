#set working directory
setwd("C:/Users/Kathrin/Desktop/Coursera")

#download file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "SamAcc.zip")

#unzip files
unzip("SamAcc.zip")

#read files

        ##read activity labels
        setwd("C:/Users/Kathrin/Desktop/Coursera/UCI HAR Dataset")
        activitylabels <- read.table("activity_labels.txt")

                ###get names of activities in vector
                activitylabels <- activitylabels$V2
                activitylabels <- as.vector(activitylabels)

        ##read columnlabels
        setwd("C:/Users/Kathrin/Desktop/Coursera/UCI HAR Dataset")
        columnlabels <- read.table("features.txt")

        ##read training data and assign columnnames
        setwd("C:/Users/Kathrin/Desktop/Coursera/UCI HAR Dataset/train")
        traindata <- read.table("X_train.txt")
        colnames(traindata) <- columnlabels[,2]

                ###read activity labels for training data and assign column name
                trainactivity <- read.table("y_train.txt")
                colnames(trainactivity) <- "activity"

                ###read subject data for training data and assign column name
                trainsubject <- read.table("subject_train.txt")
                colnames(trainsubject) <- "subject"

                        ####combine datasets into one dataframe
                        trainsubact <- cbind2(trainsubject,trainactivity)
                        fulltrainingdata <- cbind2(trainsubact, traindata)

        ##read test data and assign columnnames
        setwd("C:/Users/Kathrin/Desktop/Coursera/UCI HAR Dataset/test")
        testdata <- read.table("X_test.txt")
        colnames(testdata) <- columnlabels[,2]
        
                ###read activity labels for test data and assign column name
                testactivity <- read.table("y_test.txt")
                colnames(testactivity) <- "activity"
        
                ###read subject data for test data and assign column name
                testsubject <- read.table("subject_test.txt")
                colnames(testsubject) <- "subject"

                        ####combine datasets into one dataframe
                        testsubact <- cbind2(testsubject,testactivity)
                        fulltestdata <- cbind2(testsubact, testdata)

#merge datasets
fulldata<-rbind(fulltestdata,fulltrainingdata)

#extract comlumn with mean and sd of data
toMatch <- c("mean","std")
fulldata_meanSD<- fulldata[,c(1,2,grep(paste(toMatch, collapse = "|"), colnames(fulldata)))]

#replace activity ID numbers by corresponding character string
for (i in 1:length(activitylabels)) {
        fulldata_meanSD$activity <- gsub(i, activitylabels[i], fulldata_meanSD$activity)
        }

#calculate mean of data per subject and activity
library(plyr)
tidydata <- ddply(fulldata_meanSD, .(subject, activity), numcolwise(mean))

#write tidy data as txt file
setwd("C:/Users/Kathrin/Desktop/Coursera")
write.table(tidydata, file = "tidydata.txt", row.names = FALSE)