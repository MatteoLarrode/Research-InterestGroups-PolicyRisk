library(dplyr)
library(tidyverse)
library(MASS)

# Regression Model Salience x Lobbying behaviour

# load salience dataset & rename the subtopic
salience_df <- read_csv("datasets/salience.csv")
salience_df <- salience_df %>% 
  mutate(Subtopic=recode(Subtopic, 
                         'Renewable'='renewable_energy', 
                         'Fossil'='fossil_fuels',
                         'Nuclear'='nuclear_energy',
                         'Solar'= 'solar_power',
                         'Wind'='wind_power',
                         'Hydropower' = 'hydropower',
                         'Biofuels'='biofuels',
                         'Evehicles'='electric_vehicles'))


#load final dataset
dataframe_final <- read_csv("datasets/energy_policy_lobbying.csv")


# Model 1: Total amount / times lobbied in the last 10 years depending on overall salience in last 10 years ####

#new dataframe: for each subtopic, global salience & total times lobbied

lobbying_model1_df <- dataframe_final %>%
  #get variables of interest
  select(times_lobbied, total_amout, policy_issue) %>%
  #bring to one row per subtopic (summing times lobbied & total amount)
  group_by(policy_issue) %>%
  summarise_all(funs(sum))
  

#collapse salience df to one row per subtopic (summing too)
salience_model1_df <- salience_df %>% 
  select(-Year)%>%
  group_by(Subtopic) %>%
  summarise_all(funs(sum))


#join both datasets
final_model1_df <- left_join(lobbying_model1_df, salience_model1_df, by = c("policy_issue"="Subtopic"))


#univariate linear regression
Model1_1 <- lm(total_amout ~ NbrStudies, data = final_model1_df)
summary(Model1_1) #not significant

Model1_2 <- lm(times_lobbied ~ NbrStudies, data = final_model1_df)
summary(Model1_2) #not significant

#negative binomial regression
Model1_3 <- glm.nb(times_lobbied ~ NbrStudies, data=final_model1_df)
summary(Model1_3) #not significant


# -> number of Qs/studies on a subtopic is NOT significantly correlated to times lobbied OR amount spent it over 10 years






