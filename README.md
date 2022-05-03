# Which current MLB players will make the Hall of Fame?
## Code and Report By: Griffin Lester
## ISA 630: Machine Learning Appplications in Business

Many kids, myself included, grew up wanting to be a professional baseball player. We dreamed of hitting a walkoff homerun, raising the World Series trophy, and even seeing a plaque with our name and face installed at the MLB Hall of Fame in Cooperstown, New York. In case the mere fact that I am writing this report did not give it away, I am not a Hall of Fame-caliber MLB player. Despite this, I still live and breathe baseball every single day. As I begin to pursue my career in data science, I have been exploring how I can apply my passion for America's pastime to my developing professional interests.

One of the biggest events in the sport of baseball each year is the Hall of Fame voting. Stats nerds like myself love this time of year for the passionate debates that inevitably ensue. Traditionalists support players who pass the 'eye test', valuing the intangible factors that a player contributes to his team. Analytics enthusiasts use every metric possible to justify a player's inherent value, even if he or his team flew under the radar during the course of his career.

As I took more analytics classes at Miami University, my curiosity piqued. I wanted to pursue a project that would utilize my analytics toolkit to contribute to the heated MLB Hall of Fame conversation. After iterating through various ideas, I decided to answer the following question: *Which current MLB players will make the Hall of Fame?*

The following report details the methods used and decisions made to best answer this question. I will identify my data source, explain how the data was cleaned, detail my modeling strategy, deliver my results, and discuss the major limitations of this analysis.

## Table of Contents
**[Problem Scope](#problem-scope)**<br>
**[Data Source: Lahman's Baseball Database](#data-source-lahmans-baseball-database)**<br>
**[Data Cleaning](#data-cleaning)**<br>
**[Modeling Strategy](#modeling-strategy)**<br>
**[Results](#results)**<br>
**[Limitations](#limitations)**<br>
**[Acknowledgements](#acknowledgements)**<br>

## Problem Scope

Before diving into any numbers or code, I deemed it necessary to define the scope for this project. To maintain simplicity of understanding and feasibility of project completion, I decided to only model hitters. Similarly, of all the stats, accolades, and off-the-field factors that can influence a player's value, I decided to only use batting statistics as predictor variables. The drawbacks of such an approach are detailed in the *Limitations* section of this report.

I also wanted to conceptualize how I would perform training, validation, and testing splits on the data. After considering strategies such as a rolling window modeling approach or specific subsets of data representing different eras of baseball, I ultimately decided to adopt a simple approach. My training and validation data sets would be randomly sampled from all years excluding the 5 most recent years required for MLB players to qualify for the HOF ballot: 1900-2016. The test data set would merely be the current or retired players not yet eligible for the HOF ballot in the 2017-2021 time frame.

## Data Source: Lahman's Baseball Database

The data used in this analysis is extracted from the Lahman Baseball Database using the `Lahman` package in R (see documentation [here](https://cran.r-project.org/web/packages/Lahman/Lahman.pdf)). Although the database contains numerous tables, only the `Batting`, `Fielding`, and `HallOfFame` tables are used.
Here is some additional information about each table used:

* `Batting`: batting statistics at the level of player by year; contains predictor variables for modeling
  * 22 variables
* `Fielding`: fielding statistics at the level of player by year by position; used to create a subset of only hitters
  * 147,080 observations
  * 18 variables
* `HallOfFame`: hall of fame voting data at the level of player by year; contains the response variable `inducted`
  * 4,191 observations
  * 9 variables

For more information about Sean Lahman or the Lahman Baseball Database, see his [Twitter account](https://twitter.com/seanlahman) or his [website](https://www.seanlahman.com/).

## Data Cleaning

## Modeling Strategy

## Results

## Limitations

## Acknowledgements
