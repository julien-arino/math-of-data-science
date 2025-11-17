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
orient_from_und <- function(g, p_recip = 0.20) {
  if (!requireNamespace("igraph", quietly = TRUE)) stop("igraph required")
  if (!igraph::is_igraph(g)) stop("g must be an igraph object")
  
  # if g is directed, work from its underlying undirected graph
  if (igraph::is_directed(g)) {
    g_und <- igraph::as_undirected(g, mode = "collapse")
  } else {
    g_und <- g
  }
  
  n <- igraph::vcount(g_und)
  
  # ensure stable vertex names so add_edges by name works
  vnames <- igraph::vertex_attr(g_und, "name")
  if (is.null(vnames)) vnames <- as.character(seq_len(n))
  
  # create empty directed graph with same vertex names
  gdir <- igraph::make_empty_graph(n = n, directed = TRUE)
  igraph::vertex_attr(gdir, "name") <- vnames
  
  # copy other vertex attributes (preserve them)
  vattrs <- setdiff(igraph::vertex_attr_names(g_und), "name")
  for (att in vattrs) {
    igraph::vertex_attr(gdir, att) <- igraph::vertex_attr(g_und, att)
  }
  
  # get undirected edge list as names (one row per undirected edge)
  el <- igraph::as_edgelist(g_und, names = TRUE)
  if (nrow(el) == 0) return(gdir)
  
  # orient each undirected edge: reciprocal with prob p_recip, otherwise random direction
  set.seed(123)
  for (i in seq_len(nrow(el))) {
    u <- el[i, 1]; v <- el[i, 2]
    if (runif(1) < p_recip) {
      gdir <- igraph::add_edges(gdir, c(u, v, v, u))
    } else if (runif(1) < 0.5) {
      gdir <- igraph::add_edges(gdir, c(u, v))
    } else {
      gdir <- igraph::add_edges(gdir, c(v, u))
    }
  }
  
  return(gdir)
}

