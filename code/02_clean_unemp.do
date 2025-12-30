/*==brwo============================================================================
    Project:    Economics of Crime
    File:       02_clean_unemp.do
    Purpose:    Loop through 15 Excel files and clean them (DEMOGRAPHIC FIX)
    Author:     Jun Hwang
==============================================================================*/

*--- 0. SETUP ---*
global path "/Users/heejunhwang/Documents/GitHub/crime_project"
cd "$path"

clear all

*--- 1. PREPARE THE GHOST BOWL ---*
tempfile master_data
save `master_data', emptyok

*--- START THE MACHINE ---*
forvalues i = 10/24 {
    
    display "Processing Year 20`i'..."
    
    * A. Import
    import excel "data/raw/table14full`i'.xlsx", clear
    
    * B. Keep the Vital Columns
    * Col A: State FIPS
    * Col B: Group Code (This is the key!)
    * Col C: State Name
    * Col K: Unemployment Rate
    keep A B C K
    
    * C. Rename
    rename A fips
    rename B group_code
    rename C state
    rename K unemp_rate
    
    * D. Clean Header Rows
    * The first few rows are titles. We drop them.
    drop if _n <= 4
    
    * E. Generate Year
    gen year = 2000 + `i'
    
    * F. Destring (Convert Text to Numbers)
    * "force" will turn any header text into missing values (.)
    destring unemp_rate, replace force
    destring group_code, replace force
    
    * G. THE FILTER (CRITICAL STEP)
    * We only want Group Code 1 ("Total").
    * We drop Men (2), Women (3), etc.
    keep if group_code == 1

    * H. Append to the Ghost Bowl
    append using `master_data'
    save `master_data', replace
}

*--- 3. FINAL POLISH ---*
use `master_data', clear

* Drop empty rows and the now-useless group code
drop if state == ""
drop group_code

* Rename FIPS to state_id (Crucial for xtset later!)
rename fips state_id

* Turn "01" (text) into 1 (number) so it matches the Crime file!
destring state_id, replace

* Label variables
label variable state_id "State FIPS Code"
label variable unemp_rate "Unemployment Rate (%)"

* Sort and Save
sort state_id year
save "data/clean/unemp_data.dta", replace

display "SUCCESS! Unemployment Data is completely clean."
