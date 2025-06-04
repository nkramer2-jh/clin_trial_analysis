# Load libraries
library(ggplot2)
library(dplyr)
library(broom)
library(car)
library(boot)

set.seed(123) #Random seed

n <- 200 #Number of trials

#Setting up the dataframe
id <- 1:n #Unique identifier for each individual
group_id <- rep(c(TRUE, FALSE), each = n/2) #True is drug, False is placebo
age <- rnorm(n, mean=45, sd=8) #Random ages around 45 yrs old
sex <- sample(c("Male", "Female"), n, replace = TRUE) #Random male and female
bmi <- rnorm(n, mean=30, sd=5) #Random bmi around 30

data <- data.frame(id, group_id, age, sex, bmi) #Set up the dataframe

#Generate some random change. The medication should on average decrease bp

# Generate BP changes with slight BMI effect
bmi_effect <- 0.2  # small effect size (e.g., 0.1 mmHg per BMI unit)

# Subset BMI values by group
placebo_bmi <- data$bmi[data$group_id == FALSE]
drug_bmi <- data$bmi[data$group_id == TRUE]

# Add slight BMI-related increase to BP change
placebo_bp <- rnorm(n/2, mean = 0, sd = 5) + placebo_bmi * bmi_effect
drug_bp <- rnorm(n/2, mean = -6, sd = 5) + drug_bmi * bmi_effect

# Create one vector that combines them
bp_values <- numeric(nrow(data))  # Preallocate vector of correct length
bp_values[data$group_id == FALSE] <- placebo_bp #Assigns placebo bp values to bp_values based on corresponding location in dataframe
bp_values[data$group_id == TRUE] <- drug_bp #Assigns drug bp values to bp_values based on corresponding location in dataframe

data$bp_change <- bp_values #Add to the dataframe

head(data)

#Basic statistics on bp_change
summary_stats <- data %>% #get values from data
  group_by(group_id) %>% #group the results by drug (TRUE) or placebo (FLASE)
  summarise(   #summarise the data based on the following parameters
    bp_delta_mean = mean(bp_change), #take the mean of the bp_change
    sdev_bp_change = sd(bp_change), #take the standard deviation of the bp_change
    n = n()) #list the number of replicates for each group

show(summary_stats) #display the summary statistics in the console

#Perform a t-test to identify whether there is a significant difference
t_result <- t.test(bp_change ~ group_id, data = data) #test if bp difference is significant, generate p value
show(t_result) #display t-test results

#Linear model based on the various categories
model1 <- lm(bp_change ~ group_id + age + sex + bmi, data = data) #Creates linear model
summary(model1) #Provides summary of model

#Principle component analysis (needs data to be modified to numerical)
data_pca <- data %>%
  mutate(
    sex_num = ifelse(sex == "Male", 1, 0), #Select male to 1 and Female to 0
    group_num = ifelse(group_id == TRUE, 1, 0) #Select drug to 1 and placebo to 0
  ) %>%
  select(age, bmi, sex_num, group_num) #Selected groups for PCA analysis

#Run PCA
pca_result <- prcomp(data_pca,    
                     center = TRUE, #Optional
                     scale. = TRUE) #Generally helpful

summary(pca_result) #Summary of PCA

#Multicollinearity 
vif_vals <- vif(model1)
show(vif_vals)

ggplot(data, aes(x = group_id, y = bp_change, fill = group_id)) + #aes is for aesthetic mapping, uses group to determine the fill
  geom_boxplot(alpha = 0.4) + #generate boxplot with opacity of 0.5
  geom_jitter(width = 0.2, alpha = 0.2) +  #adds slight horizontal displacement to points
  theme_minimal() + #minimalistic theme to avoid gridlines
  labs(title = "Change in Blood Pressure After Treatment",   #Title
       y = "BP Change (mmHg)", x = "Condition (T=drug : F=placebo)") +   #Axes labels
  scale_fill_manual(values = c("#999999", "#56B4E9")) + #Color values for boxes
  theme(legend.position = "none") #hides legend because groups are already evident

#Examine with BMI modifies the drug's effect
model_interact <- lm(bp_change ~ group_id * bmi + age + sex, data = data) #linear model with group_id:bmi included
summary(model_interact) #summarize the statistics

#Bootstrap test to estimate sampling distribution
boot_mean <- function(data, indices) { #function to determine mean bp change between groups
  d <- data[indices, ] #samples with replacement using the bootstrap indices
  #Calculates the diff in average BP change between groups within bootstrapped sample.
  return(mean(d$bp_change[d$group_id == TRUE]) - 
           mean(d$bp_change[d$group_id == FALSE]))
}

results <- boot(data = data, statistic = boot_mean, R = 1000) #Performs the bootstrapping
boot.ci(results, type = "bca") #Calculates the bootstrap confidence interval. In this case, it is statistically significant

