import requests
import json
import pandas as pd

from config import api_key

subtopic = "solar energy"
subtopic_edited = "solar_energy"

#url = "https://lda.senate.gov/api/v1/filings/?filing_dt_posted_after=%s&filing_dt_posted_before=%s&filing_specific_lobbying_issues=%s" %("2011-01-01", "2021-12-31", subtopic)
url = "https://lda.senate.gov/api/v1/filings/?filing_uuid=&registrant_id=&registrant_name=&registrant_country=&registrant_ppb_country=&client_id=&client_name=&client_state=&client_country=&client_ppb_state=&client_ppb_country=&lobbyist_id=&lobbyist_name=&lobbyist_covered_position=&lobbyist_conviction_disclosure=&lobbyist_conviction_date_range_after=&lobbyist_conviction_date_range_before=&filing_type=&filing_year=&filing_period=&filing_dt_posted_after=&filing_dt_posted_before=&filing_amount_reported_min=&filing_amount_reported_max=&filing_specific_lobbying_issues=%22solar+energy%22&affiliated_organization_name=&affiliated_organization_country=&foreign_entity_name=&foreign_entity_country=&foreign_entity_ppb_country=&foreign_entity_ownership_percentage_min=&foreign_entity_ownership_percentage_max="

headers= {"Authorization": api_key}
payload = {}

is_first = True

#!! max items per page = 25 
    # SO if want a dictionary with everything: iterate from all the pages (using the 'next') 
    # => RECURSION

def get_filings(url, is_first):
    response = requests.request("GET", url, headers=headers, data = payload).json()

    #global variable to give the count only on the first iteration of the recursion
    if is_first == True:
        #'count' gives the total number of filings for this specific request: give it on the first iteration
        print(response['count'])
        is_first = False

    #gather page's useful data into a dict
    dict = {}
    for item in response['results']:
        if item['filing_uuid'] not in dict.keys():
            dict[item['filing_uuid']] = [item['registrant']['name'], item['client']['name'], item['expenses'], item['dt_posted'], item['filing_year']]
   
    #turn this dict into a pandas df
    a1 = pd.DataFrame.from_dict(dict, orient='index')
    
    #base case: last page
    if response['next'] == None:
        return a1

    #recursion if there is a next page
    else:
        #get the filings at the next page
        b1 = get_filings(response['next'], is_first)
        #concatenate the dataframes (they have the same columns)
        c1 = pd.concat([a1, b1])
        return c1
    

#call the recursion on the original api & turn it into a csv
df = get_filings(url, is_first)
df.to_csv(f"{subtopic_edited}.csv")