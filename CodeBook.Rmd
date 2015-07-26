---
title: "CodeBook"
output: html_document
---

This is the codebook for the course assignment from the "Getting and Cleaning Data" course on Coursera.

__Raw data__ 

It contains data from experiments with a group of 30 volunteers, performing six activities six activities, wearing a smartphone on the waist. Data was collected using the smartphone's embedded accelerometer and gyroscope. The data was split in a training and test dataset. Detailed description of the raw data and the variables can be found in the files [README.txt](data/README.txt), [features_info.txt](data/features_info.txt), [features.txt](data/features.txt) and [activity_labels.txt](data/activity_labels.txt) in the "data" folder of the repository. 

__Processed data__

The raw data was processed in five main steps (described in details in the [run_analysis.R](run_analysis.R) script as comments) to get the processed data [tidy_data.txt](tidy_data.txt). First, the train and tests sets were concatenated. Second, only measurements on the mean and standard deviation for each measurement were extracted. Third, activities in the dataset were given descriptive names (instead of numbers). Fourth, the dataset was labeled with descriptive variable names. Fifth, a tidy dataset with the average of each variable for each activity and subject was created.

The [tidy dataset](tidy_dataset.txt) contains 11880 observations of  4 variables. The variables are:

* subject - it contains thirty subjects that took part in the experiment
* activity - contains six activities, performed by the subjects. These activities are "laying", "sitting", "standing", "walking", "walking_downstairs", "walking_upstairs".
* measurement - various measurements carried out (presented here as their mean and standard deviation grouping), while the subject were engaged in the respective activities. These were taken with the smartphone's accelerometer and gyroscope. The measurements have several aspects and combined lead to a large number of unique observations. Each observation name contains key word from which can be inferred the specific measurement it describes. These include:
  * time-signals - time domain signals captured by the accelerometer or the gyroscope
  * frequency-signals - frequency domain signals, produced by applying Fast Fourier Transform (FFT) to some of the signals
  * Body-Acceleration - body acceleration signals from the accelerometer
  * Gravity-Acceleration - gravity acceleration signals from the accelerometer
  * Body-Gyroscope-signals - signals from the gyroscope for the movement of the body
  * Jerk-signals - Jerk signals obtained from the body linear acceleration and angular velocity
  * X-axis - measurement on the X-axis
  * Y-axis - measurement on the Y-axis
  * Z-axis - measurement on the Z-axis
  * Magnitude - magnitude of the three-dimensional signals, calculated using the Euclidean norm
  * mean - the mean of the respective measurement
  * std - the standard deviation of the respective measurement
* mean_value - the average of the measurements for the respective subject and activity. As all the values have been converted to the [standard normal distribution](http://en.wikipedia.org/wiki/Normal_distribution#Standard_normal_distribution), the minimum is -1 and the maximum is +1. 