## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "U10"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## ----concentric-rings-setup,echo=TRUE-----------------------------------------
set.seed(2740)
n1 = 80; n2 = 80
theta1 = seq(0, 2 * pi, length.out = n1 + 1)[-(n1 + 1)]
theta2 = seq(0, 2 * pi, length.out = n2 + 1)[-(n2 + 1)]
X = rbind(
  cbind(1.0 * cos(theta1), 1.0 * sin(theta1)) + rnorm(2 * n1, sd = 0.06),
  cbind(2.3 * cos(theta2), 2.3 * sin(theta2)) + rnorm(2 * n2, sd = 0.06)
)
# epsilon-neighbourhood adjacency matrix (epsilon = 0.65)
dist_mat = as.matrix(dist(X))
A_rings = (dist_mat <= 0.65 & dist_mat > 0) * 1


## ----plot-concentric-rings,echo=FALSE,fig.width=8,fig.height=4----------------
km_rings = kmeans(X, centers = 2, nstart = 20)
L_rings = diag(rowSums(A_rings)) - A_rings
ev_rings = eigen(L_rings, symmetric = TRUE)
# Second smallest eigenvalue is at index ncol(L_rings) - 1
v2_rings = ev_rings$vectors[, ncol(L_rings) - 1]
spec_cluster = ifelse(v2_rings >= 0, 1, 2)

par(mfrow = c(1, 2), mar = c(4, 4, 3, 1))
plot(X[, 1], X[, 2],
     col = ifelse(km_rings$cluster == 1, "dodgerblue3", "firebrick3"),
     pch = 19, asp = 1, xlab = expression(x[1]), ylab = expression(x[2]),
     main = "k-means on raw coordinates")
points(km_rings$centers, pch = 4, cex = 2, lwd = 3, col = "black")

plot(X[, 1], X[, 2], type = "n", asp = 1,
     xlab = expression(x[1]), ylab = expression(x[2]),
     main = "Spectral clustering on similarity graph")
idx_edges = which(A_rings == 1 & upper.tri(A_rings), arr.ind = TRUE)
segments(X[idx_edges[, 1], 1], X[idx_edges[, 1], 2],
         X[idx_edges[, 2], 1], X[idx_edges[, 2], 2],
         col = "grey75", lwd = 0.8)
points(X[, 1], X[, 2],
       col = ifelse(spec_cluster == 1, "dodgerblue3", "firebrick3"),
       pch = 19)


## ----three-components-R,echo=TRUE---------------------------------------------
G_comp = make_graph(edges = c(1,2, 2,3, 1,3,  4,5, 5,6,  7,8),
                    n = 8, directed = FALSE)
L_comp = as.matrix(laplacian_matrix(G_comp))
ev_comp = eigen(L_comp, symmetric = TRUE)
# Eigenvalues of L in ascending order
round(rev(ev_comp$values), 4)
# Number of zero eigenvalues (up to numerical precision)
sum(abs(ev_comp$values) < 1e-10)


## ----barbell-R,echo=TRUE------------------------------------------------------
A_barbell = matrix(c(
  0, 1, 1, 0, 0, 0,
  1, 0, 1, 0, 0, 0,
  1, 1, 0, 1, 0, 0,
  0, 0, 1, 0, 1, 1,
  0, 0, 0, 1, 0, 1,
  0, 0, 0, 1, 1, 0
), nrow = 6, byrow = TRUE)
L_barbell = diag(rowSums(A_barbell)) - A_barbell
ev_b = eigen(L_barbell, symmetric = TRUE)
round(rev(ev_b$values), 4)          # eigenvalues in ascending order
round(ev_b$vectors[, 5], 4)         # unit Fiedler vector v_2


## ----karate-spectral,echo=TRUE------------------------------------------------
G_karate = make_graph("Zachary")
L_karate = as.matrix(laplacian_matrix(G_karate))
ev_k = eigen(L_karate, symmetric = TRUE)
n_k = vcount(G_karate)
# Smallest three eigenvalues of L
round(ev_k$values[n_k:(n_k - 2)], 4)
# Fiedler vector v_2 (oriented so vertex 1 is positive)
v2_k = ev_k$vectors[, n_k - 1]
if (v2_k[1] < 0) v2_k = -v2_k
table(Sign_of_v2 = ifelse(v2_k >= 0, "Group 1 (+)", "Group 2 (-)"))


## ----plot-karate-fiedler,echo=FALSE,fig.width=8.5,fig.height=4.2--------------
par(mfrow = c(1, 2), mar = c(4, 4, 3, 1))
ord = order(v2_k)
cols_k = ifelse(v2_k >= 0, "dodgerblue3", "firebrick3")
plot(seq_along(v2_k), v2_k[ord],
     pch = 19, col = cols_k[ord],
     xlab = "Rank of vertex (sorted by Fiedler vector)",
     ylab = expression(v[2 * i]),
     main = "Sorted entries of the Fiedler vector")
abline(h = 0, lty = 2, lwd = 2, col = "grey30")
text(seq_along(v2_k), v2_k[ord], labels = ord, pos = ifelse(v2_k[ord] >= 0, 3, 1), cex = 0.55)

set.seed(42)
lay_k = layout_with_fr(G_karate)
par(mar = c(1, 1, 3, 1))
plot(G_karate, layout = lay_k,
     vertex.color = ifelse(v2_k >= 0, "lightskyblue", "salmon"),
     vertex.size = 15,
     vertex.label.cex = 0.7,
     vertex.label.color = "black",
     edge.color = "grey70",
     main = "Karate club partitioned by sign(v2)")


## ----three-way-spectral,echo=TRUE---------------------------------------------
set.seed(2740)
pm = matrix(0.03, nrow = 3, ncol = 3); diag(pm) = 0.70
G_sbm = sample_sbm(45, pref.matrix = pm, block.sizes = c(15, 15, 15))
L_sbm = as.matrix(laplacian_matrix(G_sbm))
ev_sbm = eigen(L_sbm, symmetric = TRUE)
# Smallest 6 eigenvalues of L (note the jump after lambda_3!)
round(rev(ev_sbm$values)[1:6], 3)
# Spectral embedding using v_2 and v_3, followed by k-means (k = 3)
U_sbm = ev_sbm$vectors[, c(44, 43)]
km_sbm = kmeans(U_sbm, centers = 3, nstart = 20)
table(True_block = rep(1:3, each = 15), Spectral_cluster = km_sbm$cluster)


## ----plot-three-way-spectral,echo=FALSE,fig.width=8.5,fig.height=4.2----------
par(mfrow = c(1, 2), mar = c(4, 4, 3, 1))
lam_asc = rev(ev_sbm$values)[1:10]
plot(1:10, lam_asc, type = "b", pch = 19,
     col = ifelse(1:10 <= 3, "firebrick3", "dodgerblue3"),
     xlab = "Index k", ylab = expression(lambda[k]),
     main = "Smallest 10 Laplacian eigenvalues (eigengap at k = 3)")
abline(v = 3.5, lty = 2, lwd = 2, col = "grey40")

cols_true = c("dodgerblue3", "firebrick3", "forestgreen")[rep(1:3, each = 15)]
plot(U_sbm[, 1], U_sbm[, 2],
     pch = 19, col = cols_true,
     xlab = expression(v[2] ~ "(Fiedler vector)"),
     ylab = expression(v[3] ~ "(third Laplacian eigenvector)"),
     main = "Spectral embedding (v2, v3) in R^2")
points(km_sbm$centers, pch = 4, cex = 2, lwd = 3, col = "black")


## ----convert-Rnw-to-R-part2,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

