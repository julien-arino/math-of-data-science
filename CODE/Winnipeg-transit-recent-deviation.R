library(readr)
library(dplyr)
library(lubridate)

data <- read_csv("~/Downloads/Recent_Transit_On-Time_Performance_Data_20251007.csv")
data_stop = data %>%
  filter(`Stop Number` == 60675) %>%
  filter(`Day Type` == "Weekday") %>%
  mutate(
    # Parse the datetime string once
    datetime = ymd_hms(`Scheduled Time`),
    # Create the columns from the previous steps
    date = as_date(datetime),
    time = format(datetime, "%H:%M"),
    # Create the new numerical time column
    time_decimal = hour(datetime) + minute(datetime) / 60 + second(datetime) / 3600,
    # Clean up the intermediate datetime column
    .keep = "unused"
  ) %>%
  filter(abs(Deviation) <= 1800)

plot(data_stop$time_decimal, data_stop$Deviation)
