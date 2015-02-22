#Codebook
###Variables

Variable name    | Description
-----------------|------------
Subject          | This is the ID of the individual that produced the data for its respective row. The range of this value is 1 to 30 for each of the 30 individuals that participated.
Activity Name    | This is the name of the activity the person performed while wearing their smartphone.  This value can be one of six activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
variable         | Mean or standard deviation of various features being measured.  See the features_info.txt in the 'UCI HAR Dataset' directory for more information on the features being measured
value            | The average of values for the respective Subject/Activity/Feature combination



###Sample of the data

    > head(tidydt)
      Subject ActivityName                                variable       value
         1       LAYING              TimeBodyAccelerationMeanXAxis  0.22159824
         1       LAYING              TimeBodyAccelerationMeanYAxis -0.04051395
         1       LAYING              TimeBodyAccelerationMeanZAxis -0.11320355
         1       LAYING TimeBodyAccelerationStandardDeviationXAxis -0.92805647
         1       LAYING TimeBodyAccelerationStandardDeviationYAxis -0.83682741
         1       LAYING TimeBodyAccelerationStandardDeviationZAxis -0.82606140



