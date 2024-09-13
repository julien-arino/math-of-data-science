library(dplyr)
library(readr)

WPP2024_PopulationBySingleAgeSex_Medium_1950_2023 <- 
  read_csv("~/Documents/Courses/MATH-2740/2024-fall-assignments/WPP2024_PopulationBySingleAgeSex_Medium_1950-2023.csv")

pop = WPP2024_PopulationBySingleAgeSex_Medium_1950_2023 %>%
  group_by(Time, LocID) %>%
  summarize(
    ISO3_code = first(ISO3_code),
    Location = first(Location),
    SumPopTotal = 1000*sum(PopTotal, na.rm = TRUE)) %>%
  filter(!is.na(ISO3_code))

write_csv(pop, "WPP2024_Population_1950_2023.csv")
