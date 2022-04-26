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
yes = subset(hof, inducted == "Y")

# Batting data frame
# contains predictors
batting = Lahman::Batting

# Fielding data frame
# contains positional data
fielding = Lahman::Fielding
p = subset(fielding, fielding$POS == "P")

# STEPS
# 1) Subset out all pitchers from Batting data frame
  # 1a) Use Fielding data frame
  # 1c) Subset out all POS == "P"
  # 1c) Group by player id to get the unique non-pitchers
  # 1d) Merge these players onto Batting, keeping only the players in Fielding
# 2) Aggregate batting stats to the player level
# 3) Subset out non-players from HallofFame data frame
# 4) Merge HOF indicator

# Next: think about training/validation/testing splits
# Next: think about how to project career stat lines of current players

# STEP 1: Subset out pitchers from the data frame
prep = subset(fielding, POS != "P")

prep = select(prep, playerID)

prep = unique(prep)

merged = merge(prep, batting, c("playerID", "playerID"))

rm(batting, fielding, prep)

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
            G = sum(G),
            AB = sum(AB),
            R = sum(R),
            H = sum(H),
            X2B = sum(X2B),
            X3B = sum(X3B),
            HR = sum(HR),
            RBI = sum(RBI),
            SB = sum(SB),
            CS = sum(CS),
            SO = sum(SO),
            BB = sum(BB),
            IBB = sum(IBB),
            HBP = sum(HBP),
            SH = sum(SH),
            SF = sum(SF),
            GIDP = sum(GIDP))


