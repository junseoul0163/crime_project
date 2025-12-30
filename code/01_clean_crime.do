/*==============================================================================
    Project:    Economics of Crime
    File:       01_clean_crime.do
    Purpose:    Import and clean FBI Crime Data
    Author:     [Your Name]
==============================================================================*/

*--- 0. SET THE KITCHEN LOCATION ---*
* Set working directory 
cd "/Users/heejunhwang/Documents/GitHub/crime_project" 

* Clear everything
clear all                   
set more off              

*--- STEP 1: BRING THE INGREDIENTS TO THE DESK ---*
* We use "import delimited" because CSVs are separated by commas.
* "varnames(1)" tells STATA the first row contains the variable names.
import delimited "data/raw/estimated_crimes_1979_2024.csv", clear varnames(1)

*--- STEP 2: INSPECT THE MEAT ---*
* Before you cut, you look. What variables do we have?
describe                    

*--- STEP 3: TRIM THE FAT ---*
* The FBI file has dozens of columns (rape, murder, arson, caveats).
* We only want: State, Year, Population, and Total Property Crime.
* Note: Variable names in FBI CSVs can be tricky. They are usually:
* "state_abbr", "year", "population", "property_crime"
keep state_abbr year population property_crime

*--- STEP 4: PREP THE INGREDIENTS (RENAME) ---*
* "state_abbr" is annoying to type. Let's just call it "state".
* "property_crime" is long. Let's call it "crimes".
rename state_abbr state
rename property_crime crimes

*--- STEP 5: THE CUT (FILTERING) ---*
* We only have unemployment data for 2010-2022.
* So we throw away everything else.
keep if year >= 2010 & year <= 2022

*--- STEP 6: STORE THE PREP ---*
* We are done cleaning. Put this in the "Clean" folder (the fridge).
save "data/clean/crime_data.dta", replace
