## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "U03"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## ----load-census-csv-1--------------------------------------------------------
prefix = "https://www150.statcan.gc.ca/n1/en/pub/11-516-x/sectiona/"
page = "A2_14-eng.csv?st=L7vSnqio"
url = paste0(prefix, page)
data_old = read.csv(url)


## ----load-census-csv-2--------------------------------------------------------
head(data_old)


## -----------------------------------------------------------------------------
head(data_old, n = 1)


## ----load-census-csv-3--------------------------------------------------------
data_old = read.csv(url, skip = 2)
head(data_old, n = 2)


## -----------------------------------------------------------------------------
data_old = data_old[5:dim(data_old)[1], 2:3]
head(data_old, n=4)


## -----------------------------------------------------------------------------
head(data_old, n=3)
tail(data_old, n=2)


## -----------------------------------------------------------------------------
data_old = data_old[which(data_old$Canada != ""),]
data_old$Canada = gsub(",", "", data_old$Canada)
order_data = order(data_old$Year)
data_old = data_old[order_data,]
data_old$Year = as.numeric(data_old$Year)
data_old$Canada = as.numeric(data_old$Canada)
head(data_old)


## -----------------------------------------------------------------------------
row.names(data_old) = 1:dim(data_old)[1]
head(data_old)


## ----plot-old-Canada-census-data,fig.show='asis',fig.height=3.5---------------
plot(data_old$Year, data_old$Canada,
    type = "b", lwd = 2,
    xlab = "Year", ylab = "Population")


## ----load-newer-census-data---------------------------------------------------
data_new = read.csv("https://www12.statcan.gc.ca/census-recensement/2011/dp-pd/vc-rv/download-telecharger/download-telecharger.cfm?Lang=eng&CTLG=98-315-XWE2011001&FMT=csv")


## -----------------------------------------------------------------------------
data_new[sort(unique(c(1,sample(nrow(data_new), 4)))), ]


## -----------------------------------------------------------------------------
idx_CAN = which(data_new$GEOGRAPHY.NAME == "Canada")
idx_char = which(data_new$CHARACTERISTIC == "Population (in thousands)")
idx_keep = intersect(idx_CAN, idx_char)


## -----------------------------------------------------------------------------
data_new = data_new[idx_keep,]
head(data_new, n = 8)


## -----------------------------------------------------------------------------
colnames(data_old) = c("year", "population")
data_new = data_new[,c("YEAR.S.","TOTAL")]
colnames(data_new) = c("year", "population")
data_new$year = as.numeric(data_new$year)
data_new = data_new[which(data_new$year>1976),]
data_new$population = data_new$population*1000

data = rbind(data_old,data_new)


## ----plot-whole-Canada-census-data,fig.show='asis',fig.height=3.5-------------
plot(data$year, data$population,
    type = "b", lwd = 2,
    xlab = "Year", ylab = "Population")


## -----------------------------------------------------------------------------
write.csv(data, file = "../CODE/Canada_census.csv")


## -----------------------------------------------------------------------------
readr::write_csv(data, file = "../CODE/Canada_census.csv")


## ----plot-2-points,echo=FALSE,fig.show='asis',fig.height=3.5------------------
points = list()
points$x = c(1,2)
points$y = c(3,5) # So the points are (1,3) and (2,5)
plot(points$x, points$y, 
     pch = 19, cex = 1.5, bty = "n",
     xlim = c(0, 3), ylim = c(0,7), 
     xlab = "x", ylab = "y")


## ----solve-2x2-system---------------------------------------------------------
A = matrix(c(1,1,1,2), nr = 2, nc = 2, byrow = TRUE)
rhs = matrix(c(3,5), nr = 2, nc =1)
coefs = solve(A,rhs)
coefs


## ----plot-2-points-and-line,echo=FALSE,fig.show='asis',fig.height=3.5---------
plot(points$x, points$y, 
     pch = 19, cex = 1.5, bty = "n",
     xlim = c(0, 3), ylim = c(0,7), xlab = "x", ylab = "y")
x = seq(0,3,length.out = 100)
y = coefs[1] + coefs[2]*x
lines(x,y, lwd = 2, col = "darkred")


## ----plot-3-points-and-line-0,echo=FALSE,fig.show='asis',fig.height=3---------
points = list()
points$x = c(1,2,3)
points$y = c(3,5,4) # So the points are (1,3), (2,5) and (3,4)
plot(points$x, points$y,
     pch = 19, cex = 1.5, bty = "n",
    xlim = c(0, 3.5), ylim = c(0,7), 
    xlab = "x", ylab = "y")


## ----plot-3-points-and-line-1,echo=FALSE,fig.show='asis',fig.height=3---------
A = matrix(c(1,1,1,2), nr = 2, nc = 2, byrow = TRUE)
rhs = matrix(c(3,5), nr = 2, nc =1)
coefs = solve(A,rhs) # To invert A, in R, you use solve(A), to solve Ax=b, you use solve(A,b)
plot(points$x, points$y,
     pch = 19, cex = 1.5, bty = "n",
    xlim = c(0, 3.5), ylim = c(0,7), 
    xlab = "x", ylab = "y")
x = seq(0,3.5,length.out = 100)
y = coefs[1] + coefs[2]*x
lines(x,y, lwd = 2, col = "darkred")


## ----plot-3-points-and-line-2,echo=FALSE,fig.show='asis',fig.height=3---------
plot(points$x, points$y,
     pch = 19, cex = 1.5, bty = "n",
    xlim = c(0, 3.5), ylim = c(0,8), xlab = "x", ylab = "y")
abline(coef = coefs, lwd = 2, col = "darkred")
abline(a = 3, b = 0.5, lwd = 2, col = "dodgerblue4")


## ----define-affine-function---------------------------------------------------
my_line = function(x, a_0, a_1){
    return(a_0 + a_1*x)
}


## ----examples-use-affine-function---------------------------------------------
my_line(1,2,3)
my_line(a_0 = 2, a_1 = 3, x = 1)
my_line(x = c(1,2,3), a_0 = 2, a_1 = 3)


## ----plot-3-points-and-line-3,echo=FALSE,fig.show='asis',fig.height=3.5-------
a = 3
b = 0.5 # The line has equation y=a+bx
plot(points$x, points$y,
     pch = 19, cex = 1.5, bty = "n",
    xlim = c(0, 3.5), ylim = c(0,6), xlab = "x", ylab = "y")
x = seq(0,3.5,length.out = 100)
y = a + b*x
lines(x,y, lwd = 2, col = "dodgerblue4")
abline(v = c(1,2,3), lwd = 0.5, lty = 2)
p = my_line(c(1,2,3), a, b)
points(c(1,2,3), p, pch = 19, cex = 1.5, col = "red")


## ----define-error-function----------------------------------------------------
error = function(a_0, a_1, points) {
    y_tilde = my_line(points$x, a_0 = a_0, a_1 = a_1)
    e = points$y - y_tilde
    return(sqrt(sum(e^2)))
}
error(a_0 = 2, a_1 = 3, points)
error(a_0 = 3, a_1 = 0.5, points)
error(a_0 = 3.1, a_1 = 0.48, points)


## ----run-plot-ga--------------------------------------------------------------
if (!require("GA", quietly = TRUE)) {
  install.packages("GA")
  library(GA)
}
GA = ga(type = "real-valued",
        fitness = function(x) -error(a_0 = x[1], a_1 = x[2], points),
        suggestions = c(a_0 = 2, a_1 = 3),
        lower = c(-10, -10), upper = c(10, 10),
        popSize = 200, maxiter = 150)


## ----show-GA-return-----------------------------------------------------------
GA


## ----show-GA-solution---------------------------------------------------------
GA@solution


## ----show-GA-fitness-value----------------------------------------------------
-GA@fitnessValue


## ----show-GA-convergence,echo=FALSE,fig.show='asis'---------------------------
plot(GA)


## ----canada-census-plot, fig.height=4, fig.width=6, out.width="0.7\\textwidth", fig.align='center'----
canada = read.csv("../DATA/Canada_census.csv")
canada = as.data.frame(canada)
plot(canada, main = "Canadian Population over Time", 
     xlab = "Year", ylab = "Population")


## ----canada-census-linear-setup-----------------------------------------------
b = canada$population
A = matrix(ncol = 2, nrow = dim(canada)[1],
           data = c(rep(1, dim(canada)[1]),
                    canada$year))


## ----canada-census-linear-solve-----------------------------------------------
ATA = t(A) %*% A
invATA = solve(ATA)
x_tilde = invATA %*% t(A) %*% b


## ----canada-census-linear-coeffs, echo=FALSE----------------------------------
x_tilde


## ----canada-census-linear-plot, fig.height=3.5, fig.width=6, out.width="0.6\\textwidth", fig.align='center'----
x_axis = seq(canada$year[1], max(canada$year), 1)
y_fitted = x_tilde[1] + x_tilde[2] * x_axis

plot(canada, ylim = c(min(y_fitted), max(canada$population)))
lines(x_axis, y_fitted, col = "red", lwd = 2)


## ----canada-census-quad-setup-------------------------------------------------
A2 = matrix(ncol = 3, nrow = dim(canada)[1],
            data = c(rep(1, dim(canada)[1]),
                     canada$year,
                     canada$year^2))


## ----canada-census-quad-solve-------------------------------------------------
ATA2 = t(A2) %*% A2
invATA2 = solve(ATA2)


## ----canada-census-quad2-setup------------------------------------------------
A3 = matrix(ncol = 3, nrow = dim(canada)[1],
            data = c(rep(1, dim(canada)[1]),
                     canada$year - min(canada$year),
                     (canada$year - min(canada$year))^2))


## ----canada-census-quad2-solve------------------------------------------------
ATA3 = t(A3) %*% A3
invATA3 = solve(ATA3)
x_tilde = invATA3 %*% t(A3) %*% b


## ----canada-census-quad2-coeffs, echo=FALSE-----------------------------------
x_tilde


## ----canada-census-quad2-plot, fig.height=3.5, fig.width=6, out.width="0.6\\textwidth", fig.align='center'----
y_fitted_quad = x_tilde[1] + 
  x_tilde[2] * (x_axis - min(canada$year)) + 
  x_tilde[3] * (x_axis - min(canada$year))^2

plot(canada, ylim = c(min(y_fitted), max(canada$population)))
lines(x_axis, y_fitted, col = "red", lwd = 2) # Linear
lines(x_axis, y_fitted_quad, col = "blue", lwd = 2) # Quadratic


## ----convert-Rnw-to-R-part2,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

