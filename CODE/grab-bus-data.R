# Title: Access Winnipeg Open Data using httr and jsonlite
# Description: This script fetches traffic data from the Winnipeg Open Data portal
# by treating the OData endpoint as a standard JSON API.

# Step 1: Install and load necessary packages
# If you haven't installed these packages yet, uncomment the lines below to do so.
# install.packages("httr")
# install.packages("jsonlite")

library(httr)
library(jsonlite)

# Step 2: Define the OData endpoint URL
# This is the URL you provided for the Traffic Flow Map data.
api_url <- "https://data.winnipeg.ca/api/odata/v4/gp3k-am4u"

# Step 3: Make the HTTP GET request
cat("Requesting data from the API...\n")
response <- GET(api_url)

# Step 4: Check the response status
# This will stop the script and show an error if the request was not successful (e.g., 404 Not Found).
stop_for_status(response)
cat("Successfully retrieved data.\n\n")

# Step 5: Extract and parse the JSON content
# The content() function retrieves the body of the response.
# We specify "text" to get it as a character string that fromJSON() can parse.
# In OData v4, the actual array of records is typically inside a list named "value".
raw_content <- content(response, "text", encoding = "UTF-8")
data_list <- fromJSON(raw_content)

# The data is in the 'value' element of the list
traffic_df <- data_list$value

# Step 6: Inspect the retrieved data
cat("--- First 6 Rows of Traffic Data ---\n")
print(head(traffic_df))

cat("\n--- Data Structure ---\n")
str(traffic_df)

cat(paste("\nSuccessfully loaded", nrow(traffic_df), "records.\n"))
