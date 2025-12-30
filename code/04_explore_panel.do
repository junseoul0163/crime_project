/*==============================================================================
    Project:    Economics of Crime
    File:       04_explore_panel.do
    Purpose:    Visualizing the Panel & Creating Log Variables
    Author:     Jun Hwang
==============================================================================*/

global path "/Users/heejunhwang/Documents/GitHub/crime_project"
cd "$path"

clear all
set scheme s1color  // Makes graphs look cleaner (white background)

*--- 1. LOAD THE MASTER PANEL ---*
use "data/clean/final_panel.dta", clear

*--- 2. CREATE LOG VARIABLES (THE ECONOMIST'S TOOL) ---*
**# 	
* We don't analyze "Total Crimes" (because big states naturally have more).
* We analyze "Crime Rates" and "Percent Changes".

* A. Create Crime Rate (Crimes per 100,000 people)
gen crime_rate = (crimes / population) * 100000

* B. Take the Natural Log (ln)
* Interpretation: A change of 0.1 in ln_crime = a 10% change in crime.
gen ln_crime_rate = log(crime_rate)
gen ln_unemp      = log(unemp_rate)

* Label them nicely for the graphs
label variable ln_crime_rate "Log Property Crime Rate"
label variable ln_unemp "Log Unemployment Rate"

*--- 3. VISUALIZE: THE SPAGHETTI PLOT ---*
* "xtline" is the special command for Panel Data.
* It draws one line for every state ID.
* "overlay" puts them all on one plot.
xtline crime_rate, overlay legend(off) ///
    title("Crime Rate Trends (2010-2022)") ///
    note("Each line represents a state. Trend is generally downward.")
    
graph export "output/crime_spaghetti.png", replace

*--- 4. VISUALIZE: THE SCATTERPLOT (THE HYPOTHESIS TEST) ---*
* Gary Becker's Model: High Unemployment -> High Crime.
* If true, the line should go UP.
* Let's see the correlation.
twoway (scatter ln_crime_rate ln_unemp) ///
       (lfit ln_crime_rate ln_unemp), ///
       title("Does Unemployment Cause Crime?") ///
       ytitle("Log Crime Rate") ///
       xtitle("Log Unemployment Rate")

graph export "output/scatter_crime_unemp.png", replace

*--- 5. CHECK ONE STATE (New York) ---*
* Let's look at State ID 36 (New York) specifically.
xtline crime_rate unemp_rate if state_id == 36, /// 
    title("New York: Crime vs Unemployment") ///
    ytitle("Rate") legend(label(1 "Crime") label(2 "Unemp"))
    
graph export "output/NY_trend.png", replace

display "Graphs Saved! Go check your output folder."
