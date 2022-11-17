library(tidyverse)
library(dplyr)

#import csv's
deportation_df <- read_csv("deportation1.csv")

#clean dataset (take care of NAs, change date format)
deportation_df <- select(deportation_df, -1)
deportation_df <- deportation_df %>%
  rename(registrant_name = 1,
  client_name = 2,
  amount_reported = 3,
  date_posted = 4,
  filing_year = 5) %>%
  replace(is.na(.), 0) %>%
  mutate(date_posted = as.Date(date_posted))


#new dataset: collapse by groups
deportation_groups <- deportation_df %>%
  group_by(registrant_name)

#variables: how many times lobbied, total & avg amount, start & end years
deportation_summary <- deportation_groups %>% summarise(
  times_lobbied = n(),
  avg_amount = mean(amount_reported),
  total_amout = sum(amount_reported),
  start_year = min(filing_year),
  end_year = max(filing_year)
)




