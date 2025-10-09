## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "10"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## ----load-hockey-data---------------------------------------------------------
# From https://figshare.com/ndownloader/files/5303173
data = read.csv("https://github.com/julien-arino/math-of-data-science/raw/refs/heads/main/DATA/hockey-players.csv")
dim(data)


## ----show-head-hockey-data----------------------------------------------------
head(data, n=3)


## ----plot-hockey-1,echo=FALSE-------------------------------------------------
plot(data$height, data$weight,
    pch = 19, col = "dodgerblue4",
    main = "IIHF players 2001-2016 (unprocessed)",
    xlab = "Height (cm)", ylab = "Weight (kg)")


## -----------------------------------------------------------------------------
length(unique(data$name)) == dim(data)[1]
length(unique(data$name))


## -----------------------------------------------------------------------------
data_simplified = data.frame(name = unique(data$name))
w = c()
h = c()
for (n in data_simplified$name) {
    tmp = data[which(data$name == n),]
    h = c(h, mean(tmp$height))
    w = c(w, mean(tmp$weight))
}
data_simplified$weight = w
data_simplified$height = h


## -----------------------------------------------------------------------------
data = data_simplified
head(data_simplified, n = 6)


## ----plot-hockey-2,echo=FALSE-------------------------------------------------
plot(data$height, data$weight,
    pch = 19, col = "dodgerblue4",
    main = "IIHF players 2001-2016 (uniqued)",
    xlab = "Height (cm)", ylab = "Weight (kg)")


## ----plot-hockey-centred,echo=1:4---------------------------------------------
mean(data$weight)
mean(data$height)
data$weight.c = data$weight-mean(data$weight)
data$height.c = data$height-mean(data$height)
plot(data$height.c, data$weight.c,
    pch = 19, col = "dodgerblue4",
    main = "IIHF players 2001-2016 (centred)",
    xlab = "Height (cm)", ylab = "Weight (kg)")


## ----convert-Rnw-to-R,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

