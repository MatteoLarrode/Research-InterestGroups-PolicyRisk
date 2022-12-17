library(tidyverse)
library(dplyr)

# Collapse data by registrant name ####

processDataset <- function(df){
  #import csv
  dataframe <- read_csv(df)
  
  #clean dataset (take care of NAs, change date format)
  dataframe <- select(dataframe, -1)
  dataframe <- dataframe %>%
    rename(registrant_name = 1,
           client_name = 2,
           amount_reported = 3,
           date_posted = 4,
           filing_year = 5) %>%
    replace(is.na(.), 0) %>%
    mutate(date_posted = as.Date(date_posted))
  
  #new dataset: collapse by groups
  df_groups <- dataframe %>%
    group_by(registrant_name)
  
  #variables: how many times lobbied, total & avg amount, start & end years
  df_summary <- df_groups %>% 
    summarise(
      times_lobbied = n(),
      avg_amount = mean(amount_reported),
      total_amount = sum(amount_reported),
      start_year = min(filing_year),
      end_year = max(filing_year),
      unique_years = n_distinct(filing_year)) %>%
    mutate(policy_issue = str_sub(df, end = -5))
  
  View(df_summary)
  return(df_summary)
}


final_df <- rbind(processDataset("wind_power.csv"), 
                  processDataset("solar_power.csv"), 
                  processDataset("hydropower.csv"),
                  processDataset("electric_vehicles.csv"),
                  processDataset("biofuels.csv"),
                  processDataset("renewable_energy.csv"),
                  processDataset("nuclear_energy.csv"),
                  processDataset("fossil_fuels.csv"))

write_csv(final_df, "energy_policy_lobbying.csv")

dataframe_final <- read_csv("energy_policy_lobbying.csv")



# Collapse data by year ####
