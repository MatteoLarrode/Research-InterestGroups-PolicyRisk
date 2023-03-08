# Exploratory Data Analysis
library(tidyverse)
library(ggplot2)
library(ggthemes)
library(lubridate)


data <- read_csv("data_wrangling/final_dataset.csv")


# Salience -----------------------------------------

# plot total questions
questions_plot <- ggplot(data, aes(x=Year))+
  geom_line(aes(y=NbrQuestions, col=Subtopic))+
  labs(title="Salience of energy policing areas (2011-2021)",
       y = "Number of interview questions",
       caption = "Source: Roper iPoll")+
  scale_x_continuous(breaks = seq(from = 2011, to = 2021, by = 2))+
  scale_color_gdocs()+
  theme_solarized()

questions_plot

#plot total studies
studies_plot <- ggplot(data, aes(x=Year))+
  geom_line(aes(y=NbrStudies, col=Subtopic))+
  labs(title="Salience of energy policing areas (2011-2021)",
       y = "Number of Individual Studies",
       caption = "Source: Roper iPoll")+
  scale_x_continuous(breaks = seq(from = 2011, to = 2021, by = 2))+
  scale_color_gdocs()+
  theme_solarized()

studies_plot

#Lobbying Activity #### -----------------------------------------

lobbying_plot_line <- ggplot(data, aes(x=Year))+
  geom_line(aes(y=total_filings, col=Subtopic))+
  labs(title="Lobbying action in energy policy subtopics (2011-2021)",
       y = "Lobbying filings",
       caption = "Source: https://lda.senate.gov/filings/public/filing/search/")+
  scale_x_continuous(breaks = seq(from = 2011, to = 2021, by = 2))+
  scale_color_gdocs()+
  theme_solarized()

lobbying_plot_line