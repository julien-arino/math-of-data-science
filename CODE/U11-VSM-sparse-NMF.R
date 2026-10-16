## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "U11"


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


## ----r-tfidf-cosine,echo=TRUE-------------------------------------------------
terms = c("matrix", "vector", "eigen", "rank", "graph", "vertex", "edge", "data")
X = matrix(c(
  4, 3, 2, 1, 0, 0, 0, 5,  # d1: linear algebra
  3, 4, 0, 2, 0, 0, 0, 4,  # d2: linear algebra
  2, 1, 3, 2, 0, 0, 0, 6,  # d3: linear algebra
  0, 0, 0, 0, 4, 3, 2, 5,  # d4: graph theory
  0, 0, 0, 0, 3, 2, 4, 4,  # d5: graph theory
  0, 1, 0, 0, 2, 4, 3, 5   # d6: graph theory (mentions "vector" once)
), nrow = 6, ncol = 8, byrow = TRUE, dimnames = list(paste0("d", 1:6), terms))

# Right-multiplication by diagonal IDF matrix: X %*% D_IDF
df_j = colSums(X > 0)
idf_j = log(nrow(X) / df_j)
X_tfidf = X %*% diag(idf_j)

# Row l2 normalisation: X_hat = D_len^{-1} %*% X_tfidf
row_norms = sqrt(rowSums(X_tfidf^2))
X_hat = diag(1 / row_norms) %*% X_tfidf
S_gram = round(X_hat %*% t(X_hat), 2)


## ----plot-cosine-gram,echo=FALSE,fig.width=8,fig.height=4.5-------------------
par(mfrow = c(1, 2), mar = c(4, 5, 3, 2))
# Raw cosine similarity (with common word "data" included)
raw_norms = sqrt(rowSums(X^2))
X_raw_hat = diag(1 / raw_norms) %*% X
S_raw = X_raw_hat %*% t(X_raw_hat)

image(1:6, 1:6, S_raw[, 6:1], col = hcl.colors(20, "YlOrRd", rev = TRUE),
      zlim = c(0, 1), axes = FALSE, xlab = "Document", ylab = "Document",
      main = "Cosine similarity on raw counts X")
axis(1, at = 1:6, labels = paste0("d", 1:6))
axis(2, at = 1:6, labels = paste0("d", 6:1), las = 1)
for (i in 1:6) for (j in 1:6) {
  text(i, 7 - j, sprintf("%.2f", S_raw[i, j]), cex = 0.85)
}

image(1:6, 1:6, S_gram[, 6:1], col = hcl.colors(20, "YlOrRd", rev = TRUE),
      zlim = c(0, 1), axes = FALSE, xlab = "Document", ylab = "Document",
      main = "Cosine similarity after TF-IDF scaling")
axis(1, at = 1:6, labels = paste0("d", 1:6))
axis(2, at = 1:6, labels = paste0("d", 6:1), las = 1)
for (i in 1:6) for (j in 1:6) {
  text(i, 7 - j, sprintf("%.2f", S_gram[i, j]), cex = 0.85)
}


## ----r-nmf-als,echo=TRUE------------------------------------------------------
set.seed(2740)
k = 2
W = matrix(runif(nrow(X_tfidf) * k, 0.1, 1), nrow = nrow(X_tfidf), ncol = k)
H = matrix(0, nrow = k, ncol = ncol(X_tfidf))
err_history = numeric(30)

for (iter in 1:30) {
  # Update H by least squares and clip negatives to 0
  H = pmax(0, solve(t(W) %*% W + 1e-8 * diag(k), t(W) %*% X_tfidf))
  # Update W by least squares and clip negatives to 0
  W = pmax(0, t(solve(H %*% t(H) + 1e-8 * diag(k), H %*% t(X_tfidf))))
  # Normalise rows of H and rescale columns of W accordingly
  h_norms = sqrt(rowSums(H^2))
  H = diag(1 / h_norms) %*% H
  W = W %*% diag(h_norms)
  err_history[iter] = sum((X_tfidf - W %*% H)^2)
}
rownames(W) = paste0("d", 1:6); colnames(W) = c("Topic_1", "Topic_2")
rownames(H) = c("Topic_1", "Topic_2"); colnames(H) = terms


## ----r-nmf-inspect,echo=TRUE--------------------------------------------------
round(W, 2)
round(H, 3)


## ----plot-nmf-results,echo=FALSE,fig.width=8.5,fig.height=4.5-----------------
par(mfrow = c(1, 2), mar = c(4.5, 5.5, 3, 1.5))
plot(1:30, err_history, type = "b", pch = 19, col = "dodgerblue4", lwd = 2,
     xlab = "ALS iteration t", ylab = "Squared Frobenius error",
     main = "ALS convergence on TF-IDF matrix")
grid()

barplot(H[, 8:1], beside = TRUE, horiz = TRUE, las = 1,
        col = c("darkorange2", "steelblue3"),
        legend.text = c("Topic 1", "Topic 2"),
        args.legend = list(x = "bottomright", bty = "n"),
        xlab = "Non-negative word weight in H",
        main = "Learned topic dictionary rows of H")


## ----convert-Rnw-to-R,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

