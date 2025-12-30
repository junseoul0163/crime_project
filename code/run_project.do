/*==============================================================================
    Project:    Economics of Crime (2010-2022)
    File:       run_project.do
    Purpose:    MASTER SCRIPT - Runs all steps from cleaning to analysis
    Author:     [Your Name]
==============================================================================*/

*--- 1. SETUP ---*
clear all
macro drop _all
set more off
set scheme s1color  // Sets a clean white background for all graphs

* Set your path here ONCE, so you don't have to change it in every file
global path "/Users/heejunhwang/Documents/GitHub/crime_project"
cd "$path"

* Create folders if they don't exist (prevents "file not found" errors)
capture mkdir "data"
capture mkdir "data/raw"
capture mkdir "data/clean"
capture mkdir "output"

display "----------------------------------------------------------------"
display "STARTING PROJECT: ECONOMICS OF CRIME"
display "----------------------------------------------------------------"

*--- 2. DATA CLEANING ---*
display "STEP 1: Creating Crosswalk..."
do "code/00_create_crosswalk.do"

display "STEP 2: Cleaning Crime Data..."
do "code/01_clean_crime.do"

display "STEP 3: Cleaning Unemployment Data (The Loop)..."
do "code/02_clean_unemp.do"

*--- 3. MERGING & EXPLORATION ---*
display "STEP 4: Merging Datasets..."
do "code/03_merge.do"

display "STEP 5: Generating Exploratory Graphs..."
do "code/04_explore_panel.do"

*--- 4. ANALYSIS & ROBUSTNESS ---*
display "STEP 6: Running Main Regressions..."
do "code/05_regression.do"

display "STEP 7: Running Robustness Checks..."
do "code/06_robustness.do"

display "STEP 8: Visualizing Final Results..."
do "code/07_visualize_results.do"

display "----------------------------------------------------------------"
display "PROJECT COMPLETE. ALL OUTPUTS SAVED."
display "----------------------------------------------------------------"
