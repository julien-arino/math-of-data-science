## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "11"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## ----load-hockey-data, echo=FALSE---------------------------------------------
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


## ----convert-Rnw-to-R,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

