import requests
import pandas as pd
import datetime as dt

from config import api_key

lobbying_history = {}

subtopic = "biofuels"
url = "https://lda.senate.gov/api/v1/filings/?filing_dt_posted_after=%s&filing_dt_posted_before=%s&filing_specific_lobbying_issues=%s" %("2011-01-01", "2021-12-31", subtopic)
headers= {"Authorization": api_key}
payload = {}

while True:
    response = requests.request("GET", url, headers=headers, data = payload).json()

    for item in response['results']:
        lobbying_history[item['filing_uuid']] = [item['registrant']['name'], item['client']['name'], item['expenses'], item['dt_posted'], item['filing_year']]


    if response['next'] != None:
        url = response['next']
        
    else:
        break


#'count' gives the total number of filings for this specific request 
#!! max items per page = 25 
    # SO if want a dictionary with everything: iterate from all the pages (using the 'next') 


#from response: create a dictionary with registrant name as key and amount reported, date posted, filing year as values
    #lobbying_history[n] = {'name' = [$xxx, 11-02-2011, 2011]}


#convert the dictionary to a pandas df and export as csv 
df = pd.DataFrame.from_dict(lobbying_history, orient='index')
df.to_csv('test1.csv')

print(df)


