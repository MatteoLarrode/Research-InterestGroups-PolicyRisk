library(httr)
library(dplyr)
library(jsonlite)

get_data <- function(subtopic, csvname) {
  api_key <- "a11d1ca0026aeefa61592ba43b062da1233c8ad5"
  
  url <- paste0("https://lda.senate.gov/api/v1/filings/?filing_dt_posted_after=2011-01-01&filing_dt_posted_before=2021-12-31&filing_specific_lobbying_issues=", subtopic)
  
  headers <- add_headers("Authorization" = paste0("Token ",api_key))
  payload <- list()
  
  df <- data.frame(Doubles=double(),
                    Integers=integer(),
                    Factors=factor(),
                    Logicals=logical(),
                    Characters=character(),
                    stringsAsFactors=FALSE)
  

  while(!is.null(url)){
    get_response <- GET(url, headers = headers)
    api_response <- fromJSON(content(get_response, "text"), flatten = TRUE)
    results <- api_response$results
    print(api_response$count)
    print(api_response$`next`)
    
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
      url <- api_response$`next`}
    }

  if (length(df) > 0) {
    write.csv(df, paste0(csvname), row.names = FALSE)
    print(paste0("Data for ", subtopic, " fetched and saved to file"))
  } else {
    print("No data available")
  }
}

subtopic <- '"electric vehicles"'
get_data(subtopic, "test.csv")
