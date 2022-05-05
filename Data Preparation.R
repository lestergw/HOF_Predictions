# This file is used in the first part of the ISA 630 Final Project.
# In this file, the data is acquired, cleaned, and prepared for modeling.

# The goal of this project is to predict which current MLB players will
# be inducted into the Hall of Fame at the end of their careers.

# Load/Install the necessary packages
if(require(pacman)==FALSE) install.packages("pacman")
pacman::p_load(tidyverse, magrittr, DataExplorer, Lahman)

# Hall of Fame data frame
# contains target variable
hof = Lahman::HallOfFame

# Batting data frame
# contains predictors
batting = Lahman::Batting

# Fielding data frame
# contains positional data
fielding = Lahman::Fielding

# STEPS
# 1) Subset out all pitchers from Batting data frame
  # 1a) Use Fielding data frame
  # 1c) Subset out all POS == "P"
  # 1c) Group by player id to get the unique non-pitchers
  # 1d) Merge these players onto Batting, keeping only the players in Fielding
# 2) Aggregate batting stats to the player level
# 3) Subset out non-players from HOF data frame
# 4) Merge HOF indicator
# 5) Prepare training and test data sets

# Next: think about training/validation/testing splits
# Next: think about how to project career stat lines of current players

# STEP 0: Prepare current player indicator (used for test data frame subset)


# STEP 1: Subset out pitchers from the data frame
prep = subset(fielding, POS != "P")

prep = select(prep, playerID)

prep = unique(prep)

merged = merge(prep, batting, c("playerID", "playerID"))

rm(batting, fielding, prep)

# Subset players from 1900 - present
merged = subset(merged, yearID >= 1900)

# STEP 1.5: Impute missing values
# IBB (median)
merged$IBB[is.na(merged$IBB)] = median(merged$IBB, na.rm = TRUE)
summary(merged$IBB)

# SF (median)
merged$SF[is.na(merged$SF)] = median(merged$SF, na.rm = TRUE)
summary(merged$SF)

# GIDP (median)
merged$GIDP[is.na(merged$GIDP)] = median(merged$GIDP, na.rm = TRUE)
summary(merged$GIDP)

# CS (median)
merged$CS[is.na(merged$CS)] = median(merged$CS, na.rm = TRUE)
summary(merged$CS)

# SH (median)
merged$SH[is.na(merged$SH)] = median(merged$SH, na.rm = TRUE)
summary(merged$SH)

# HBP (median)
merged$HBP[is.na(merged$HBP)] = median(merged$HBP, na.rm = TRUE)
summary(merged$HBP)

# SB (median)
merged$SB[is.na(merged$SB)] = median(merged$SB, na.rm = TRUE)
summary(merged$SB)

# SO (median)
merged$SO[is.na(merged$SO)] = median(merged$SO, na.rm = TRUE)
summary(merged$SO)

# RBI (median)
merged$RBI[is.na(merged$RBI)] = median(merged$RBI, na.rm = TRUE)
summary(merged$RBI)

# STEP 2: Aggregate batting stats to the player level
merged_agg = merged %>% 
  group_by(playerID) %>% 
  summarise(LOS = n(),
            recent_year = max(yearID),
            G = mean(G),
            total_AB = sum(AB),
            AB = mean(AB),
            R = mean(R),
            H = mean(H),
            X2B = mean(X2B),
            X3B = mean(X3B),
            HR = mean(HR),
            RBI = mean(RBI),
            SB = mean(SB),
            CS = mean(CS),
            SO = mean(SO),
            BB = mean(BB),
            IBB = mean(IBB),
            HBP = mean(HBP),
            SH = mean(SH),
            SF = mean(SF),
            GIDP = mean(GIDP))

# Subset out players with less than 100 AB's
merged_agg = subset(merged_agg, total_AB >= 100)

merged_agg = select(merged_agg, -total_AB)

# STEP 3: Subset out non-players from HOF data frame
hof = subset(hof, category == "Player")

# STEP 4: Merge HOF indicator into dataset
hof %<>%
  group_by(playerID) %>% 
  slice(which.max(yearID))

final = merge(merged_agg, hof, c("playerID", "playerID"),
              all.x = TRUE, all.y = FALSE)

# Reduce columns to only necessary ones
final = select(final, -yearID, -votedBy, -ballots, -needed, -votes,
               -category, -needed_note)

# Replace NA values
final$inducted = fct_explicit_na(final$inducted, "N")

# Clean up environment
rm(hof, merged, merged_agg)

# STEP 5: Prepare training and test data sets
train = subset(final, recent_year < 2017)
test = subset(final, recent_year >= 2017)

test = select(test, -inducted)

write.csv(train, "train.csv")
write.csv(test, "test.csv")




