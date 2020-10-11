### The zip files for the project can be downloaded from the following URL:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## From the folder where the unzipped files are located:

My.testx <- read.table("X_test.txt")
My.testy <- read.table("Y_test.txt")
My.trainx <- read.table("x_train.txt")
My.trainy <- read.table("y_train.txt")
My.subtest <- read.table("subject_test.txt")
My.subtrain <- read.table("subject_train.txt")
My.features <- read.table("features.txt")
My.activity <- read.table("activity_labels.txt")

  
##Add columns to subject tables
My.subtrain <- mutate(My.subtrain,Class="Train")
My.subtest <- mutate(My.subtest,Class="Test")


##Rename columns in the subject files
colnames(My.subtest) <- c("Subject","Class")
colnames(My.subtrain) <- c("Subject","Class")

##Build features table with more descriptive names
My.features2 <- My.features
My.features2$V2<-gsub("^tBody","TimeBody",My.features2$V2)
My.features2$V2<-gsub("Acc","Acceleration",My.features2$V2)
My.features2$V2<-gsub("^tGravity","TimeGravity",My.features2$V2)
My.features2$V2<-gsub("mean","Mean",My.features2$V2)
My.features2$V2<-gsub("^fBody","FrequencyBody",My.features2$V2)
My.features2$V2<-gsub("std","StandardDeviation",My.features2$V2)
My.features2$V2<-gsub("Freq","Frequency",My.features2$V2)
My.features2$V2<-gsub("BodyB","Body",My.features2$V2)

##Add column names to both X files
colnames(My.testx) <- My.features2$V2
colnames(My.trainx) <- My.features2$V2

##Add descriptive names to both y files
names(My.trainy) = "Activity"
My.trainy$Activity=factor(My.trainy$Activity)
levels(My.trainy$Activity)=My.activity$V2

names(My.testy) = "Activity"
My.testy$Activity=factor(My.testy$Activity)
levels(My.testy$Activity)=My.activity$V2

##Combine all test files and select required columns
My.AllTest <- bind_cols(My.subtest,My.testy,My.testx)
My.FinalTest <- select(My.AllTest,Subject,Class,Activity,contains("Mean"),contains("StandardDeviation"),
                       -contains("MeanFreq"))

##Combine all train files and select required columns
My.AllTrain <- bind_cols(My.subtest,My.trainy,My.trainx)
My.FinalTrain <- select(My.AllTrain,Subject,Class,Activity,contains("Mean"),contains("StandardDeviation"),
                       -contains("MeanFreq"))

##Create table combining both test and train subtables
My.FinalTable <- bind_rows(My.FinalTest,My.FinalTrain)

##Group and summarize finaltable
My.FinalTable2<-summarise_all(group_by(My.FinalTable,Activity,Subject),mean)
My.FinalTable2$Class <- NULL

write.table(My.FinalTable2,"Tidy_Dataset.txt",row.names=FALSE)

