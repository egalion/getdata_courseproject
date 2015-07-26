---
title: "Read me"
output: html_document
---

This repository contains files for the course assignment of "Getting and Cleaning Data" course on Coursera. 

There is a script ["run_analysis.R"](run_analysis.R) that processes the raw data, provided for the assignment and produces as an output ["tidy_data.txt"](tidy_data.txt), which is a dataset in a tidy format (long), containing 11880 observations of 4 variables.

__Notes on running the script__

The raw data is located in a subfolder data. The script links to them relatively. Assuming that you download the repository and set your R working environment to the base repository directory, it should be able to open the data files correctly.

The script describes in details the steps taken to get the processed data, using comments. It also uses the R packages [dplyr](https://cran.r-project.org/web/packages/dplyr/) and [tidyr](https://cran.r-project.org/web/packages/tidyr/index.html), so if you don't have them installed do so using install.packages("dplyr") and install.packages("tidyr").


__Notes on the output data__

The data, produced by the script is in a file ["tidy_data.txt"](tidy_data.txt). To load it properly, you need to run the command 

```{r, results = 'hide'}
tidy.df <- read.table("tidy_data.txt", header = TRUE)
```

The output data is described in a [CodeBook.md](CodeBook.md) file in this repository.

