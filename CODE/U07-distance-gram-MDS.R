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
plot(coords[, 1], coords[, 2],
     pch = 19, cex = 1.5, col = "dodgerblue4",
     asp = 1, bty = "n", xlim = c(-2600, 2600), ylim = c(-900, 900),
     xlab = "MDS coordinate 1 (km, West - East)",
     ylab = "MDS coordinate 2 (km, South - North)",
     main = "Classical MDS of Canadian cities from distances")
abline(h = 0, v = 0, lty = 2, col = "grey60")
text(coords[, 1], coords[, 2], labels = cities,
     pos = c(1, 3, 1, 3, 1, 1, 3, 1), cex = 0.9)


## ----plot-canadian-mds-rotated,echo=1:5---------------------------------------
theta = atan2(coords["Halifax", 2] - coords["Victoria", 2],
              coords["Halifax", 1] - coords["Victoria", 1])
R_rot = matrix(c(cos(-theta), -sin(-theta),
                 sin(-theta),  cos(-theta)),
               nrow = 2, byrow = TRUE)
coords_rot = coords %*% t(R_rot)
plot(coords_rot[, 1], coords_rot[, 2],
     pch = 19, cex = 1.5, col = "dodgerblue4",
     asp = 1, bty = "n", xlim = c(-2600, 2600), ylim = c(-900, 900),
     xlab = "MDS coordinate 1 (km, West - East)",
     ylab = "MDS coordinate 2 (km, South - North)",
     main = "Classical MDS of Canadian cities (after rotation)")
abline(h = 0, v = 0, lty = 2, col = "grey60")
text(coords_rot[, 1], coords_rot[, 2], labels = cities,
     pos = c(1, 3, 1, 3, 1, 1, 3, 1), cex = 0.9)


## ----plot-earth-curvature,echo=FALSE------------------------------------------
R_earth = 6371
s_tot = 4490
s_vic_wpg = 1690
s_wpg_hal = 2595

alpha = s_tot / R_earth
phi = alpha / 2

frac_wpg = s_vic_wpg / (s_vic_wpg + s_wpg_hal)
angle_wpg = -phi + frac_wpg * alpha

x_vic = -R_earth * sin(phi)
x_hal = R_earth * sin(phi)
x_wpg = R_earth * sin(angle_wpg)
y_wpg_arc = R_earth * cos(angle_wpg) - R_earth * cos(phi)

th = seq(-phi, phi, length.out = 300)
arc_x = R_earth * sin(th)
arc_y = R_earth * cos(th) - R_earth * cos(phi)

plot(arc_x, arc_y, type = "n", asp = 1, bty = "n",
     xlim = c(-2600, 2600), ylim = c(-420, 850),
     xlab = "Distance along chord (km)",
     ylab = "Height above chord (km)",
     main = "Earth curvature: Victoria to Halifax (true 1:1 scale)")

polygon(c(arc_x, rev(c(x_vic, x_hal))), c(arc_y, 0, 0),
        col = rgb(0.85, 0.92, 0.98, 0.6), border = NA)

lines(c(x_vic, x_hal), c(0, 0), lty = 2, lwd = 2, col = "grey50")
lines(arc_x, arc_y, lwd = 3, col = "dodgerblue4")
lines(c(x_wpg, x_wpg), c(0, y_wpg_arc), lty = 3, lwd = 2.5, col = "firebrick")

points(c(x_vic, x_hal), c(0, 0), pch = 19, cex = 1.6, col = "dodgerblue4")
text(x_vic, -30, "Victoria", pos = 1, cex = 0.95, font = 2)
text(x_hal, -30, "Halifax", pos = 1, cex = 0.95, font = 2)

# Winnipeg on surface (moved up, no arrow)
points(x_wpg, y_wpg_arc, pch = 19, cex = 1.6, col = "firebrick")
text(x_wpg, 670, "Winnipeg (on Earth surface)", pos = 3, cex = 0.9, col = "firebrick", font = 2)

# Winnipeg on chord (moved down, no arrow)
points(x_wpg, 0, pch = 17, cex = 1.6, col = "darkgreen")
text(x_wpg, -280, "Winnipeg on chord (flat projection)", pos = 1, cex = 0.85, col = "darkgreen")

# Deviation label: shifted left
text(x_wpg + 16, y_wpg_arc / 2, paste0("Deviation = ", round(y_wpg_arc), " km"),
     pos = 4, col = "firebrick", font = 2, cex = 0.9)

# Earth surface arc label: shifted up so it is well above the arc
text(1100, 420, "Earth surface (arc: ~4,490 km)", pos = 3, col = "dodgerblue4", cex = 0.85)

# Straight chord label: closer to chord and shifted left
text(700, -45, "Straight chord (~4,398 km)", pos = 1, col = "grey40", cex = 0.85)


## ----convert-Rnw-to-R-part2,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

