## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "12"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## ----plot-svm-example---------------------------------------------------------
set.seed(10111)
x = matrix(rnorm(40), 20, 2)
y = rep(c(-1, 1), c(10, 10))
x[y == 1,] = x[y == 1,] + 1
plot(x, col = y + 3, pch = 19)


## ----svm-base-optimize-1,echo=TRUE,results='show'-----------------------------
X <- x
Y <- as.numeric(y)
n <- nrow(X); p <- ncol(X)

# Initialize parameters
w <- rep(0, p)
b <- 0
lambda <- 0.05   # Regularization strength
lr <- 0.1        # learning rate
epochs <- 5000


## ----svm-base-optimize-2,echo=TRUE,results='show'-----------------------------
for (t in 1:epochs) {
    margins <- Y * (as.vector(X %*% w) - b)
    active <- margins < 1  # points violating margin
    if (any(active)) {
        grad_w <- 2 * lambda * w - 
          colSums( (Y[active] * X[active, , drop = FALSE]) ) / n
        grad_b <-  sum(Y[active]) / n
    } else {
        grad_w <- 2 * lambda * w
        grad_b <- 0
    }
    # parameter update
    w <- w - lr * grad_w
    b <- b - lr * grad_b
    # mild decay for stability
    if (t %% 1000 == 0) lr <- lr * 0.9
}

cat("w:", paste(round(w, 3), collapse = ", "), 
    " b:", round(b, 3), "\n")


## ----plot-svm-base-result,echo=FALSE,fig.width=6,fig.height=4-----------------
plot(X, col = Y + 3, pch = 19)
# Draw decision boundary w^T x - b = 0 and margins = ±1
if (abs(w[2]) > 1e-8) {
    abline(b / w[2], -w[1] / w[2])
    abline((b - 1) / w[2], -w[1] / w[2], lty = 2)
    abline((b + 1) / w[2], -w[1] / w[2], lty = 2)
}
# Highlight near-margin points as approximate support vectors
margins <- Y * (as.vector(X %*% w) - b)
near <- abs(margins - 1) < 0.15
if (any(near)) points(X[near, , drop = FALSE], pch = 5, cex = 1.8)


## ----plot-svm-example-result--------------------------------------------------
dat = data.frame(x, y = as.factor(y))
svmfit = svm(y ~ ., data = dat, kernel = "linear", cost = 10, 
             scale = FALSE)
print(svmfit)
plot(svmfit, dat)


## ----plot-svm-example-result-2------------------------------------------------
make.grid = function(x, n = 75) {
  grange = apply(x, 2, range)
  x1 = seq(from = grange[1,1], to = grange[2,1], length = n)
  x2 = seq(from = grange[1,2], to = grange[2,2], length = n)
  expand.grid(X1 = x1, X2 = x2)
}
xgrid = make.grid(x)
ygrid = predict(svmfit, xgrid)
plot(xgrid, col = c("red","blue")[as.numeric(ygrid)], pch = 20, cex = .2)
points(x, col = y + 3, pch = 19)
points(x[svmfit$index,], pch = 5, cex = 2)


## ----plot-svm-example-result-3------------------------------------------------
beta = drop(t(svmfit$coefs)%*%x[svmfit$index,])
beta0 = svmfit$rho
plot(xgrid, col = c("red", "blue")[as.numeric(ygrid)], pch = 20, cex = .2)
points(x, col = y + 3, pch = 19)
points(x[svmfit$index,], pch = 5, cex = 2)
abline(beta0 / beta[2], -beta[1] / beta[2])
abline((beta0 - 1) / beta[2], -beta[1] / beta[2], lty = 2)
abline((beta0 + 1) / beta[2], -beta[1] / beta[2], lty = 2)


## ----svm-soft-example-setup,echo=TRUE,results='hide'--------------------------
set.seed(2025)
library(e1071)
# simulate 2D data with some overlap
n = 100
x = matrix(rnorm(2*n), n, 2)
y = ifelse(x[,1] + 0.6*x[,2] + rnorm(n, sd=0.8) > 0, 1, -1)
dat = data.frame(x1 = x[,1], x2 = x[,2], y = as.factor(y))

# fit linear SVMs with different cost values
svm_lowC  = svm(y ~ ., data = dat, kernel = 'linear', cost = 0.1, scale = FALSE)
svm_medC  = svm(y ~ ., data = dat, kernel = 'linear', cost = 1,   scale = FALSE)
svm_highC = svm(y ~ ., data = dat, kernel = 'linear', cost = 100, scale = FALSE)

svm_list = list(low = svm_lowC, med = svm_medC, high = svm_highC)


## ----svm-soft-example-plots,echo=FALSE,fig.width=9,fig.height=3---------------
par(mfrow = c(1,3))
plot_svm_panel = function(svmfit, dat, main){
  # grid for background
  make.grid = function(x, n = 100) {
    grange = apply(x, 2, range)
    x1 = seq(from = grange[1,1], to = grange[2,1], length = n)
    x2 = seq(from = grange[1,2], to = grange[2,2], length = n)
    expand.grid(x1, x2)
  }
  xgrid = make.grid(as.matrix(dat[,1:2]))
  colnames(xgrid) = colnames(dat)[1:2]
  ygrid = predict(svmfit, xgrid)
  plot(xgrid, col = c('#fdd0a2','#b3cde3')[as.numeric(ygrid)], pch = 20, cex = .4, main = main)
  points(dat[,1:2], col = c('red','blue')[as.numeric(dat$y)], pch = 19)
  points(dat[svmfit$index,1:2], pch = 5, cex = 1.6)
}

plot_svm_panel(svm_lowC, dat,  main = 'cost = 0.1 (soft)')
plot_svm_panel(svm_medC, dat,  main = 'cost = 1')
plot_svm_panel(svm_highC, dat, main = 'cost = 100 (harder)')


## ----svm-soft-tune,echo=TRUE,results='hide'-----------------------------------
set.seed(2025)
tune.out = tune(svm, y ~ ., data = dat, 
                kernel = 'linear', 
                ranges = list(cost = c(0.01, 0.1, 1, 10, 100)))
print(tune.out)
best = tune.out$best.model


## ----svm-soft-final,echo=FALSE,fig.width=6,fig.height=4,warning=FALSE,message=FALSE----
plot(best, dat)


## ----convert-Rnw-to-R,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

