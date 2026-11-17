## ----set-lecture-number----
lecture_number = "U09"

## ----set-slide-background----
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)

## ----setup----
# Set global chunk options
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)

## ----absorbing-base-R-setup----
R_mat <- matrix(c(0.5, 0,  0, 0,  0, 0.5), nrow = 3, byrow = TRUE,
                dimnames = list(c("S2", "S3", "S4"), c("S1", "S5")))
Q_mat <- matrix(c(0, 0.5, 0,  0.5, 0, 0.5,  0, 0.5, 0), nrow = 3,
                dimnames = list(c("S2", "S3", "S4"), c("S2", "S3", "S4")))
N_mat <- solve(diag(3) - Q_mat)
N_mat

## ----absorbing-base-R-results----
t_vec <- rowSums(N_mat)
t_vec
B_mat <- N_mat %*% R_mat
B_mat

## ----absorbing-mc-pkg----
library(markovchain)
P_abs <- matrix(c(1,   0, 0,
                  0,   0, 1,
                  0.5, 0, 0.5), nrow = 3, byrow = TRUE)
mc_abs <- new("markovchain",
              states = sprintf("S_%d", 1:3),
              transitionMatrix = P_abs,
              name = "orange_abs")

## ----absorbing-mc-summary----
summary(mc_abs)

## ----absorbing-mc-functions----
absorbingStates(mc_abs)
meanAbsorptionTime(mc_abs)
absorptionProbabilities(mc_abs)

## ----U09-absorbing-realisation----
library(DTMCPack)
set.seed(2740)
IC <- c(0, 1, 0) # Start in S_2 (black female)
sol <- DTMC(P_abs, IC, 10, trace = TRUE)

## ----pagerank-3page-R----
P3 <- matrix(c(0, 0.5, 0.5,
               0, 0,   1,
               1, 0,   0), nrow = 3, byrow = TRUE)

# Solve (I - alpha * P^T) x = ((1 - alpha) / n) * 1 for alpha = 0.5
alpha <- 0.5
x_half <- solve(diag(3) - alpha * t(P3), rep((1 - alpha) / 3, 3))
MASS::fractions(x_half)

## ----pagerank-3page-igraph----
library(igraph)
edges3 <- matrix(c(1,2, 1,3, 2,3, 3,1), ncol = 2, byrow = TRUE)
g3 <- graph_from_edgelist(edges3, directed = TRUE)
page_rank(g3, damping = 0.85)$vector

## ----U09-pagerank-6page-graph----
edges <- matrix(c(1,2, 1,3, 2,3, 3,1, 2,4, 3,5, 5,6, 6,5),
                ncol = 2, byrow = TRUE)
g6 <- graph_from_edgelist(edges, directed = TRUE)
V(g6)$name <- paste0("P", 1:6)
pr6 <- page_rank(g6, damping = 0.85)$vector
round(pr6, 4)

par(mar = c(0, 0, 0, 0))
plot(g6, vertex.size = 350 * pr6 + 18, vertex.color = "lightblue",
     vertex.label.cex = 1.1, edge.arrow.size = 0.7)

## ----U09-pagerank-setup----
A6 <- as.matrix(as_adjacency_matrix(g6)) # a_{ij} = 1 if i -> j
n <- nrow(A6)
out_deg <- rowSums(A6)
P6 <- matrix(0, n, n)
for (i in 1:n) {
  if (out_deg[i] > 0) {
    P6[i, ] <- A6[i, ] / out_deg[i]
  } else {
    P6[i, ] <- rep(1 / n, n)
  }
}
alpha <- 0.85
x_exact <- solve(diag(n) - alpha * t(P6), rep((1 - alpha) / n, n))

## ----U09-pagerank-convergence----
x_k <- rep(1 / n, n)
err <- numeric(30)
for (k in 1:30) {
  x_k <- alpha * as.vector(t(P6) %*% x_k) + (1 - alpha) / n
  err[k] <- sum(abs(x_k - x_exact))
}
plot(1:30, err, type = "b", log = "y", pch = 19, col = "dodgerblue4",
     xlab = "Iteration k", ylab = "L1 error",
     main = "Geometric convergence of PageRank power iteration")
lines(1:30, err[1] * (alpha^(0:29)),
      lty = 2, lwd = 2, col = "firebrick")
legend("topright", c("Actual L1 error", "Rate 0.85^k"),
       col = c("dodgerblue4", "firebrick"), lty = 1:2)
