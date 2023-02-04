# Exploratory Data Analysis
library(tidyverse)
library(ggplot2)
library(ggthemes)
library(lubridate)

# Load & clean datasets ---------------------------------

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





# Salience -----------------------------------------

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

lobbying_plot_line <- ggplot(lobbying_grouped_df, aes(x=Year))+
  geom_line(aes(y=total, col=Subtopic))+
  labs(title="Lobbying action in energy policy subtopics (2011-2021)",
       y = "Lobbying filings",
       caption = "Source: https://lda.senate.gov/filings/public/filing/search/")+
  scale_x_continuous(breaks = seq(from = 2011, to = 2021, by = 2))+
  scale_color_gdocs()+
  theme_solarized()

lobbying_plot_line


#Lobbying Activity & Salience #### -----------------------------------------


