# Exploratory Data Analysis #### -----------------------------------------
library(dplyr)
library(readr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(lubridate)

# Salience #### -----------------------------------------
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
#turn years into date format (just in case)
salience_df$Year_Date <- lubridate::ymd(salience_df$Year, truncated = 2L)

# plot total questions
questions_plot <- ggplot(salience_df, aes(x=Year))+
  geom_line(aes(y=NbrQuestions, col=Subtopic))+
  labs(title="Salience of energy policing areas (2011-2021)",
       y = "Number of interview questions",
       caption = "Source: Roper iPoll")+
  scale_x_continuous(breaks = seq(from = 2011, to = 2021, by = 2))+
  scale_color_gdocs()+
  theme_solarized()

questions_plot

#plot total studies
studies_plot <- ggplot(salience_df, aes(x=Year))+
  geom_line(aes(y=NbrStudies, col=Subtopic))+
  labs(title="Salience of energy policing areas (2011-2021)",
       y = "Number of Individual Studies",
       caption = "Source: Roper iPoll")+
  scale_x_continuous(breaks = seq(from = 2011, to = 2021, by = 2))+
  scale_color_gdocs()+
  theme_solarized()

studies_plot

#Lobbying Activity #### -----------------------------------------
data <- read_csv("data_wrangling/data_lobbying.csv")

data_grouped_df <- data %>%
  group_by(filing_year, policy_issue)%>%
  summarize(total = n())

lobbying_plot_line <- ggplot(data_grouped_df, aes(x=filing_year))+
  geom_line(aes(y=total, col=policy_issue))+
  labs(title="Lobbying action in energy policy subtopics (2011-2021)",
       y = "Lobbying filings",
       caption = "Source: https://lda.senate.gov/filings/public/filing/search/")+
  scale_x_continuous(breaks = seq(from = 2011, to = 2021, by = 2))+
  scale_color_gdocs()+
  theme_solarized()

lobbying_plot_line
