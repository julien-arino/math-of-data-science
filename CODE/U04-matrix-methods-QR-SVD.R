## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "U04"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## ----convert-Rnw-to-R-part1,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()


## ----echo=FALSE,results='hide'------------------------------------------------
A <- matrix(c(1, 1, 0, 1, 0, 1), nrow=3, byrow=FALSE)
qr_A <- qr(A)
Q_A <- qr.Q(qr_A)
R_A <- qr.R(qr_A)

## ----label="qr-example-r-lsq"-------------------------------------------------
b <- c(2, 3, 4)
QT_b <- t(Q_A) %*% b
x_tilde <- solve(R_A, QT_b)
x_tilde
qr.coef(qr_A, b) # with the built-in solver


## ----label='qr-canada-census-extract-data'------------------------------------
data <- read.csv("../DATA/Canada_census.csv")
data <- data[which(data$year <= 1980),]
x <- data$year
y <- data$population
A_q <- matrix(c(rep(1, length(x)), x, x^2), nr = length(x), nc = 3)


## ----label='qr-canada-census-normal-fail'-------------------------------------
ATA <- t(A_q) %*% A_q
try(solve(ATA) %*% t(A_q) %*% y)


## ----label='qr-canada-census-fit'---------------------------------------------
# Compute the QR decomposition of A_q
QR <- qr(A_q)
Q <- qr.Q(QR)
R <- qr.R(QR)

# Solve Rx = Q^T y
sol_qr <- backsolve(R, t(Q) %*% y)
sol_qr


## ----label='qr-canada-census-solve'-------------------------------------------
sol_qr_direct <- qr.solve(A_q, y)
sol_qr_direct


## ----plot-image-svd-original,echo=c(1:3,7),crop=TRUE--------------------------
my_image = bmp::read.bmp("../CODE/Julien_and_friend_1000x800.bmp")
my_image_g = pixmap::pixmapGrey(my_image)
my_image_g
pixmap::plot(my_image_g)


## ----image-compression-svd-compute-MTM----------------------------------------
M = my_image_g@grey
MTM = t(M) %*% M
# Ensure matrix is symmetric
MTM = (MTM+t(MTM))/2
ev = eigen(MTM)


## ----image-compression-svd-zero-evalues---------------------------------------
ev$values = ev$values*(ev$values>1e-10)


## ----image-compression-svd-check-evalues--------------------------------------
any(duplicated(ev$values[ev$values>1e-10]))


## -----------------------------------------------------------------------------
idx_positive_ev = which(ev$values>1e-10)
sv = sqrt(ev$values[idx_positive_ev])


## -----------------------------------------------------------------------------
D = diag(sv)
V = ev$vectors[idx_positive_ev, idx_positive_ev]
c1 = colSums(V)
for (i in 1:dim(V)[2]) {
    V[,i] = V[,i]/c1[i]
}


## -----------------------------------------------------------------------------
U = M %*% V %*% diag(1/sv)
r = length(sv)
im = list(u=U, d=sv, v=V)


## -----------------------------------------------------------------------------
M.svd = svd(M)


## ----compress-image-function--------------------------------------------------
compress_image = function(im, n) {
  if (n > length(im$d)) {
    # Check that we gave a value of n within range, otherwise 
    # just set to the max
    n = length(im$d)
  }
  d_tmp = im$d[1:n]
  u_tmp = im$u[,1:n]
  v_tmp = im$v[,1:n]
  # Store the results in a list (so we can return other information)
    out = list()
    # First, compute the resulting image
    out$img = mat.or.vec(nr = dim(im$u)[1], nc = dim(im$v)[1])
    for (i in 1:n) {
        out$img = out$img + d_tmp[i] * u_tmp[,i] %*% t(v_tmp[,i]) 
    }
    
    
    # Values of "colours" must be in [0,1], so shift and rescale
    if (min(min(out$img)) < 0 ) {
        out$img = out$img - min(min(out$img))
    }
    out$img = out$img / max(max(out$img))
    # Store some information: # points needed and % of the original
    out$nb_pixels_original = dim(im$u)[1] * dim(im$v)[2]
    out$nb_pixels_compressed = length(d_tmp) + 
      dim(u_tmp)[1]*dim(u_tmp)[2] + 
      dim(v_tmp)[1]*dim(v_tmp)[2] 
    out$pct_of_original = out$nb_pixels_compressed / 
      out$nb_pixels_original * 100
    # Return the result
    return(out)
}


## ----plot-image-svd-n2,crop=TRUE----------------------------------------------
new_image = my_image_g
M.svd = svd(M)
M_tmp = compress_image(M.svd, 2)
new_image@grey = M_tmp$img
plot(new_image)


## ----plot-image-svd-n5,echo=FALSE,crop=TRUE-----------------------------------
M_tmp = compress_image(M.svd, 5)
new_image@grey = M_tmp$img
plot(new_image)


## ----plot-image-svd-n10,echo=FALSE,crop=TRUE----------------------------------
M_tmp = compress_image(M.svd, 10)
new_image@grey = M_tmp$img
plot(new_image)


## ----plot-image-svd-n20,echo=FALSE,crop=TRUE----------------------------------
M_tmp = compress_image(M.svd, 20)
new_image@grey = M_tmp$img
plot(new_image)


## ----plot-image-svd-n50,echo=FALSE,crop=TRUE----------------------------------
M_tmp = compress_image(M.svd, 50)
new_image@grey = M_tmp$img
plot(new_image)


## ----convert-Rnw-to-R-part2,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()


## ----convert-Rnw-to-R-part3,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

