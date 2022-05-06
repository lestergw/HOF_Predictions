# Which current MLB players will make the Hall of Fame?
## Code and Report By: Griffin Lester
## ISA 630: Machine Learning Appplications in Business

Many kids, myself included, grew up wanting to be a professional baseball player. We dreamed of hitting a walkoff homerun, raising the World Series trophy, and even seeing a plaque with our name and face installed at the MLB Hall of Fame in Cooperstown, New York. In case the mere fact that I am writing this report did not give it away, I am not a Hall of Fame-caliber MLB player. Despite this, I still live and breathe baseball every single day. As I begin to pursue my career in data science, I have been exploring how I can apply my passion for America's pastime to my developing professional interests.

One of the biggest events in the sport of baseball each year is the Hall of Fame voting. Stats nerds like myself love this time of year for the passionate debates that inevitably ensue. Traditionalists support players who pass the 'eye test', valuing the intangible factors that a player contributes to his team. Analytics enthusiasts use every metric possible to justify a player's inherent value, even if he or his team flew under the radar during the course of his career.

<p align = "center">
 <img src = "/Cache Files/kgj.jpg" width="850" height="566">
</p>
<p align = "center">
 <em>Mike Piazza (left) and Ken Griffey Jr. (right) at the Hall of Fame induction ceremony in Cooperstown, NY in 2016.</em>
</p>

As I took more analytics classes at Miami University, my curiosity piqued. I wanted to pursue a project that would utilize my analytics toolkit to contribute to the heated MLB Hall of Fame conversation. After iterating through various ideas, I decided to answer the following question: *Which current MLB players will make the Hall of Fame?*

The following report details the methods used and decisions made to best answer this question. I will identify my data source, explain how the data was cleaned, detail my modeling strategy, deliver my results, and discuss the major limitations of this analysis.

## Table of Contents
**[Problem Scope](#problem-scope)**<br>
**[Data Source: Lahman's Baseball Database](#data-source-lahmans-baseball-database)**<br>
**[Data Cleaning](#data-cleaning)**<br>
**[Modeling Strategy](#modeling-strategy)**<br>
**[Results](#results)**<br>
**[Limitations](#limitations)**<br>
**[Discussion](#discussion)**<br>
**[Acknowledgements](#acknowledgements)**<br>

## Problem Scope

Before diving into any numbers or code, I deemed it necessary to define the scope for this project. To maintain simplicity of understanding and feasibility of project completion, I decided to model hitters only. Similarly, of all the stats, accolades, and off-the-field factors that can influence a player's value, I decided to only use batting statistics as predictor variables. The drawbacks of such an approach are detailed in the *[Limitations](#limitations)* section of this report.

I also wanted to conceptualize how I would perform training, validation, and testing splits on the data. After considering strategies such as a rolling window modeling approach or specific subsets of data representing different eras of baseball, I ultimately decided to adopt a simple approach. My training and validation data sets would be randomly sampled from all years excluding the 5 most recent years required for MLB players to qualify for the HOF ballot: 1900-2016. The test data set would merely be the current or retired players not yet eligible for the HOF ballot in the 2017-2021 time frame.

## Data Source: Lahman's Baseball Database

The data used in this analysis is extracted from the Lahman Baseball Database using the `Lahman` package in R (see documentation [here](https://cran.r-project.org/web/packages/Lahman/Lahman.pdf)). Although the database contains numerous tables, only the `Batting`, `Fielding`, and `HallOfFame` tables are used.
Here is some additional information about each table used:

* `Batting`: batting statistics at the level of player by year; contains predictor variables for modeling
  * 110,495 observations
  * 22 variables
* `Fielding`: fielding statistics at the level of player by year by position; used to create a subset of only hitters
  * 147,080 observations
  * 18 variables
* `HallOfFame`: hall of fame voting data at the level of player by year; contains the response variable `inducted`
  * 4,191 observations
  * 9 variables

For more information about Sean Lahman or the Lahman Baseball Database, see his [Twitter account](https://twitter.com/seanlahman) or his [website](https://www.seanlahman.com/).

## Data Cleaning

After loading the required data sets into my environment, my next goal was to clean and prepare the data in a way that aligned with my project scope. I chose to clean the data in RStudio because the data was easily accessible from the aforementioned R package `Lahman`. The data cleaning activities included:

* Subsetting the data to only include players from 1900-present
* Imputing the median for missing values in various columns
* Aggregating the data to the player level, displaying all statistics as averages by season
* Subsetting the data to only include players with at least 100 at-bats in the MLB
* Merging the `inducted` indicator from the `HallOfFame` table into my aggregated data frame
* Removing unnecessary columns
* Recoding factor levels
* Splitting the data into training/validation and test partitions
  * Training/validation players from 1900-2016
  * Test players from 2017-2021

After completing these necessary activities, I saved each partition of data as a .csv file, allowing me to pivot to Google Colab for the modeling phase of the project.
The specific steps taken to clean and export the data can be viewed in the **Data Preparation.R** file in this repository.

## Modeling Strategy

Having prepared the data at the correct level of analysis, I began to model the data with Python using Google Colab. Before diving into the models, though, I had to adjust my data a little more to ensure a well-designed analysis. First, I loaded the *training.csv* file into Colab and randomly split the data into training and validation data frames using the function `train_test_split()` from `sklearn`. Next, and more importantly, I had to correct the severe imbalance of data in my response variable `inducted`. To do so, I used SMOTE oversampling on both the training and validation data frames. For more information about SMOTE oversampling, see this [article](https://imbalanced-learn.org/stable/references/generated/imblearn.over_sampling.SMOTE.html).

At this point in my analysis, I was ready to construct and fit predictive models. Of the countless algorithms out there, I decided to train and fit six models that were covered in my Machine Learning Applications in Business course this semester:

* Logistic Regression
* Decision Tree
* Random Forest
* AdaBoost
* XGBoost
* Multilayer-Perceptron Neural Network

I chose these specific algorithms with the intent of covering various algorithm types, such as regression, trees, boosted trees, and neural networks. For each type of model, my process was fairly simple. I first instantiated each model with the chosen hyperparameters. Then I fit the model, generated predictions, and compared those predictions to the actual values. To evaluate each model, I produced accuracy values and area under the curve (AUC) values for the training and validation data frames, respectively. In this instance, **accuracy** is simply the percentage of correct predictions. **AUC** is the probability of correctly identifying a true Hall of Fame player.

Here are the results of my predictive modeling:

<p align = "center">
 <img src = "/Cache Files/ModelEvaluation.png" width="700" height="300">
</p>

I was very happy with the validation metrics generated by my models. Although both the AdaBoost and the Random Forest algorithms performed very well, I ultimately decided to select the Random Forest model because it had the highest accuracy and AUC on the validation data. Some issues with such a simple selection process will be discussed in the *[Limitations](#limitations)* section of this report.

## Results

The next and most important step of the analysis was to make predictions on the test players using the Random Forest model. The code to do this was very simple, merely requiring that I load the data and make the predictions. Out of 864 MLB players that either retired in the 2017-2021 time frame or are still current as of 2021, my model predicted that 22 of them will be immortalized in Cooperstown, NY in the MLB Hall of Fame. This equates to about 2.5% of all players in the five-year time frame. The predicted future Hall of Famers are:

* Jose Altuve
* Elvis Andrus
* Nolan Arenado
* Adrian Beltre
* Carlos Beltran
* Mookie Betts
* Ryan Braun
* Melky Cabrera
* Miguel Cabrera
* Robinson Cano
* Jacoby Ellsbury
* Paul Goldschmidt
* Bryce Harper
* Ian Kinsler
* Francisco Lindor
* Joe Mauer
* Whit Merrifield
* Albert Pujols
* Jose Reyes
* Juan Soto
* Ichiro Suzuki
* Troy Tulowitzki

Upon first glance, many of these results make logical sense. Most people who are moderately familiar with the sport will likely agree that all of the players on the list above have Hall of Fame potential. Some of them are nearly guaranteed to be enshrined in Cooperstown someday, such as Miguel Cabrera or Albert Pujols. Overall, I was quite satisfied with the predictions generated by my Random Forest model.

The only concern that is swiftly raised about this output is the group of players that were *not* predicted to make the Hall of Fame but definitely should have. Ever heard of this kid named Mike Trout? For some reason that is far beyond me, my model did not predict that Mike Trout, arguably the best position player of all time, would be inducted into the Hall of Fame someday. My model also missed players like Yadier Molina, Ronald Acuña Jr., or Buster Posey who all have a very high probability of making it to Cooperstown. The possible reasons for these clear misclassifications will be explained in the following section of the report.

## Limitations



## Discussion

## Acknowledgements
