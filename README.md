# Simulated Clinical Trial: Blood Pressure Reduction with Hypothetical Drug

This project simulates a randomized controlled clinical trial in R to evaluate the effect of a hypothetical blood pressure–lowering drug. The script includes data generation, statistical analysis, and exploratory data analysis using Principal Component Analysis (PCA).

## 🧪 Project Description

We simulate a clinical trial with 200 participants randomly assigned to either a drug group or a placebo group. Each participant has associated demographic and health information (age, sex, BMI). We simulate changes in blood pressure and perform statistical tests to evaluate drug efficacy.

## 📊 Features and Methods

- **Simulated patient data** including:
  - Age (normally distributed around 45)
  - Sex (randomly assigned Male/Female)
  - BMI (normally distributed around 30)
  - Group assignment: Drug or Placebo
- **Simulated outcome:** Change in blood pressure (`bp_change`), where the drug group has a greater average reduction.
- **Statistical analyses:**
  - Group summary statistics
  - Two-sample t-test to compare blood pressure change between groups
  - Linear regression modeling (`lm()`) to evaluate the influence of group, age, sex, and BMI
  - Multicollinearity test 
- **Principal Component Analysis (PCA):**
  - Converts categorical variables to numeric
  - Performs PCA on patient characteristics
  - Summarizes and plots explained variance
- **Visualization using tidyverse (ggplot2):**
  - Creates boxplots for visualizing blood pressure as a function of group
  - Allows clear distinction between treatment groups
- **Bootstrap Resampling**
  - Sampled the dataset 1,000 times with replacement.
  - Calculated the mean difference in blood pressure (`drug - placebo`) for each sample.
  - Computed a bias-corrected and accelerated (BCa) confidence interval using `boot.ci()`.

## 📁 Files

- `clinical_trial_sim.R`: Main R script containing the full analysis pipeline
- `README.md`: Description of the project, goals, and methods

## 📈 Example Output

- **Summary statistics** show means and standard deviations for each group
- **t-test** returns a p-value indicating if the drug effect is statistically significant
- **Linear model** provides estimates for each predictor’s effect on BP change
- **PCA summary** shows how much variance is explained by each principal component
- **Multicollinearity** shows how much the variance of the regression coefficient is affected due to correlated predictors 
- **ggplot visualization** creates box plots to observe blood pressure statistics for each group
- **Bootsrap Resampling** uses non-parametric bootstrap resampling (with replacement) to estimate the confidence interval for blood pressure reduction between groups.

## 🛠️ Requirements

- R (version 4.0 or higher recommended)
- R packages:
  - `ggplot2`
  - `dplyr`
  - `broom`
  - `car`
  - `boot`

Install missing packages using:

```r
install.packages(c("ggplot2", "dplyr", "broom", "car", "boot"))

