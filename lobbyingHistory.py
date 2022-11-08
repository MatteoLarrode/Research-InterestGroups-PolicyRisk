import requests
import pandas as pd
import datetime as dt

from config import api_key

lobbying_history = {}

subtopic = "electric vehicles"
subtopic_edited = "electric_vehicles"
url = "https://lda.senate.gov/api/v1/filings/?filing_dt_posted_after=%s&filing_dt_posted_before=%s&filing_specific_lobbying_issues=%s" %("2011-01-01", "2021-12-31", subtopic)
headers= {"Authorization": api_key}
payload = {}

is_first = True

#!! max items per page = 25 
    # SO if want a dictionary with everything: iterate from all the pages (using the 'next') 

def get_page_filings(url, is_first):
    response = requests.request("GET", url, headers=headers, data = payload).json()

    if is_first == True:
        #'count' gives the total number of filings for this specific request: give it on the first iteration
        print(response['count'])

    for item in response['results']:
        lobbying_history[item['filing_uuid']] = [item['registrant']['name'], item['client']['name'], item['expenses'], item['dt_posted'], item['filing_year']]

    return response['next']


#iterate through all page by jumping from one to the next using the 'next' variable
while url != None:
    url = get_page_filings(url, is_first)
    is_first = False


#get the filings of the last page: PROBLEM
get_page_filings(url, is_first)


#convert the dictionary to a pandas df and export as csv 
df = pd.DataFrame.from_dict(lobbying_history, orient='index')
df.to_csv(f"{subtopic_edited}1.csv")

print(df)


