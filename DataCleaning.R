library(tidyverse)
library(dplyr)

processDataset <- function(df){
  #import csv
  df <- read_csv(df)
  
  #clean dataset (take care of NAs, change date format)
  df <- select(df, -1)
  df <- df %>%
    rename(registrant_name = 1,
           client_name = 2,
           amount_reported = 3,
           date_posted = 4,
           filing_year = 5) %>%
    replace(is.na(.), 0) %>%
    mutate(date_posted = as.Date(date_posted))
  
  
  #new dataset: collapse by groups
  df_groups <- df %>%
    group_by(registrant_name)
  
  #variables: how many times lobbied, total & avg amount, start & end years
  df_summary <- df_groups %>% 
    summarise(
      times_lobbied = n(),
      avg_amount = mean(amount_reported),
      total_amout = sum(amount_reported),
      start_year = min(filing_year),
      end_year = max(filing_year),
      unique_years = n_distinct(filing_year))
  
  return(df_summary)
}
