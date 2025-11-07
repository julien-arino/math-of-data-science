library(igraph)
set.seed(42)

# parameters
n <- 30
sizes <- c(10, 10, 10)
pref <- matrix(c(
  0.30, 0.02, 0.02,
  0.02, 0.25, 0.02,
  0.02, 0.02, 0.28), nrow=3, byrow=TRUE)

# sample undirected SBM (connected for these params usually)
G_und <- sample_sbm(n, pref.matrix=pref, block.sizes=sizes, directed=FALSE, loops=FALSE)

# function to orient edges with some reciprocity
orient_from_und <- function(g, p_recip=0.20) {
  el <- as_edgelist(g, names=FALSE)
  gdir <- make_empty_graph(n=vcount(g), directed=TRUE)
  for(i in seq_len(nrow(el))) {
    u <- el[i,1]; v <- el[i,2]
    if (runif(1) < p_recip) {
      gdir <- add_edges(gdir, c(u, v, v, u))
    } else if (runif(1) < 0.5) {
      gdir <- add_edges(gdir, c(u, v))
    } else {
      gdir <- add_edges(gdir, c(v, u))
    }
  }
  V(gdir)$block <- rep(1:length(sizes), sizes)
  return(gdir)
}

# G_dir <- orient_from_und(G_und, p_recip=0.25)
