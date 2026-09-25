## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "05"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


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


## ----convert-Rnw-to-R,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

