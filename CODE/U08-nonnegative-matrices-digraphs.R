## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "U08"


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


## ----u08-igraph-digraph-------------------------------------------------------
M <- matrix(c(0, 1, 0, 0,
              0, 0, 1, 1,
              1, 0, 0, 0,
              0, 0, 1, 1), nrow = 4, byrow = TRUE)
G <- graph_from_adjacency_matrix(M, mode = "directed")
degree(G, mode = "out")
degree(G, mode = "in")
plot(G, edge.arrow.size = 0.7, vertex.color = "lightblue",
     vertex.size = 30, main = "Digraph G(M) from adjacency matrix M")


## ----u08-check-irreducible-r--------------------------------------------------
A <- matrix(c(0, 2, 0, 0,  0, 0, 1, 3,
              0, 0, 0, 1,  4, 0, 0, 0), nrow = 4, byrow = TRUE)
is_connected(graph_from_adjacency_matrix(A > 0), mode = "strong")
# Compute (I_4 + A)^3
I4_plus_A <- diag(4) + A
I4_plus_A %*% I4_plus_A %*% I4_plus_A


## ----u08-cat-eigen------------------------------------------------------------
P_reg <- matrix(c(0.5, 0,   0.25,
                  0,   0.5, 0.25,
                  0.5, 0.5, 0.5),
                nrow = 3, byrow = TRUE)
# Dominant right eigenvector corresponding to eigenvalue 1
ev <- eigen(P_reg)
v_stat <- Re(ev$vectors[, 1])
v_stat <- v_stat / sum(v_stat)
v_stat


## ----u08-cat-power------------------------------------------------------------
# Compute P^20 by repeated multiplication
P_20 <- Reduce(`%*%`, replicate(20, P_reg, simplify = FALSE))
round(P_20, 6)


## ----u08-convergence-plot,echo=TRUE-------------------------------------------
t_max <- 12
p_hist <- matrix(0, nrow = 3, ncol = t_max + 1)
p_hist[, 1] <- c(1, 0, 0) # Start in S_1 (100% orange)
for (t in 1:t_max) p_hist[, t + 1] <- P_reg %*% p_hist[, t]
cols <- c("darkorange", "black", "brown")
matplot(0:t_max, t(p_hist), type = "b", pch = 19, lty = 1,
        lwd = 2, col = cols, ylim = c(0, 1), xlab = "Generation t",
        ylab = expression("Probability " * p[i](t)),
        main = "Convergence to v = (0.25, 0.25, 0.5)")
legend("topright",
       legend = c("S1 (orange)", "S2 (black)", "S3 (tortie)"),
       col = cols, lty = 1, pch = 19, lwd = 2)


## ----u08-dtmc-realisation,echo=TRUE-------------------------------------------
set.seed(2740)
n_steps <- 40; states <- numeric(n_steps + 1); states[1] <- 1
for (t in 1:n_steps) {
  states[t + 1] <- sample(1:3, 1, prob = P_reg[, states[t]])
}
plot(0:n_steps, states, type = "b", pch = 19, lwd = 1.8,
     col = "darkblue", yaxt = "n",
     xlab = "Generation t", ylab = "State",
     main = "Single realisation (40 generations)")
axis(2, at = 1:3,
     labels = c("S1 (orange)", "S2 (black)", "S3 (tortie)"))


## ----u08-ergodic-check--------------------------------------------------------
set.seed(2740)
n_long <- 10000; traj <- numeric(n_long); traj[1] <- 1
for (t in 1:(n_long - 1)) {
  traj[t + 1] <- sample(1:3, 1, prob = P_reg[, traj[t]])
}
rbind(empirical = prop.table(table(factor(traj, levels = 1:3))),
      stationary = v_stat)


## ----convert-Rnw-to-R,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

