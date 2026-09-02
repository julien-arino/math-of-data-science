library(igraph)
library(expm)  

A1 = matrix(c(0,1,0,0,0,0,
             1,1,1,1,0,0,
             0,0,0,0,0,1,
             0,0,1,0,0,0,
             1,0,0,0,0,0,
             0,0,0,0,1,1),
           nr = 6, byrow = TRUE)
G1 = graph_from_adjacency_matrix(A1, mode = "directed")
plot(G1)
eccentricity(G1)
D = distances(G1, mode="out")
power_matrix = list()
power_matrix[[1]] = A1
for (i in 2:5) {
  power_matrix[[i]] = A1 %^% i
}
nb_shortest_paths = A1 * 0
for (i in 1:dim(A1)[1]) {
  for (j in 1:dim(A1)[2]) {
    if (i != j) {
      nb_shortest_paths[i,j] = power_matrix[[D[i,j]]][i,j]
    }
  }
}

A2 = matrix(c(0,1,0,0,0,0,
              1,1,1,1,0,0,
              0,0,0,0,0,1,
              0,0,1,0,0,0,
              0,0,0,0,0,0,
              0,0,0,0,1,1),
            nr = 6, byrow = TRUE)
G2 = graph_from_adjacency_matrix(A2, mode = "directed")
plot(G2)


A3 = matrix(c(0,1,0,0,1,0,
              1,1,1,1,0,0,
              0,1,1,0,0,1,
              0,1,1,0,0,0,
              0,0,0,0,0,1,
              0,0,1,0,1,1),
            nr = 6, byrow = TRUE)
G3 = graph_from_adjacency_matrix(A3, mode = "undirected")
plot(G3)
coreness(G3)
degree(G3)
