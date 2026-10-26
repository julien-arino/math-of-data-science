## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "U06"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## ----pca-vs-supervised-demo,echo=TRUE,results='hide'--------------------------
set.seed(2740)
n_c = 60
t1 = rnorm(n_c, 0, 2.5); t2 = rnorm(n_c, 0, 2.5)
X1 = cbind(t1 + rnorm(n_c, 0, 0.25), t1 + 1.2 + rnorm(n_c, 0, 0.25))
X2 = cbind(t2 + rnorm(n_c, 0, 0.25), t2 - 1.2 + rnorm(n_c, 0, 0.25))
X_all = rbind(X1, X2)
y_all = c(rep(1, n_c), rep(-1, n_c))
pc1 = eigen(cov(X_all))$vectors[, 1]
SW = (n_c - 1) * (cov(X1) + cov(X2))
w_sep = solve(SW, colMeans(X1) - colMeans(X2))
w_sep = w_sep / sqrt(sum(w_sep^2))


## ----pca-vs-supervised-plot,echo=FALSE,fig.width=9,fig.height=4.2-------------
par(mfrow = c(1, 2), mar = c(4, 4, 3, 1))
cols = ifelse(y_all == 1, "dodgerblue4", "firebrick")
plot(X_all[, 1], X_all[, 2], col = cols, pch = 19, asp = 1,
     xlab = expression(x[1]), ylab = expression(x[2]),
     main = "2D data with PC1 and separating directions")
abline(a = 0, b = pc1[2] / pc1[1], col = "red", lwd = 3)
abline(a = 0, b = w_sep[2] / w_sep[1], col = "darkgreen", lwd = 3, lty = 2)
legend("topleft", legend = c("Class +1", "Class -1", "PC1 (max variance)", "Supervised direction"),
       col = c("dodgerblue4", "firebrick", "red", "darkgreen"),
       pch = c(19, 19, NA, NA), lty = c(NA, NA, 1, 2), lwd = c(NA, NA, 3, 3), cex = 0.8)

z_pc1 = as.vector(X_all %*% pc1)
z_sep = as.vector(X_all %*% w_sep)
plot(z_pc1, rep(1, length(z_pc1)) + rnorm(length(z_pc1), 0, 0.06),
     col = cols, pch = 19, ylim = c(0.4, 2.5), yaxt = "n",
     xlab = "1D projected coordinate z = w^T x", ylab = "",
     main = "1D projections: PC1 vs supervised")
points(z_sep, rep(2, length(z_sep)) + rnorm(length(z_sep), 0, 0.06),
       col = cols, pch = 19)
axis(2, at = c(1, 2), labels = c("PC1", "Supervised"), las = 1)
abline(h = c(1, 2), col = "grey80", lty = 3)


## ----svm-larger-dataset-demo,echo=TRUE,size='footnotesize'--------------------
library(e1071)
set.seed(42); n = 25
X1 = matrix(rnorm(2 * n, mean = 2, sd = 0.6), n, 2)
X2 = matrix(rnorm(2 * n, mean = -1, sd = 0.6), n, 2)
dat = data.frame(x1 = c(X1[, 1], X2[, 1]), x2 = c(X1[, 2], X2[, 2]),
                 y = factor(c(rep(1, n), rep(-1, n))))
fit = svm(y ~ ., data = dat, kernel = "linear",
          cost = 1000, scale = FALSE)
w = drop(t(fit$coefs) %*% fit$SV)
b = -fit$rho
cat("Support vectors:", length(fit$index), "out of", nrow(dat), "\n")
cat("w:", round(w, 4), " b:", round(b, 4),
    " gamma:", round(2 / sqrt(sum(w^2)), 4), "\n")


## ----plot-svm-larger-dataset,echo=FALSE,fig.width=7.5,fig.height=4.5----------
par(mar = c(4, 4, 3, 1), pty = "s")
plot(dat$x1, dat$x2,
     col = ifelse(dat$y == 1, "dodgerblue4", "firebrick3"),
     pch = 19, asp = 1,
     xlim = c(-3, 4), ylim = c(-3, 4),
     xlab = expression(x[1]), ylab = expression(x[2]),
     main = "Hard-margin SVM on 50 points in R (e1071)")
grid()
# Highlight support vectors with open circles
points(dat$x1[fit$index], dat$x2[fit$index], cex = 2.2, lwd = 2.2, col = "black")
# Decision boundary and margin hyperplanes
abline(a = -b / w[2], b = -w[1] / w[2], col = "black", lwd = 2.5)
abline(a = -(b - 1) / w[2], b = -w[1] / w[2], col = "dodgerblue4", lty = 2, lwd = 1.8)
abline(a = -(b + 1) / w[2], b = -w[1] / w[2], col = "firebrick3", lty = 2, lwd = 1.8)
legend("topleft",
       legend = c("Class +1", "Class -1", "Support vectors (3)",
                  "Boundary H", expression(H[+1]~"&"~H[-1])),
       col = c("dodgerblue4", "firebrick3", "black", "black", "gray40"),
       pch = c(19, 19, 1, NA, NA), lty = c(NA, NA, NA, 1, 2),
       lwd = c(NA, NA, 2, 2.5, 1.8), bg = "white")


## ----ls-outlier-demo,echo=TRUE,size='scriptsize'------------------------------
X4 = matrix(c(-1, 0, 1,  0, -1, 1,  1, 0, 1,  0, 1, 1), nrow = 4, byrow = TRUE)
y4 = c(-1, -1, 1, 1)
w_tilde_4 = solve(t(X4) %*% X4, t(X4) %*% y4)
# Add one outlier far on the correct (+1) side: x5 = (6, 2)^T
X5 = rbind(X4, c(6, 2, 1)); y5 = c(y4, 1)
w_tilde_5 = solve(t(X5) %*% X5, t(X5) %*% y5)
cbind(w_4pts = round(as.vector(w_tilde_4), 3), w_5pts = round(as.vector(w_tilde_5), 3))
# Fitted scores for all five points:
rbind(y = y5, score = round(as.vector(X5 %*% w_tilde_5), 3))


## ----ls-outlier-plot,echo=FALSE,fig.width=7.5,fig.height=4.2------------------
par(mar = c(4, 4, 3, 1))
plot(X5[, 1], X5[, 2], col = ifelse(y5 == 1, "dodgerblue4", "firebrick"),
     pch = c(19, 19, 19, 19, 17), cex = 1.6, asp = 1,
     xlim = c(-2.5, 7.5), ylim = c(-2.5, 2.8),
     xlab = expression(x[1]), ylab = expression(x[2]),
     main = "Sensitivity of least-squares classification to a far-side point")
grid()
abline(a = -w_tilde_4[3] / w_tilde_4[2], b = -w_tilde_4[1] / w_tilde_4[2],
       col = "darkgreen", lwd = 3)
abline(a = -w_tilde_5[3] / w_tilde_5[2], b = -w_tilde_5[1] / w_tilde_5[2],
       col = "purple", lwd = 3, lty = 2)
text(6, 2, labels = "x5 = (6, 2), y5 = +1", pos = 1, col = "dodgerblue4", cex = 0.85)
text(1, 0, labels = "x3 = (1, 0)\n(now misclassified!)", pos = 1, col = "dodgerblue4", cex = 0.8)
legend("topleft",
       legend = c("Class -1", "Class +1", "LS boundary (4 pts)", "LS boundary (with x5)"),
       col = c("firebrick", "dodgerblue4", "darkgreen", "purple"),
       pch = c(19, 19, NA, NA), lty = c(NA, NA, 1, 2), lwd = c(NA, NA, 3, 3), cex = 0.82)


## ----convert-Rnw-to-R,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

