library(httr)
library(jsonlite)
library(tidyverse)

#define arguments of function: url, subtopic chosen & name of exit csv file

#url <- "[INSERT URL (use lda website)]"
#subtopic <- "[INSERT SUBTOPIC]"

csvname <- paste0(subtopic,".csv")


get_data <- function(url, subtopic, csvname) {

  #information for GET function
  api_key <- "a11d1ca0026aeefa61592ba43b062da1233c8ad5"
  headers <- add_headers("Authorization" = paste0("Token ",api_key))
  payload <- list()
  
  #initialize dataframe & naming columns
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
  
  #iterate through pages (only 25 elements per page)
  while(!is.null(url)){
    get_response <- GET(url, headers = headers)
    api_response <- fromJSON(content(get_response, "text"), flatten = TRUE)
    results <- api_response$results
    print(api_response$count)
    print(api_response$`next`)
    
    #get info we want from api json response
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
               client.general_description) %>%
        mutate(subtopic = subtopic)
      
      #append this page to the big dataframe
      df <- rbind(df, data)
      #attribute "next" url to url variable, breaking the while loop if last page
      url <- api_response$`next`}
    }
  
  #create csv file! 
  if (length(df) > 0) {
    write.csv(df, paste0(csvname), row.names = FALSE)
    print(paste0("Data for ", subtopic, " fetched and saved to file"))
  } else {
    print("No data available")
  }
}

get_data(url, subtopic, csvname)