/*==============================================================================
    Project:    Economics of Crime
    File:       01_clean_crime.do
    Purpose:    Import and clean FBI Crime Data (WITH ID GENERATION)
    Author:     Jun Hwang
==============================================================================*/

*--- 0. SETUP ---*
global path "/Users/heejunhwang/Documents/GitHub/crime_project"
cd "$path"

clear all                   
set more off                

*--- 1. IMPORT ---*
import delimited "data/raw/estimated_crimes_1979_2024.csv", clear varnames(1)

*--- 2. CLEAN ---*
keep state_abbr year population property_crime
rename state_abbr state_abbr  // Keep original name for the tool
rename property_crime crimes

keep if year >= 2010 & year <= 2022

*--- 3. THE FIX: MERGE WITH CROSSWALK ---*
* Instead of a package, we merge our own dictionary.
* This is a "Many-to-One" merge (m:1) because "AL" appears many times in crime data,
* but only once in our dictionary.
merge m:1 state_abbr using "data/clean/crosswalk.dta"

* Check the merge!
* _merge == 3 means "Matched". 
* _merge == 1 means "In Master only" (Maybe 'National Total' rows?)
* We only keep the matches (3).
keep if _merge == 3
drop _merge

*--- 4. FINAL POLISH (The "Yellow Text" Fix) ---*
* Remove commas so STATA recognizes these as numbers
* "ignore(,)" tells STATA to pretend the commas don't exist
destring population crimes, replace ignore(",")

* This forcibly removes the second "North Carolina 2022"
duplicates drop state_id year, force

* Move the ID to the far left so it's easier to read
order state_id year population crimes

* Force the sort order: State 1 (2010), State 1 (2011)...
sort state_id year
save "data/clean/crime_data.dta", replace

display "SUCCESS! Crime data has numeric IDs."	
