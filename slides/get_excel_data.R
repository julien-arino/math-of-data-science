# library(readxl)
# download.file(url = url, 
#               destfile = "dataset.xlsx",
#               mode="wb")
# data = read_excel("dataset.xls")

library(tidyverse)
library(rio)

data = rio::import(file = "https://repository.lboro.ac.uk/ndownloader/files/14015774", 
                   format = "xlsx") # %>%
  # glimpse
View(data)


data = read.csv("https://figshare.com/ndownloader/files/5303173")
# First, we make a data frame with just the names
data_simplified = data.frame(name = unique(data$name))
w = c()
h = c()
for (n in data_simplified$name) {
  tmp = data[which(data$name == n),]
  #if (length(unique(tmp$height)) > 1) {
  #    writeLines(paste0(n, " has different heights"))
  #}
  h = c(h, mean(tmp$height))
  w = c(w, mean(tmp$weight))
}
data_simplified$weight = w
data_simplified$height = h
data = data_simplified

pdf("slides-08-hockey_players_raw.pdf", width = 10, height = 8)
plot(data$height, data$weight,
     pch = 19, col = "dodgerblue4",
     xlab = "Height (cm)", ylab = "Weight (kg)")
dev.off()


# Now centre the data
data$weight_centred = data$weight-mean(data$weight)
data$height_centred = data$height-mean(data$height)

pdf("slides-08-hockey_players_centred.pdf", width = 10, height = 8)
plot(data$height_centred, data$weight_centred,
     pch = 19, col = "dodgerblue4",
     xlab = "Height (cm)", ylab = "Weight (kg)")
dev.off()

S_X = as.matrix(data[,c("height_centred", "weight_centred")]) %*%
  t(as.matrix(data[,c("height_centred", "weight_centred")]))
