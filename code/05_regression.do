/*==============================================================================
    Project:    Economics of Crime
    File:       05_regression.do
    Purpose:    Run Fixed Effects Regressions (The Analysis)
    Author:     Jun Hwang
==============================================================================*/

global path "/Users/heejunhwang/Documents/GitHub/crime_project"
cd "$path"

clear all
use "data/clean/final_panel.dta", clear

*--- PREP: LOGS (Recalculate to be safe) ---*
gen crime_rate = (crimes / population) * 100000
gen ln_crime   = log(crime_rate)
gen ln_unemp   = log(unemp_rate)

*--- MODEL 1: POOLED OLS (The "Naive" Model) ---*
* This treats every year as if it were a new random country.
* It ignores that Alabama 2010 is related to Alabama 2011.
reg ln_crime ln_unemp
est store model_ols

*--- MODEL 2: STATE FIXED EFFECTS (The "Within" Model) ---*
* This asks: "When unemployment rises IN ALABAMA, does crime rise IN ALABAMA?"
* It removes the fact that Alabama is just different from New York.
* "fe" stands for Fixed Effects.
xtreg ln_crime ln_unemp, fe
est store model_fe

*--- MODEL 3: STATE + YEAR FIXED EFFECTS (The Gold Standard) ---*
* "i.year" creates a dummy variable for 2010, 2011, 2012...
* This removes national trends (like crime dropping nationwide).
xtreg ln_crime ln_unemp i.year, fe
est store model_fe_year

*--- OUTPUT TABLE ---*
* We use 'esttab' to make a pretty table comparing them.
* (If this fails, type "ssc install estout" first)
esttab model_ols model_fe model_fe_year, ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    stats(r2_a N, labels("Adj. R-Squared" "Observations")) ///
    mtitles("OLS" "State FE" "State+Year FE") ///
    starlevels(* 0.10 ** 0.05 *** 0.01)

display "Regression Complete. Look at the coefficients!"

*--- EXPORT TO WORD ---*
* This creates a professional table you can copy-paste into your paper.
esttab model_ols model_fe model_fe_year using "output/regression_table.rtf", ///
    replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    stats(r2_a N, labels("Adj. R-Squared" "Observations")) ///
    mtitles("Pooled OLS" "State FE" "State+Year FE") ///
    title("Table 1: The Effect of Unemployment on Property Crime") ///
    note("Standard errors in parentheses. *** p<0.01, ** p<0.05, * p<0.1")
    
display "Table saved! Open 'output/regression_table.rtf' in Word."
