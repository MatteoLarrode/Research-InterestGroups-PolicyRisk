library(httr)
library(dplyr)
library(jsonlite)

get_data <- function(subtopic, csvname) {
  api_key <- "a11d1ca0026aeefa61592ba43b062da1233c8ad5"
  
  url <- paste0("https://lda.senate.gov/api/v1/filings/?filing_dt_posted_after=2011-01-01&filing_dt_posted_before=2021-12-31&filing_specific_lobbying_issues=", subtopic)
  
  headers <- add_headers("Authorization" = api_key)
  payload <- list()
  
  data <- list()
  while (url) {
    response <- GET(url, headers = headers, body = payload)
    results <- fromJSON(content(response, "text"), flatten = TRUE)$results
    if (length(results) > 0) {
      data <- c(data, lapply(results, function(item) {
        list(
          filing_uuid = item$filing_uuid,
          registrant_name = item$registrant$name,
          client_name = item$client$name,
          expenses = item$expenses,
          dt_posted = item$dt_posted,
          filing_year = item$filing_year
        )
      }))
    }
    response_json <- fromJSON(content(response, "text"), flatten = TRUE)
    if (exists("response_json$next")) {
      url <- response_json$next
    } else {
      url <- NULL
    }
  }
  
  if (length(data) > 0) {
    df <- bind_rows(data)
    write.csv(df, paste0(csvname), row.names = FALSE)
    print(paste0("Data for ", subtopic, " fetched and saved to file"))
  } else {
    print("No data available")
  }
}

subtopic <- '"solar energy" OR "solar power" OR ("solar" AND "energy")'
get_data(subtopic)
