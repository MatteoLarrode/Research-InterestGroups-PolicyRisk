library(tidyverse)

# Collapse data by registrant name #### -----------------------

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
    mutate(date_posted = as.Date(date_posted),
           policy_issue = str_sub(df, end = -5))%>%
    filter(filing_year >= 2011 & filing_year <= 2021)
  
  return(dataframe)}

biofuels_df <- processDataset("biofuels.csv")
evehicles_df <- processDataset("electric_vehicles.csv")
fossil_df <- processDataset("fossil_fuels.csv")
hydro_df <- processDataset("hydropower.csv")
nuclear_df <- processDataset("nuclear_energy.csv")
renew_df <- processDataset("renewable_energy.csv")
solar_df <- processDataset("solar_power.csv")
wind_df <- processDataset("wind_power.csv")


# Collapse all clean datasets #### -----------------------------
data_lobbying <- rbind(
  biofuels_df,
  evehicles_df,
  fossil_df,
  hydro_df,
  nuclear_df,
  renew_df,
  solar_df,
  wind_df
)

write.csv(data_lobbying, "data_wrangling/data_lobbying.csv")


# New dataset: collapse by groups #### ------------------------
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


# Merging: create final data ---------------------------------

#salience
salience_df <- read_csv("data_wrangling/salience.csv", show_col_types = FALSE)
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


#lobbying
lobbying_df <- read_csv("data_wrangling/data_lobbying.csv")

lobbying_grouped_df <- lobbying_df %>%
  group_by(filing_year, policy_issue)%>%
  summarize(total_filings = n(),
            total_spending = sum(amount_reported)) %>%
  rename("Year" = filing_year,
         "Subtopic" = policy_issue)


#time-series: collapse salience & lobbying
data <- merge(salience_df, lobbying_grouped_df, by=c("Year","Subtopic"))
write_csv(data, "data_wrangling/final_dataset.csv")
