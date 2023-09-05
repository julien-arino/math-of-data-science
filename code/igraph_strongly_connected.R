circles = read.csv("0.circles", sep = "\t", header = FALSE)
edges = read.csv("0.edges", sep = " ", header = FALSE)

circles
head(edges)

dim(circles)

processFile = function(filepath) {
    con = file(filepath, "r")
    OUT = list()
    i = 1
    while ( TRUE ) {
        line = readLines(con, n = 1)
        if ( length(line) == 0 ) {
            break
        }
        OUT[[i]] = line
        i = i+1
    }
    close(con)
    return(OUT)
}

circles = processFile("0.circles")

circles[[1]]

for (i in 1:length(circles)) {
    circles[[i]] = gsub("\t", ",", circles[[i]])
}
circles[[1]]

library(igraph)
G = graph_from_edgelist(as.matrix(edges), directed = FALSE)
plot(G)

gorder(G)

C = components(G)
writeLines(paste0("Number of components: ", C$no))
C$csize

groups(C)

idx_large = which(unlist(lapply(groups(C), length) == max(C$csize)))
idx_large

G_c = induced_subgraph(G, groups(C)[[idx_large]])
plot(G_c)

twitch <- read.csv(unz("large_twitch_edges.csv.zip", "large_twitch_edges.csv"))

head(twitch)
dim(twitch)

#G = graph_from_edgelist(as.matrix(twitch), directed = FALSE)

# The following version of which returns array (matrix) indices of the found 
# entries, because the zeros can be in both columns of twitch. But then we only need 
# the rows in that index set.
idx_zero = which(twitch == 0, arr.ind = TRUE)[1]
twitch = twitch[setdiff(1:dim(twitch)[1], idx_zero),]

G = graph_from_edgelist(as.matrix(twitch), directed = FALSE)
