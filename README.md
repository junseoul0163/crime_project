
# Economics of Crime: The Effect of Unemployment on Property Crime

An empirical analysis of labor market conditions and criminal activity using STATA.

## Overview

This project examines whether property crime is "counter-cyclical" (increases when the economy worsens) using state-level panel data from the FBI and the Bureau of Labor Statistics. The analysis spans 2010–2022 and employs panel data methods, including Two-Way Fixed Effects (TWFE) and dynamic lag specifications, to test the "motivation effect" hypothesis derived from Becker (1968).

## Key Findings

**Unemployment has a statistically significant, positive effect on property crime.**

- **Elasticity:** A 1% increase in the unemployment rate is associated with a **0.20% increase** in the property crime rate (p < 0.01).
- **The "Slow Burn" Effect:** Past unemployment matters more than current unemployment. The effect of unemployment lagged by one year (coefficient: 0.23) is stronger than the immediate effect.
- **Robustness:** These results hold even after clustering standard errors by state and controlling for national time trends.

## Data Sources

1. **FBI Uniform Crime Reporting (UCR) Program**
   - Years: 2010–2022
   - Variables: Property crime counts, state population
   - Source: Federal Bureau of Investigation (FBI)

2. **Local Area Unemployment Statistics (LAUS)**
   - Years: 2010–2022
   - Variables: State-level unemployment rates
   - Source: Bureau of Labor Statistics (BLS)

## Repository Structure

```
crime_project/
├── README.md
├── code/
│   ├── run_project.do        # MASTER SCRIPT (Runs everything)
│   ├── 00_create_crosswalk.do # Generates state ID dictionary
│   ├── 01_clean_crime.do     # Cleans FBI data
│   ├── 02_clean_unemp.do     # Loops through BLS Excel files
│   ├── 03_merge.do           # Merges datasets & declares panel
│   ├── 04_explore_panel.do   # Descriptive graphs
│   ├── 05_regression.do      # Main FE analysis
│   ├── 06_robustness.do      # Clustering & Lag checks
│   └── 07_visualize_results.do # Coefficient plots
├── data/
│   ├── raw/                  # Original CSV/Excel files
│   └── clean/                # Processed .dta files
└── output/
├── regression_table.rtf  # Main results
├── robustness_table.rtf  # Dynamic model results
├── crime_spaghetti.png   # Trend visualization
└── final_results_plot.png # Coefficient plot

```

## How to Replicate

1. Clone this repository.
2. Download raw data
3. Open STATA and run:
```stata
do "code/run_project.do"

```




## Methods

### Two-Way Fixed Effects (TWFE)

Controls for:

* **State Fixed Effects:** Removes time-invariant characteristics (e.g., culture, geography, persistent poverty) that make some states consistently higher-crime than others.
* **Year Fixed Effects:** Removes national shocks (e.g., COVID-19, the 2008 recession) that affect all states simultaneously.

### Dynamic Modeling (Lags)

To test if crime responds immediately or with a delay, I utilize a dynamic specification:

* **Lagged Variable ():** Tests if unemployment in the *previous* year predicts crime *today* (representing the time it takes for savings to deplete).

## Output

### Figures

* **Spaghetti Plot:** Crime rate trends by state (2010-2022)
* **Scatter Plot:** Log Crime Rate vs. Log Unemployment Rate
* **Coefficient Plot:** Visual comparison of elasticities across OLS, FE, and Dynamic models

### Tables

* **Table 1:** Main Regression Results (OLS vs. State FE vs. State+Year FE)
* **Table 2:** Robustness Checks (Clustered Standard Errors & Lags)

## Software

* STATA 17 (or later)
* Required packages: `estout`, `coefplot` (installed automatically by master script)

## Author

Jun Hwang  
Economics-Mathematics Major, Columbia University  
December 2025

## License

This project is for educational purposes.

```

```
