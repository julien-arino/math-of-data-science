## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "U12"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## ----plot-activations,echo=FALSE,fig.width=8,fig.height=4.5-------------------
z_vals = seq(-4, 4, length.out = 500)
par(mfrow = c(2, 2), mar = c(3.5, 3.5, 2.2, 1), mgp = c(2, 0.7, 0))

# Step
plot(z_vals, ifelse(z_vals > 0, 1, 0), type = "l", lwd = 3, col = "dodgerblue4",
     xlab = "z", ylab = expression(sigma(z)), main = "Heaviside step", ylim = c(-0.2, 1.2))
abline(h = 0, v = 0, col = "gray70", lty = 2)

# ReLU
plot(z_vals, pmax(0, z_vals), type = "l", lwd = 3, col = "firebrick",
     xlab = "z", ylab = expression(sigma(z)), main = "ReLU: max(0, z)", ylim = c(-0.5, 4))
abline(h = 0, v = 0, col = "gray70", lty = 2)

# Sigmoid
plot(z_vals, 1 / (1 + exp(-z_vals)), type = "l", lwd = 3, col = "darkgreen",
     xlab = "z", ylab = expression(sigma(z)), main = "Logistic sigmoid", ylim = c(-0.2, 1.2))
abline(h = c(0, 0.5, 1), v = 0, col = "gray70", lty = 2)

# Tanh
plot(z_vals, tanh(z_vals), type = "l", lwd = 3, col = "purple4",
     xlab = "z", ylab = expression(sigma(z)), main = "Hyperbolic tangent: tanh(z)", ylim = c(-1.2, 1.2))
abline(h = c(-1, 0, 1), v = 0, col = "gray70", lty = 2)


## ----xor-batch-forward--------------------------------------------------------
X = matrix(c(0, 0,  1, 0,  0, 1,  1, 1), nrow = 4, byrow = TRUE)
W1 = matrix(c(1, 1,  1, 1), nrow = 2, byrow = TRUE)
b1 = c(0, -1);  one_B = rep(1, nrow(X))
Z1 = X %*% t(W1) + one_B %*% t(b1)
A1 = pmax(0, Z1)
y_hat = A1 %*% c(1, -2)
cbind(X, A1 = A1, y_hat = as.vector(y_hat))


## ----linear-autoencoder-pca---------------------------------------------------
set.seed(2740); n = 150; d = 3; k = 2
M_mix = matrix(c(3, 2, 1, 0, 1.5, 1, 0, 0, 0.3), nrow = 3, byrow = TRUE)
X = scale(matrix(rnorm(n * d), n, d) %*% M_mix, center = TRUE, scale = FALSE)
V_k = svd(X)$v[, 1:k];  P_pca = V_k %*% t(V_k)

ae_loss = function(th) {
  W1 = matrix(th[1:6], d, k);  W2 = matrix(th[7:12], k, d)
  sum((X - X %*% W1 %*% W2)^2)
}
opt = optim(rnorm(12, sd = 0.5), ae_loss, method = "BFGS",
            control = list(maxit = 500, reltol = 1e-12))
W1_hat = matrix(opt$par[1:6], d, k);  W2_hat = matrix(opt$par[7:12], k, d)
P_ae = W1_hat %*% W2_hat


## ----linear-autoencoder-compare-----------------------------------------------
round(P_pca, 4)
round(P_ae, 4)
max(abs(P_pca - P_ae))


## ----plot-ae-pca,echo=FALSE,fig.width=7.5,fig.height=4.2----------------------
X_pca = X %*% P_pca
X_ae = X %*% P_ae
par(mfrow = c(1, 2), mar = c(4, 4, 2.5, 1), mgp = c(2.2, 0.7, 0))
plot(X[, 1], X[, 2], pch = 19, col = "gray70",
     xlab = "Feature 1 (centred)", ylab = "Feature 2 (centred)",
     main = "PCA vs Autoencoder reconstruction (x1, x2)")
points(X_pca[, 1], X_pca[, 2], pch = 1, col = "dodgerblue4", cex = 1.3, lwd = 1.5)
points(X_ae[, 1], X_ae[, 2], pch = 4, col = "firebrick", cex = 1.1, lwd = 1.5)
legend("topleft", legend = c("Original 3D data", "PCA (X V_k V_k^T)", "Autoencoder (X W_1 W_2)"),
       col = c("gray70", "dodgerblue4", "firebrick"), pch = c(19, 1, 4), bty = "n", cex = 0.85)

# Latent space comparison
Z_pca = X %*% V_k
Z_ae = X %*% W1_hat
# Align Z_ae to Z_pca via C = (V_k^T W1_hat)^{-1}
C_mat = t(V_k) %*% W1_hat
Z_ae_aligned = Z_ae %*% solve(C_mat)
plot(Z_pca[, 1], Z_pca[, 2], pch = 1, col = "dodgerblue4", cex = 1.3, lwd = 1.5,
     xlab = "Principal coordinate 1", ylab = "Principal coordinate 2",
     main = "Latent code after basis alignment C^{-1}")
points(Z_ae_aligned[, 1], Z_ae_aligned[, 2], pch = 4, col = "firebrick", cex = 1.1, lwd = 1.5)
legend("topleft", legend = c("PCA scores Z = X V_k", "Aligned AE code Z_AE C^{-1}"),
       col = c("dodgerblue4", "firebrick"), pch = c(1, 4), bty = "n", cex = 0.85)


## ----gcn-hand-verify----------------------------------------------------------
A = matrix(c(0, 1, 0,  1, 0, 1,  0, 1, 0), nrow = 3, byrow = TRUE)
A_tilde = A + diag(3)
S_rw = diag(1 / rowSums(A_tilde)) %*% A_tilde
X = matrix(c(2, 0,  0, 6,  4, 0), nrow = 3, byrow = TRUE)
W = matrix(c(2, -1,  -1, 1), nrow = 2, byrow = TRUE)
SX = S_rw %*% X;  Z = SX %*% W;  H = pmax(0, Z)
cbind(SX = SX, Z = Z, H = H)


## ----karate-gcn---------------------------------------------------------------
G_karate = make_graph("Zachary")
A_k = as.matrix(as_adjacency_matrix(G_karate));  n_k = nrow(A_k)
A_tilde_k = A_k + diag(n_k)
D_inv_sqrt = diag(1 / sqrt(rowSums(A_tilde_k)))
S_sym = D_inv_sqrt %*% A_tilde_k %*% D_inv_sqrt
set.seed(42)
W1_k = matrix(rnorm(n_k * 8, sd = 0.6), n_k, 8)
W2_k = matrix(rnorm(8 * 2, sd = 0.6), 8, 2)
H1_k = tanh(S_sym %*% diag(n_k) %*% W1_k)
H2_k = tanh(S_sym %*% H1_k %*% W2_k)


## ----plot-karate-gcn,echo=FALSE,fig.width=8.5,fig.height=4.3------------------
# True faction membership (Mr Hi = 1 vs Officer John A = 34)
dist_1 = as.vector(distances(G_karate, v = 1))
dist_34 = as.vector(distances(G_karate, v = 34))
faction = ifelse(dist_1 < dist_34, 1, 2)
faction[c(1, 34)] = c(1, 2)
node_cols = ifelse(faction == 1, "dodgerblue3", "firebrick2")

par(mfrow = c(1, 2), mar = c(3.5, 3.5, 2.5, 1), mgp = c(2.1, 0.7, 0))
set.seed(123)
lay = layout_with_fr(G_karate)
plot(G_karate, layout = lay, vertex.color = node_cols, vertex.size = 15,
     vertex.label.color = "white", vertex.label.cex = 0.7,
     main = "Zachary's Karate Club graph (2 factions)")

plot(H2_k[, 1], H2_k[, 2], pch = 21, bg = node_cols, col = "black", cex = 2.2,
     xlab = expression(H[i1]^{(2)}), ylab = expression(H[i2]^{(2)}),
     main = "2-layer GCN embedding in R^2 (untrained W)")
text(H2_k[, 1], H2_k[, 2], labels = 1:n_k, cex = 0.55, col = "white", font = 2)
legend("bottomleft", legend = c("Faction 1 (Mr Hi)", "Faction 2 (Officer)"),
       pt.bg = c("dodgerblue3", "firebrick2"), pch = 21, pt.cex = 1.5, bty = "n", cex = 0.85)


## ----karate-oversmoothing-----------------------------------------------------
S_rw_k = diag(1 / rowSums(A_tilde_k)) %*% A_tilde_k;  set.seed(7)
X0_k = cbind(ifelse(faction == 1, -1, 1) + rnorm(n_k, sd = 0.4),
             rnorm(n_k, sd = 0.6))
mat_pow = function(M, k) Reduce(`%*%`, replicate(k, M, simplify = FALSE))
X_step1  = S_rw_k %*% X0_k;  X_step5 = mat_pow(S_rw_k, 5) %*% X0_k
X_step50 = mat_pow(S_rw_k, 50) %*% X0_k
pi_stat = rowSums(A_tilde_k) / sum(A_tilde_k)
rbind(Row1_k50 = X_step50[1, ], Stat_avg = as.vector(t(pi_stat) %*% X0_k))


## ----plot-karate-oversmoothing,echo=FALSE,fig.width=9,fig.height=3.6----------
par(mfrow = c(1, 3), mar = c(3.8, 3.8, 2.5, 0.8), mgp = c(2.1, 0.7, 0))
xlim_os = range(X0_k[, 1])
ylim_os = range(X0_k[, 2])
stat_pt = as.vector(t(pi_stat) %*% X0_k)

plot(X_step1[, 1], X_step1[, 2], pch = 21, bg = node_cols, cex = 1.8,
     xlim = xlim_os, ylim = ylim_os, xlab = "Feature 1", ylab = "Feature 2",
     main = "k = 1 layer (local smoothing)")
points(stat_pt[1], stat_pt[2], pch = 4, cex = 2, lwd = 2.5, col = "black")

plot(X_step5[, 1], X_step5[, 2], pch = 21, bg = node_cols, cex = 1.8,
     xlim = xlim_os, ylim = ylim_os, xlab = "Feature 1", ylab = "Feature 2",
     main = "k = 5 layers (communities separated)")
points(stat_pt[1], stat_pt[2], pch = 4, cex = 2, lwd = 2.5, col = "black")

plot(X_step50[, 1], X_step50[, 2], pch = 21, bg = node_cols, cex = 1.8,
     xlim = xlim_os, ylim = ylim_os, xlab = "Feature 1", ylab = "Feature 2",
     main = "k = 50 layers (over-smoothed collapse!)")
points(stat_pt[1], stat_pt[2], pch = 4, cex = 2, lwd = 2.5, col = "black")
legend("topright", legend = c("Faction 1", "Faction 2", expression(pi^T * X[0])),
       pt.bg = c("dodgerblue3", "firebrick2", NA), col = c("black", "black", "black"),
       pch = c(21, 21, 4), pt.cex = 1.3, bty = "n", cex = 0.85)


## ----convert-Rnw-to-R-part2,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

