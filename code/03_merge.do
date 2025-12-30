/*==============================================================================
    Project:    Economics of Crime
    File:       03_merge.do
    Purpose:    Merge Crime and Unemployment to create Master Panel
    Author:     Jun Hwang
==============================================================================*/

global path "/Users/heejunhwang/Documents/GitHub/crime_project"
cd "$path"

clear all

*--- 1. LOAD THE MASTER DATA (Crime) ---*
use "data/clean/crime_data.dta", clear

*--- 2. THE MERGE (The Zipper) ---*
* We match on TWO keys: state_id AND year.
* "1:1" means one row in Crime matches exactly one row in Unemployment.
merge 1:1 state_id year using "data/clean/unemp_data.dta"

*--- 3. CHECK THE RESULT ---*
* _merge == 1: Found in Crime, but MISSING in Unemployment
* _merge == 2: Found in Unemployment, but MISSING in Crime
* _merge == 3: Found in BOTH (Success!)
tab _merge

* We only keep the perfect matches
keep if _merge == 3
drop _merge

*--- 4. DECLARE PANEL DATA (The Magic Spell) ---*
* We tell STATA: "state_id is the Place, year is the Time"
xtset state_id year

*--- 5. SAVE ---*
save "data/clean/final_panel.dta", replace

display "SUCCESS! Panel dataset created."
