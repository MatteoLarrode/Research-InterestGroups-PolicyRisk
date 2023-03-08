library(httr)
library(dplyr)
library(jsonlite)

api_key <- "a11d1ca0026aeefa61592ba43b062da1233c8ad5"

subtopic <- '"solar energy" OR "solar power" OR ("solar" AND "energy")'

url <- paste0("https://lda.senate.gov/api/v1/filings/?filing_dt_posted_after=2011-01-01&filing_dt_posted_before=2021-12-31&filing_specific_lobbying_issues=", subtopic)
headers <- add_headers("Authorization" = paste0("Token ",api_key))

get_response <- GET(url, headers = headers)
api_response <- fromJSON(content(get_response, "text"), flatten = TRUE)
results <- api_response$results


df <- data.frame(filing_id=character(),
                 filing_year=integer(),
                 filing_period=character(),
                 filing_period_display = character(),
                 expenses=character(),
                 expenses_method_display = character(),
                 registrant_name = character(),
                 registrant_description = character(),
                 client_name = character(),
                 client_description = character(),
                 stringsAsFactors=FALSE)


while(!is.null(url)){
  get_response <- GET(url, headers = headers)
  api_response <- fromJSON(content(get_response, "text"), flatten = TRUE)
  results <- api_response$results
  if (length(results) > 0) {
    data <- results %>%
      select(filing_uuid, 
             filing_year, 
             filing_period_display, 
             expenses, 
             expenses_method_display, 
             registrant.name, 
             registrant.description, 
             client.name, 
             client.general_description)
    
    df <- rbind(df, data)
    
    url <- api_response$`next`
    }
}




