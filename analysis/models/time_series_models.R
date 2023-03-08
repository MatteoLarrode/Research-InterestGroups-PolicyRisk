# Modeling: Time-Series
library(vars)
library(tidyverse)
library(xts)
library(TSstudio)

data <- read_csv("data_wrangling/final_dataset.csv")

#turn year into date for time series (chose the end of the year because data counts cumulative values)
data$Year <- as.Date(paste(data$Year, 12, 31, sep = "-"))

#create time series (renewable energy)
renew_df <- data %>%
  filter(Subtopic == "renewable_energy")%>%
  dplyr::select("Year", "NbrStudies", "total_filings")

renew_xts <- xts(renew_df[ , colnames(renew_df) != "Year"], renew_df$Year)


#Vector Autoregression (VAR)------------------------------

ts_plot(renew_ts$total_filings)
ts_plot(renew_ts$NbrStudies)

#test whether variables are stationary (-> both are non-stationary)
pp.test(renew_ts$total_filings)
pp.test(renew_ts$NbrStudies)

#determine lag order (??) -> doesn't work (Error in embed(y, lag) : wrong embedding dimension)
lagselect <- VARselect(renew_xts, lag.max = 15, type = "const")
lagselect$selection

#VAR (use of default lag order and choice of type isnt' clear)
Model1 <- VAR(renew_xts, type = "const", season = NULL, exog = NULL) 
summary(Model1)


# Granger causality testing
GrangerSalience<- causality(Model1, cause = "NbrStudies")
GrangerSalience

GrangerLobbying <- causality(Model1, cause = "total_filings")
GrangerLobbying


# Impulse response functions
salience_irf <- irf(Model1, impulse = "NbrStudies", response = "total_filings", boot = TRUE)
plot(salience_irf)

filings_irf <- irf(Model1, impulse = "total_filings", response = "NbrStudies", boot = TRUE)
plot(filings_irf, ylab = "M1", main = "RRP's shock to M1")



#ARIMA model with intervention -----------------------