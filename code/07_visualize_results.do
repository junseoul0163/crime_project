/*==============================================================================
    Project:    Economics of Crime
    File:       07_visualize_results.do
    Purpose:    Create a "Coefficient Plot" to visualize the final estimates
    Author:     Jun Hwang
==============================================================================*/

global path "/Users/heejunhwang/Documents/GitHub/crime_project"
cd "$path"

clear all
use "data/clean/final_panel.dta", clear

*--- 1. INSTALL THE VISUALIZATION TOOL ---*
* (If this runs once, you don't need to run it again)
ssc install coefplot, replace

*--- 2. RE-RUN THE KEY MODELS ---*
* We need to store them in memory to plot them.

* Model 1: Basic Fixed Effects
gen crime_rate = (crimes / population) * 100000
gen ln_crime   = log(crime_rate)
gen ln_unemp   = log(unemp_rate)

xtreg ln_crime ln_unemp i.year, fe vce(cluster state_id)
est store FE_Basic

* Model 2: The "Lag" Model (The Slow Burn)
xtreg ln_crime L.ln_unemp i.year, fe vce(cluster state_id)
est store FE_Lagged

* Model 3: The Dynamic Model (Both)
xtreg ln_crime ln_unemp L.ln_unemp i.year, fe vce(cluster state_id)
est store FE_Dynamic

*--- 3. GENERATE THE COEFFICIENT PLOT ---*
* We removed the 'groups' command to fix the error.
coefplot FE_Basic FE_Lagged FE_Dynamic, ///
    keep(ln_unemp L.ln_unemp) ///
    xline(0, lcolor(red) lpattern(dash)) ///
    title("The Effect of Unemployment on Crime") ///
    subtitle("Comparison of Model Specifications") ///
    xtitle("Elasticity (% Change in Crime for 1% Change in Unemployment)") ///
    coeflabels(ln_unemp = "Current Unemployment" ///
               L.ln_unemp = "Last Year's Unemployment (Lag)") ///
    levels(95) /// 
    ciopts(lwidth(medium) lcolor(black)) ///
    msymbol(circle_hollow) ///
    note("Bars represent 95% Confidence Intervals. Errors clustered by State.")

graph export "output/final_results_plot.png", replace
