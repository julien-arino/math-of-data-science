## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "U05"


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
dim(data)[1]


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


## ----worked-example-R-1-------------------------------------------------------
C = matrix(c(1, 1, 1, -1), nrow = 2)
B = diag(2)
CB = cbind(C, B)
(R = pracma::rref(CB))
(P = R[, 3:4])


## ----worked-example-R-2-------------------------------------------------------
x = c(3, 2)
(x_C = P %*% x)

# Verification: reconstruct x in the canonical basis
C %*% x_C


## ----var-hockey-uncentred-----------------------------------------------------
var(data$height)
var(data$weight)


## ----var-hockey-centred-------------------------------------------------------
var(data$height.c)
var(data$weight.c)


## ----cov-hockey-by-hand-------------------------------------------------------
n = length(data$height)
x_bar = sum(data$height) / n
y_bar = sum(data$weight) / n
sum((data$height - x_bar) * (data$weight - y_bar)) / (n - 1)
cov(data$height, data$weight)


## ----cov-matrix-hockey--------------------------------------------------------
cov(data[, c("height", "weight")])


## ----load-hockey-data-2, echo=FALSE-------------------------------------------
# Load the hockey data (as in previous lecture) and centre
# it.
# From https://figshare.com/ndownloader/files/5303173
data = read.csv("https://github.com/julien-arino/math-of-data-science/raw/refs/heads/main/DATA/hockey-players.csv")
data$weight.c = data$weight-mean(data$weight)
data$height.c = data$height-mean(data$height)


## -----------------------------------------------------------------------------
cov(data$height, data$weight)
cov(data$height.c, data$weight.c)


## -----------------------------------------------------------------------------
X = as.matrix(data[,c("height.c", "weight.c")])
S = 1/(dim(X)[1]-1)*t(X) %*% X
S


## -----------------------------------------------------------------------------
var(X[,1])
var(X[,2])


## -----------------------------------------------------------------------------
ev = eigen(S)
ev


## ----plot-hockey-centred-evector----------------------------------------------
plot(data$height.c, data$weight.c,
    pch = 19, col = "dodgerblue4",
    main = "IIHF players 2001-2016 (with first component)",
    xlab = "Height (cm)", ylab = "Weight (kg)")
abline(a = 0, b = ev$vectors[2,1]/ev$vectors[1,1],
       col = "red", lwd = 3)


## -----------------------------------------------------------------------------
theta = atan(ev$vectors[2,1]/ev$vectors[1,1])
theta
R_theta = matrix(c(cos(theta), -sin(theta),
                  sin(theta), cos(theta)),
                nr = 2, byrow = TRUE)
R_theta


## -----------------------------------------------------------------------------
tmp_in = matrix(c(data$weight.c, data$height.c),
                nc = 2)
tmp_out = c()
for (i in 1:dim(tmp_in)[1]) {
    tmp_out = rbind(tmp_out,
                    t(R_theta %*% tmp_in[i,]))
}
data$weight.c_r = tmp_out[,1]
data$height.c_r = tmp_out[,2]


## ----plot-hockey-centred-evector-2,echo=FALSE---------------------------------
plot(data$height.c_r, data$weight.c_r,
    pch = 19, col = "dodgerblue4",
    main = "IIHF players 2001-2016 (rotated to first component)",
    xlab = "x-axis", ylab = "y-axis")


## ----plot-hockey-centred-rotated----------------------------------------------
plot(data$height.c_r, data$weight.c_r,
    pch = 19, col = "dodgerblue4",
    xlab = "x-axis", ylab = "y-axis",
    main = "IIHF players 2001-2016 (rotated to first component)",
    ylim = range(data$weight.c))
abline(h = 0, col = "red", lwd = 2)


## ----plot-hockey-centred-2evectors--------------------------------------------
plot(data$height.c, data$weight.c,
    pch = 19, col = "dodgerblue4",
    main = "IIHF players 2001-2016 (with first and second components)",
    xlab = "Height (cm)", ylab = "Weight (kg)")
abline(a = 0, b = ev$vectors[2,1]/ev$vectors[1,1],
       col = "red", lwd = 3)
abline(a = 0, b = ev$vectors[2,2]/ev$vectors[1,2],
       col = "darkgreen", lwd = 3)


## ----plot-hockey-proper-changed-basis,echo=1:12-------------------------------
red_line = c(1, ev$vectors[2,1]/ev$vectors[1,1])
red_line = red_line/sqrt(sum(red_line^2))
green_line = c(1, ev$vectors[2,2]/ev$vectors[1,2])
green_line = green_line/sqrt(sum(green_line^2))
augmented_M = cbind(red_line,green_line, diag(2))
P = rref(augmented_M)[,3:4]

tmp_in = matrix(c(data$weight.c, data$height.c), nc = 2)
tmp_out = c()
for (i in 1:dim(tmp_in)[1]) {
    tmp_out = rbind(tmp_out, t(P %*% tmp_in[i,]))
}
data$weight.c_r2 = tmp_out[,1]
data$height.c_r2 = tmp_out[,2]
plot(data$height.c_r2, data$weight.c_r2,
    pch = 19, col = "dodgerblue4",
    xlab = "x-axis", ylab = "y-axis",
    main = "IIHF players 2001-2016 (rotated to first component)",
    ylim = range(data$weight.c))
abline(h = 0, col = "red", lwd = 2)
abline(v = 0, col = "darkgreen", lwd = 2)


## -----------------------------------------------------------------------------
GS = pracma::gramSchmidt(A = ev$vectors, tol = 1e-10)
GS


## ----pca-built-in-functions---------------------------------------------------
A=matrix(c(GS$Q,1,0,0,1), nr = 2)
A
pracma::rref(A)


## ----plot-hockey-centred-evector-3,echo=c(1,3,4)------------------------------
P = pracma::rref(A)[,c(3,4)]
P
X.new = X %*% t(P)

plot(X.new[,1], X.new[,2],
     xlab = "x-axis", ylab = "y-axis",
     main = "IIHF players 2001-2016 (rotated to first component)",
     pch = 19, col = "dodgerblue4")


## ----convert-Rnw-to-R-part2,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

