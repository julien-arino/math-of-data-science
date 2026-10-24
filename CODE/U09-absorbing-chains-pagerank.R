## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "U09"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## ----setup, include=FALSE-----------------------------------------------------
# Set global chunk options
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)


## ----absorbing-base-R---------------------------------------------------------
R_mat <- matrix(c(0.5, 0,   0,
                  0,   0,   0.5), nrow = 2, byrow = TRUE)
Q_mat <- matrix(c(0,   0.5, 0,
                  0.5, 0,   0.5,
                  0,   0.5, 0),   nrow = 3, byrow = TRUE)
colnames(R_mat) <- colnames(Q_mat) <- rownames(Q_mat) <- c("S2", "S3", "S4")
rownames(R_mat) <- c("S1", "S5")

N_mat <- solve(diag(3) - Q_mat)
t_vec <- colSums(N_mat)
B_mat <- R_mat %*% N_mat
N_mat
t_vec
B_mat


## ----absorbing-mc-pkg---------------------------------------------------------
library(markovchain)
P_abs <- matrix(c(1, 0, 0.5,
                  0, 0, 0,
                  0, 1, 0.5), nrow = 3, byrow = TRUE)
mc_abs <- new("markovchain",
              states = sprintf("S_%d", 1:3),
              transitionMatrix = t(P_abs),
              name = "orange_abs")
summary(mc_abs)


## ----absorbing-mc-functions---------------------------------------------------
canonicForm(mc_abs)
meanAbsorptionTime(mc_abs)
absorptionProbabilities(mc_abs)


## ----U09-absorbing-realisation------------------------------------------------
library(DTMCPack)
set.seed(2740)
IC <- c(0, 1, 0) # Start in S_2 (black female)
sol <- DTMC(t(P_abs), IC, 10, trace = TRUE)


## ----pagerank-3page-R---------------------------------------------------------
P3 <- matrix(c(0,   0, 1,
               0.5, 0, 0,
               0.5, 1, 0), nrow = 3, byrow = TRUE)

# Solve (I - alpha * P) x = ((1 - alpha) / n) * 1 for alpha = 0.5
alpha <- 0.5
x_half <- solve(diag(3) - alpha * P3, rep((1 - alpha) / 3, 3))
MASS::fractions(x_half)

# Compare with igraph::page_rank at alpha = 0.85
library(igraph)
g3 <- graph_from_edgelist(matrix(c(1,2, 1,3, 2,3, 3,1), ncol = 2, byrow = TRUE))
page_rank(g3, damping = 0.85)$vector


## ----U09-pagerank-6page-graph-------------------------------------------------
edges <- matrix(c(1,2, 1,3, 2,3, 3,1, 2,4, 3,5, 5,6, 6,5),
                ncol = 2, byrow = TRUE)
g6 <- graph_from_edgelist(edges, directed = TRUE)
V(g6)$name <- paste0("P", 1:6)
pr6 <- page_rank(g6, damping = 0.85)$vector
round(pr6, 4)

par(mar = c(0, 0, 0, 0))
plot(g6, vertex.size = 350 * pr6 + 18, vertex.color = "lightblue",
     vertex.label.cex = 1.1, edge.arrow.size = 0.7)


## ----U09-pagerank-convergence-------------------------------------------------
A6 <- as.matrix(as_adjacency_matrix(g6)) # row i -> col j in igraph, so transpose!
A6 <- t(A6)                              # now a_{ij} = 1 if j -> i
n <- nrow(A6)
out_deg <- colSums(A6)
P6 <- matrix(0, n, n)
for (j in 1:n) {
  if (out_deg[j] > 0) P6[, j] <- A6[, j] / out_deg[j] else P6[, j] <- rep(1 / n, n)
}
alpha <- 0.85
x_exact <- solve(diag(n) - alpha * P6, rep((1 - alpha) / n, n))

x_k <- rep(1 / n, n)
err <- numeric(30)
for (k in 1:30) {
  x_k <- alpha * (P6 %*% x_k) + (1 - alpha) / n
  err[k] <- sum(abs(x_k - x_exact))
}
plot(1:30, err, type = "b", log = "y", pch = 19, col = "dodgerblue4",
     xlab = "Iteration k", ylab = "L1 error ||x^(k) - x||_1",
     main = "Geometric convergence of PageRank power iteration")
lines(1:30, err[1] * (alpha^(0:29)), lty = 2, lwd = 2, col = "firebrick")
legend("topright", c("Actual L1 error", "Theoretical rate 0.85^k"),
       col = c("dodgerblue4", "firebrick"), lty = c(1, 2), pch = c(19, NA))


## ----convert-Rnw-to-R,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

