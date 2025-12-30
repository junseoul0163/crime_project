/*==============================================================================
    Project:    Economics of Crime
    File:       06_robustness.do
    Purpose:    Robustness Checks (Clustering & Lags) - WEEK 3 COMPLETE
    Author:     Jun Hwang
==============================================================================*/

global path "/Users/heejunhwang/Documents/GitHub/crime_project"
cd "$path"

clear all
use "data/clean/final_panel.dta", clear

*--- PREP ---*
* Re-create logs just to be safe
gen crime_rate = (crimes / population) * 100000
gen ln_crime   = log(crime_rate)
gen ln_unemp   = log(unemp_rate)

*--- 1. THE CLUSTERING CHECK (Standard for State Panels) ---*
* We use "vce(cluster state_id)"
* This relaxes the assumption that years are independent.
* It usually makes your stars (***) harder to get.
xtreg ln_crime ln_unemp i.year, fe vce(cluster state_id)
est store model_cluster

*--- 2. THE LAG TEST (Does it take time?) ---*
* "L.ln_unemp" means "Last Year's Unemployment".
* We test if Crime responds to unemployment from 1 year ago.
xtreg ln_crime L.ln_unemp i.year, fe vce(cluster state_id)
est store model_lag1

*--- 3. THE DYNAMIC MODEL (Both Today AND Yesterday) ---*
* Does crime respond to BOTH today's crisis and the lingering effects?
xtreg ln_crime ln_unemp L.ln_unemp i.year, fe vce(cluster state_id)
est store model_dynamic

*--- EXPORT FINAL ROBUSTNESS TABLE ---*
esttab model_cluster model_lag1 model_dynamic using "output/robustness_table.rtf", ///
    replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    stats(r2_a N, labels("Adj. R-Squared" "Observations")) ///
    mtitles("Clustered SE" "Lagged (t-1)" "Dynamic (t & t-1)") ///
    title("Table 2: Robustness Checks and Dynamic Effects") ///
    note("Standard errors clustered at the state level. *** p<0.01")

display "PROJECT COMPLETE. You have finished the syllabus!"
