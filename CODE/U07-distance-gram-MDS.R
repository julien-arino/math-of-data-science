## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "U07"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## ----pca-mds-duality-check----------------------------------------------------
set.seed(2740)
X_tilde = scale(matrix(rnorm(15), nrow = 5, ncol = 3), center = TRUE, scale = FALSE)
pca_scores = prcomp(X_tilde, center = FALSE)$x[, 1:2]
mds_coords = cmdscale(dist(X_tilde), k = 2)
# Compare absolute values (eigenvectors are defined up to a sign +/- 1)
max(abs(abs(pca_scores) - abs(mds_coords)))


## ----canadian-cities-dist-----------------------------------------------------
cities = c("Victoria", "Vancouver", "Calgary", "Regina",
           "Winnipeg", "Toronto", "Montreal", "Halifax")
D_can = matrix(c(
     0,   90,  725, 1215, 1690, 3390, 3760, 4490,
    90,    0,  675, 1165, 1640, 3355, 3685, 4430,
   725,  675,    0,  505,  990, 2705, 3020, 3770,
  1215, 1165,  505,    0,  500, 2030, 2360, 3125,
  1690, 1640,  990,  500,    0, 1515, 1825, 2590,
  3390, 3355, 2705, 2030, 1515,    0,  505, 1265,
  3760, 3685, 3020, 2360, 1825,  505,    0,  790,
  4490, 4430, 3770, 3125, 2590, 1265,  790,    0
), nrow = 8, byrow = TRUE, dimnames = list(cities, cities))


## ----canadian-cities-manual-mds-----------------------------------------------
n = nrow(D_can)
C_n = diag(n) - matrix(1, n, n) / n
B = -0.5 * C_n %*% (D_can^2) %*% C_n
ev = eigen(B, symmetric = TRUE)
round(ev$values, 1)
X_manual = ev$vectors[, 1:2] %*% diag(sqrt(ev$values[1:2]))
rownames(X_manual) = cities
mds_builtin = cmdscale(as.dist(D_can), k = 2, eig = TRUE)
max(abs(abs(X_manual) - abs(mds_builtin$points)))


## ----plot-canadian-eigenvalues,echo=1:3---------------------------------------
gof_top2 = sum(ev$values[1:2]) / sum(ev$values[ev$values > 0])
gof_1d   = ev$values[1] / sum(ev$values[ev$values > 0])
c(GOF_1D = round(gof_1d, 4), GOF_2D = round(gof_top2, 4))
barplot(ev$values / 1e6, names.arg = 1:n, col = "dodgerblue4",
        xlab = "Eigenvalue index i",
        ylab = expression(paste("Eigenvalue ", lambda[i], " (", 10^6, " km"^2, ")")),
        main = "Eigenvalues of double-centred Gram matrix B (Canadian cities)")
abline(h = 0, col = "red", lwd = 2)


## ----plot-canadian-mds,echo=1:6-----------------------------------------------
coords = X_manual
# Ensure West < 0 and Winnipeg is North of Toronto
if (coords["Vancouver", 1] > 0) coords[, 1] = -coords[, 1]
if (coords["Winnipeg", 2] < coords["Toronto", 2]) coords[, 2] = -coords[, 2]
plot(coords[, 1], coords[, 2], pch = 19, cex = 1.5, col = "dodgerblue4",
     asp = 1, xlim = c(-2600, 2600), ylim = c(-900, 900),
     xlab = "MDS coordinate 1 (km, West - East)",
     ylab = "MDS coordinate 2 (km, South - North)",
     main = "Classical MDS of Canadian cities from distances")
abline(h = 0, v = 0, lty = 2, col = "grey60")
text(coords[, 1], coords[, 2], labels = cities,
     pos = c(2, 4, 3, 3, 3, 1, 3, 4), cex = 0.9)


## ----plot-eurodist-mds,echo=1:6-----------------------------------------------
D_euro = as.matrix(eurodist)
mds_euro = cmdscale(eurodist, k = 2, eig = TRUE)
x_eu = mds_euro$points[, 1]
y_eu = -mds_euro$points[, 2] # Flip North-South axis
plot(x_eu, y_eu, pch = 19, col = "firebrick", asp = 1,
     xlim = range(x_eu) * 1.15, ylim = range(y_eu) * 1.15,
     xlab = "MDS dimension 1 (km)", ylab = "MDS dimension 2 (km)",
     main = "Classical MDS of 21 European cities (eurodist)")
abline(h = 0, v = 0, lty = 2, col = "grey70")
text(x_eu, y_eu, labels = rownames(D_euro), pos = 3, cex = 0.75)


## ----convert-Rnw-to-R-part2,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

