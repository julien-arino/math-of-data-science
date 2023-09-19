library(igraph)
#install.packages("expm")
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

A1p = matrix(c(0,1,0,0,0,0,
             1,0,1,1,0,0,
             0,0,0,0,0,1,
             0,0,1,0,0,0,
             1,0,0,0,0,0,
             0,0,0,0,1,0),
           nr = 6, byrow = TRUE)
G1p = graph_from_adjacency_matrix(A1p, mode = "directed")
plot(G1p)

A2 = matrix(c(0,1,0,0,0,0,
              1,1,1,1,0,0,
              0,0,0,0,0,1,
              0,0,1,0,0,0,
              0,0,0,0,0,0,
              0,0,0,0,1,1),
            nr = 6, byrow = TRUE)
G2 = graph_from_adjacency_matrix(A2, mode = "directed")
plot(G2)

# # Eccentricity and distances 

eccentricity(G1, mode = "out")
eccentricity(G1p, mode = "out")
eccentricity(G1, mode = "in")
# The following 2 are the same ("all" is the default mode)
eccentricity(G1)
eccentricity(G1, mode = "all")

eccentricity(G2, mode = "in")
eccentricity(G2, mode = "out")

# # Degrees

degree(G1, mode = "in")
degree(G1, mode = "out")
degree(G1, mode = "all")

degree_distribution(G1, mode = "in")
degree_distribution(G1, mode = "out")
degree_distribution(G1, mode = "all")

knn(G1p, mode = "in")
knn(G1p, mode = "out")
knn(G1p, mode = "all")

coreness(G1, mode = "in")
coreness(G1, mode = "out")
coreness(G1, mode = "all")

D = distances(G1, mode="out")
powers_A = list()
powers_A[[1]] = A1
for (k in 2:5) {
    powers_A[[k]] = A1 %^% k
}
sigma_st = A1 * 0
for (r in 1:dim(sigma_st)[1]) {
    for (c in 1:dim(sigma_st)[2]) {
        if (r != c) {
            sigma_st[r,c] = powers_A[[D[r,c]]][r,c]
        }
    }
}
sigma_st

A3 = matrix(c(0,1,0,1,0,0,
             1,1,1,1,0,0,
             0,0,0,0,0,1,
             0,0,1,0,0,0,
             1,0,0,0,0,0,
             0,0,0,0,1,1),
           nr = 6, byrow = TRUE)
G3 = graph_from_adjacency_matrix(A3, mode = "directed")
plot(G3)
D = distances(G3, mode="out")
powers_A = list()
powers_A[[1]] = A3
for (k in 2:5) {
    powers_A[[k]] = A3 %^% k
}
sigma_st = A3 * 0
for (r in 1:dim(sigma_st)[1]) {
    for (c in 1:dim(sigma_st)[2]) {
        if (r != c) {
            sigma_st[r,c] = powers_A[[D[r,c]]][r,c]
        }
    }
}
sigma_st

all_shortest_paths(G3, from = 1, to = 3, mode = "out")

betweenness(G1, directed = TRUE, normalized = TRUE)
betweenness(G1, directed = TRUE, normalized = FALSE)
betweenness(G1, directed = FALSE, normalized = TRUE)
betweenness(G1, directed = FALSE, normalized = FALSE)
betweenness(G3, directed = TRUE, normalized = TRUE)
betweenness(G3, directed = TRUE, normalized = FALSE)

A4 = matrix(c(0,1,0,0,0,0,
             1,0,1,0,0,0,
             0,1,0,1,0,0,
             0,0,1,0,1,0,
             0,0,0,1,0,1,
             0,0,0,0,1,1),
           nr = 6, byrow = TRUE)
G4 = graph_from_adjacency_matrix(A4, mode = "directed")
plot(G4)
betweenness(G4, directed = TRUE, normalized = TRUE)
A5 = matrix(c(0,1,0,0,0,1,
             1,0,1,0,0,0,
             0,1,0,1,0,0,
             0,0,1,0,1,0,
             0,0,0,1,0,1,
             1,0,0,0,1,0),
           nr = 6, byrow = TRUE)
G5 = graph_from_adjacency_matrix(A5, mode = "directed")
plot(G5)
betweenness(G5, directed = TRUE, normalized = TRUE)

closeness(G1, normalized = TRUE, mode = "out")
closeness(G3, normalized = TRUE, mode = "out")
closeness(G4, normalized = TRUE, mode = "out")
closeness(G5, normalized = TRUE, mode = "out")
