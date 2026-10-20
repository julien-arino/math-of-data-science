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


## ----example-3d-pca-----------------------------------------------------------
S = matrix(c(15, 10, 4, 10, 14, 6, 4, 6, 7), nrow = 3, byrow = TRUE)
ev = eigen(S)
ev$values
# Proportion and cumulative proportion of variance explained
ev$values / sum(ev$values)
cumsum(ev$values) / sum(ev$values)


## ----load-hockey-data-2, echo=FALSE-------------------------------------------
# Ensure hockey data is loaded and deduplicated
if (!exists("data") || !all(c("height.c", "weight.c") %in% colnames(data))) {
  raw_data = if (file.exists("../DATA/hockey-players.csv")) {
    read.csv("../DATA/hockey-players.csv")
  } else {
    read.csv("https://github.com/julien-arino/math-of-data-science/raw/refs/heads/main/DATA/hockey-players.csv")
  }
  data_simplified = aggregate(cbind(height, weight) ~ name, data = raw_data, FUN = mean)
  data_simplified$weight.c = data_simplified$weight - mean(data_simplified$weight)
  data_simplified$height.c = data_simplified$height - mean(data_simplified$height)
  data = data_simplified
}


## -----------------------------------------------------------------------------
cov(data$height, data$weight)
cov(data$height.c, data$weight.c)


## -----------------------------------------------------------------------------
X = as.matrix(data[, c("height.c", "weight.c")])
S = 1 / (dim(X)[1] - 1) * t(X) %*% X
S


## -----------------------------------------------------------------------------
var(X[, 1])
var(X[, 2])


## -----------------------------------------------------------------------------
ev = eigen(S)
ev


## ----plot-hockey-centred-evector, fig.width=6, fig.height=6, crop=TRUE--------
par(pty = "s")
lims = range(c(data$height.c, data$weight.c))
plot(data$height.c, data$weight.c,
     xlim = lims, ylim = lims, asp = 1,
     pch = 19, col = "dodgerblue4",
     main = "IIHF players 2001-2016 (with first component)",
     xlab = "Centred height (cm)", ylab = "Centred weight (kg)")
abline(a = 0, b = ev$vectors[2, 1] / ev$vectors[1, 1],
       col = "red", lwd = 3)


## -----------------------------------------------------------------------------
z = lm(weight.c ~ 0 + height.c, data = data)
coef(z)


## ----plot-hockey-lm-compare, fig.width=6, fig.height=6, echo=FALSE, crop=TRUE----
par(pty = "s")
plot(data$height.c, data$weight.c,
     xlim = lims, ylim = lims, asp = 1,
     pch = 19, col = "dodgerblue4",
     main = "First PC (red) vs. least squares fit (green)",
     xlab = "Centred height (cm)", ylab = "Centred weight (kg)")
abline(a = 0, b = ev$vectors[2, 1] / ev$vectors[1, 1],
       col = "red", lwd = 3)
abline(a = 0, b = coef(z), col = "green", lwd = 3)


## -----------------------------------------------------------------------------
theta = atan(ev$vectors[2, 1] / ev$vectors[1, 1])
theta
R_minus_theta = matrix(c(cos(-theta), -sin(-theta),
                         sin(-theta),  cos(-theta)),
                       nr = 2, byrow = TRUE)
R_minus_theta


## ----plot-hockey-centred-rotated, fig.width=6, fig.height=6, echo=2:8, crop=TRUE----
par(pty = "s")
rot_pts = X %*% t(R_minus_theta)
data$height.c_r = rot_pts[, 1]
data$weight.c_r = rot_pts[, 2]
plot(data$height.c_r, data$weight.c_r,
     xlim = lims, ylim = lims, asp = 1,
     pch = 19, col = "dodgerblue4",
     xlab = "Rotated x-axis (1st component)",
     ylab = "Rotated y-axis",
     main = "IIHF players 2001-2016 (rotated to first component)")
abline(h = 0, col = "red", lwd = 2)


## ----plot-hockey-centred-2evectors, fig.width=6, fig.height=6, echo=2:9, crop=TRUE----
par(pty = "s")
plot(data$height.c, data$weight.c,
     xlim = lims, ylim = lims, asp = 1,
     pch = 19, col = "dodgerblue4",
     main = "IIHF players 2001-2016 (1st and 2nd eigenvectors)",
     xlab = "Centred height (cm)", ylab = "Centred weight (kg)")
abline(a = 0, b = ev$vectors[2, 1] / ev$vectors[1, 1],
       col = "red", lwd = 3)
abline(a = 0, b = ev$vectors[2, 2] / ev$vectors[1, 2],
       col = "darkgreen", lwd = 3)


## -----------------------------------------------------------------------------
GS = pracma::gramSchmidt(A = ev$vectors, tol = 1e-10)
A = cbind(GS$Q, diag(2))
pracma::rref(A)


## ----plot-hockey-centred-evector-3, fig.width=6, fig.height=6, echo=c(2:5), crop=TRUE----
par(pty = "s")
P = pracma::rref(A)[, c(3, 4)]
P
X.new = X %*% t(P)
cov(X.new)
plot(X.new[, 1], X.new[, 2],
     xlim = lims, ylim = lims, asp = 1,
     xlab = "PC1 score (z1)", ylab = "PC2 score (z2)",
     main = "IIHF players in principal component coordinates",
     pch = 19, col = "dodgerblue4")
abline(h = 0, col = "red", lwd = 2)
abline(v = 0, col = "darkgreen", lwd = 2)


## -----------------------------------------------------------------------------
cov(X.new)


## ----echo=FALSE---------------------------------------------------------------
if (!exists("raw_data")) {
  raw_data = if (file.exists("../DATA/hockey-players.csv")) {
    read.csv("../DATA/hockey-players.csv")
  } else {
    read.csv("https://github.com/julien-arino/math-of-data-science/raw/refs/heads/main/DATA/hockey-players.csv")
  }
}

## -----------------------------------------------------------------------------
agg_num = aggregate(cbind(height, weight, age, bmi) ~ name,
                    data = raw_data, FUN = mean)
agg_pos = aggregate(position ~ name, data = raw_data,
                    FUN = function(x) x[1])
hockey_multi = merge(agg_pos, agg_num, by = "name")
hockey_multi$position = factor(
  hockey_multi$position,
  levels = c("D", "F", "G"),
  labels = c("Defence", "Forward", "Goalkeeper")
)


## -----------------------------------------------------------------------------
head(hockey_multi, n = 4)


## -----------------------------------------------------------------------------
hockey.pca = prcomp(
  hockey_multi[, c("height", "weight", "age", "bmi")],
  center = TRUE, scale. = TRUE
)
summary(hockey.pca)


## ----plot-pca-ggbiplot, fig.width=7.5, fig.height=4.8, echo=1:7, crop=TRUE----
library(ggbiplot)
p_biplot = ggbiplot(hockey.pca, obs.scale = 1, var.scale = 1,
         groups = hockey_multi$position, ellipse = TRUE,
         circle = TRUE, alpha = 0.2) +
  theme_minimal() +
  labs(title = "PCA biplot of IIHF players by position",
       color = "Position", fill = "Position")
print(p_biplot)


## ----pca-factominer-run, message=FALSE, warning=FALSE-------------------------
library(FactoMineR)
res.pca = PCA(hockey_multi[, c("position", "height", "weight",
                               "age", "bmi")],
              quali.sup = 1, scale.unit = TRUE, graph = FALSE)


## ----plot-factominer-var, fig.width=6, fig.height=5, crop=TRUE----------------
plot.PCA(res.pca, axes = c(1, 2), choix = "var",
         title = "Variable correlation circle (FactoMineR)")


## ----plot-factominer-ellipses, fig.width=7, fig.height=5, crop=TRUE-----------
plotellipses(res.pca, keepvar = 1, label = "quali",
             title = "Individuals and position barycentres")


## ----convert-Rnw-to-R-part2,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

