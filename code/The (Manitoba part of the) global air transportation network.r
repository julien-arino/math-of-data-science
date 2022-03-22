INSTALL = FALSE
if (INSTALL) {
    install.packages(c("dplyr", "readr", "sqldf", "igraph", "ggraph", "raster", "DescTools"))
} else {
    library(dplyr)
    library(readr)
    library(igraph)
    library(ggraph)
    library(raster)
}

air_travel_MB <- read_delim("air_travel_MB.csv", 
                     delim = ",", escape_double = FALSE,
                               trim_ws = TRUE)
airport_codes_MB <- read_csv("airport_codes_CAN.csv") %>%
  filter(ISO_Region == "CA-MB")
head(air_travel_MB)
head(airport_codes_MB)

query = 
"SELECT orig,dest,SUM(vol) AS vol
FROM air_travel_MB
GROUP BY orig,dest
ORDER BY orig,dest"

air_travel_MB = sqldf::sqldf(query)

IATA_codes_MB_in_data = data.frame(IATA = sort(unique(union(air_travel_MB$orig,
                                                            air_travel_MB$dest))))
lon = c()
lat = c()
for (i in 1:dim(IATA_codes_MB_in_data)[1]) {
  idx = which(airport_codes_MB$IATA_Code == IATA_codes_MB_in_data$IATA[i])
  if (length(idx) == 0) {
    lon = c(lon, -90)
    lat = c(lat, 49.5)
  } else {
    lon = c(lon, airport_codes_MB$Longitude[idx])
    lat = c(lat, airport_codes_MB$Latitude[idx])
  }
}
IATA_codes_MB_in_data$lon = lon
IATA_codes_MB_in_data$lat = lat

head(IATA_codes_MB_in_data)

G = graph_from_data_frame(air_travel_MB)
V(G)$x = lon
V(G)$y = lat

plot(G, edge.arrow.size = 0.5, edge.arrow.width = 0.75)

G_MB = induced_subgraph(G, V(G)$name[V(G)$name != "RoW"])
plot(G_MB, edge.arrow.size = 0.5, edge.arrow.width = 0.75)

options(repr.plot.width=15, repr.plot.height=15)
Canada <- getData('GADM', country='CAN', level=1)
MB <- Canada[Canada$NAME_1 == "Manitoba",]
plot(MB)
plot(G, add = TRUE, rescale = FALSE,
    edge.arrow.size = 0.5, edge.arrow.width = 0.75)

plot(MB)
V(G)$size = degree(G, mode = "out")*10
plot(G, add = TRUE, rescale = FALSE,
    edge.arrow.size = 0.5, edge.arrow.width = 0.75)

plot(MB)
V(G_MB)$size = degree(G_MB)*5
plot(G_MB, add = TRUE, rescale = FALSE,
    edge.arrow.size = 0.5, edge.arrow.width = 0.75)

plot(MB)
V(G_MB)$size = degree(G_MB)*5
plot(G_MB, add = TRUE, rescale = FALSE, edge.width = E(G_MB)$vol,
    edge.arrow.size = 0.5, edge.arrow.width = 0.75)

sort(E(G)$vol)

plot(MB)
V(G)$size = degree(G)*5
plot(G, add = TRUE, rescale = FALSE, edge.width = E(G)$vol*0.001,
    edge.arrow.size = 0.5, edge.arrow.width = 0.75)

plot(MB)
V(G)$size = degree(G)*5
plot(G, add = TRUE, rescale = FALSE, edge.width = E(G)$vol*0.0005,
    edge.arrow.size = 0.5, edge.arrow.width = 0.75)

options(repr.plot.width=10, repr.plot.height=10)
plot(sort(E(G)$vol), type = "b")

sigmoid = function(x, c) {
    return(1/(1+exp(-c*x)))
}

values_c = c(0.0001, 0.0005, 0.001, 0.005, 0.01)
x = 1:length(E(G))
values_x = sort(E(G)$vol)
my_palette = viridis::viridis(length(values_c))

# First, we plot the "data" (scaled to the [0,1] range)
plot(x, (values_x-min(values_x))/max(values_x), 
     type = "b", col = "red",
     ylim = (range(values_x)-min(values_x))/max(values_x))
for (c in values_c) {
    idx = which(c == values_c) # Find which position in the values_c vector, for colour
    tmp = sigmoid(values_x, c) # Let us rescale the result to between 0 and 1
    tmp = tmp-min(tmp)
    tmp = tmp/max(tmp)
    lines(x, tmp, type = "b", col = my_palette[idx])
}

options(repr.plot.width=15, repr.plot.height=15)
edge_widths = 2*sigmoid(E(G)$vol, 0.1)

plot(MB)
V(G)$size = degree(G)*5
plot(G, add = TRUE, rescale = FALSE, 
     edge.width = edge_widths, type = "b",
    edge.arrow.size = 0.5, edge.arrow.width = 0.75)

plot(MB)
V(G)$size = degree(G)*5
plot(G, add = TRUE, rescale = FALSE, edge.width = E(G)$vol*0.0005,
    edge.arrow.size = 0.5, edge.arrow.width = 0.75)

plot(MB)
V(G_MB)$size = degree(G_MB)*5
plot(G_MB, add = TRUE, rescale = FALSE, 
     edge.width = E(G_MB)$vol*0.001,
    edge.arrow.size = 0.5, edge.arrow.width = 0.75)

distances(G_MB)

distances(G_MB, mode = "out")

eccentricity(G_MB)
eccentricity(G_MB, mode = "in")
eccentricity(G_MB, mode = "out")
writeLines("Radius (all/in/out):")
radius(G_MB)
radius(G_MB, mode = "in")
radius(G_MB, mode = "out")
writeLines("Diameter (all/in/out:")
diameter(G_MB)
max(distances(G_MB, mode = "in"))
max(distances(G_MB, mode = "out"))

e_out = eccentricity(G_MB, mode = "out")
writeLines("Central points:")
V(G_MB)[which(e_out == min(e_out))]$name
V(G_MB)[which(e_out == min(e_out))]$color = "red"
writeLines("Periphery:")
V(G_MB)[which(e_out == max(e_out))]$name
V(G_MB)[which(e_out == max(e_out))]$color = "blue"

plot(MB)
V(G_MB)$size = degree(G_MB)*5
plot(G_MB, add = TRUE, rescale = FALSE, 
     edge.width = E(G_MB)$vol*0.001,
    edge.arrow.size = 0.5, edge.arrow.width = 0.75)

girth(G)
girth(G_MB)

edge_density(G)
edge_density(G_MB)

is.connected(G_MB, "weak")
is.connected(G_MB, "strong")

articulation_points(G_MB)

G_disconnected = induced_subgraph(G_MB, V(G_MB)$name[V(G_MB)$name != "YTH"])
is_connected(G_disconnected)

comps <- components(G_disconnected)$membership
colbar <- rainbow(max(comps)+1)
V(G_disconnected)$color <- colbar[comps+1]

plot(MB)
V(G_disconnected)$size = rep(50,length(V(G_disconnected)))
plot(G_disconnected, add = TRUE, rescale = FALSE, 
     edge.width = E(G_disconnected)$vol*0.001,
    edge.arrow.size = 0.5, edge.arrow.width = 0.75)

lc = largest_cliques(G_MB)
lc
vert_largest_clique = lc[[1]]

V(G_MB)$color = "blue"
V(G_MB)[vert_largest_clique]$color = "red"

plot(MB)
V(G_MB)$size = rep(50,length(V(G_MB)))
plot(G_MB, add = TRUE, rescale = FALSE, 
     edge.width = E(G_disconnected)$vol*0.001,
    edge.arrow.size = 0.5, edge.arrow.width = 0.75)

degree(G_MB, mode = "out")
degree(G_MB, mode = "in")
degree(G_MB)
distrib_outdegree = degree_distribution(G, mode = "out")
distrib_indegree = degree_distribution(G, mode = "in")
distrib_degree = degree_distribution(G)

options(repr.plot.width=10, repr.plot.height=10)

distrib_outdegree = degree_distribution(G_MB, mode = "out")
distrib_indegree = degree_distribution(G_MB, mode = "in")
distrib_degree = degree_distribution(G_MB)

y_max = max(max(distrib_indegree, distrib_outdegree), distrib_degree)
plot(distrib_degree, type = "b", lwd = 2, col = "black", ylim = c(0, y_max))
points(distrib_outdegree, type = "b", lwd = 2, col = "blue")
points(distrib_indegree, type = "b", lwd = 2, col = "red")

knn(G_MB, mode = "all")
knn(G_MB, mode = "in")
knn(G_MB, mode = "out")

options(repr.plot.width=15, repr.plot.height=15)

knn_in = knn(G_MB, mode = "in")$knn
knn_in_bar = sort(unique(round(knn_in)))
colbar <- viridis::viridis(max(ceiling(knn_in)))
V(G_MB)$color <- colbar[round(knn_in)]

plot(MB)
V(G_MB)$size = rep(75,length(V(G_MB)))
plot(G_MB, add = TRUE, rescale = FALSE, 
     edge.width = E(G_MB)$vol*0.001,
     edge.arrow.size = 0.5, 
     edge.arrow.width = 0.75)
DescTools::ColorLegend(x = "right", col = colbar, 
                       width = 0.5, inset = 0.1,
                       labels = sprintf("%d", knn_in_bar))

coreness(G_MB, "all")
coreness(G_MB, "in")
coreness(G_MB, "out")

cores = coreness(G_MB, "out")
colbar <- viridis::viridis(max(cores))
V(G_MB)$color <- colbar[cores]

plot(MB)
V(G_MB)$size = rep(75,length(V(G_MB)))
plot(G_MB, add = TRUE, rescale = FALSE, 
     edge.width = E(G_MB)$vol*0.001,
    edge.arrow.size = 0.5, edge.arrow.width = 0.75)
legend("bottomright", 
       legend = sprintf("%d", sort(unique(cores))),
       pch = rep(19, length(unique(cores))),
       pt.cex = rep(5, length(unique(cores))),
       cex = 2,
       box.lty=0,
       col = colbar[sort(unique(cores))])

betweenness(G)
betweenness(G_MB)

betweenness_MB = betweenness(G_MB)
# shift numbers by 1 because the second command fails when there are zeros..
colbar <- viridis::viridis(max(ceiling(betweenness_MB))+1)
V(G_MB)$color <- colbar[round(betweenness_MB)+1]
# For the label of the colour bar
colbar_str = sprintf("%d", range(unique(round(betweenness_MB))))

plot(MB)
V(G_MB)$size = rep(75,length(V(G_MB)))
plot(G_MB, add = TRUE, rescale = FALSE, 
     edge.width = E(G_MB)$vol*0.001,
     edge.arrow.size = 0.5, 
     edge.arrow.width = 0.75)
DescTools::ColorLegend(x = "right", col = colbar, 
                       width = 0.5, inset = 0.1,
                       labels = colbar_str)

closeness(G_MB, mode = "all")
closeness(G_MB, mode = "in")
closeness(G_MB, mode = "out")

# Unweighted case
cl_MB_U = closeness(G_MB, mode = "out")
cl_MB_U
# Weighted case
cl_MB_W = closeness(G_MB, mode = "out", weights = E(G_MB)$vol)
cl_MB_W

options(repr.plot.width=10, repr.plot.height=10)

range(cl_MB_U)
plot(sort(cl_MB_U))
range(cl_MB_W)
plot(sort(cl_MB_W))

range(cl_MB_U * 1e4)
range(cl_MB_W * 1e7)

options(repr.plot.width=15, repr.plot.height=15)

cl_MB_U_tmp = cl_MB_U * 1e4
Delta_cl = ceiling(max(cl_MB_U_tmp)-min(cl_MB_U_tmp))
colbar <- viridis::viridis(Delta_cl+1)
V(G_MB)$color <- colbar[round(cl_MB_U_tmp-min(cl_MB_U_tmp))+1]
# For the label of the colour bar
colbar_str = sprintf("%f", range(cl_MB_U_tmp))

plot(MB)
V(G_MB)$size = rep(75,length(V(G_MB)))
plot(G_MB, add = TRUE, rescale = FALSE, 
     edge.width = E(G_MB)$vol*0.001,
     edge.arrow.size = 0.5, 
     edge.arrow.width = 0.75)
DescTools::ColorLegend(x = "right", col = colbar, 
                       width = 0.5, inset = 0.1,
                       labels = colbar_str)

cl_MB_W_tmp = cl_MB_W * 1e7
Delta_cl = ceiling(max(cl_MB_W_tmp)-min(cl_MB_W_tmp))
colbar <- viridis::viridis(Delta_cl+1)
V(G_MB)$color <- colbar[round(cl_MB_W_tmp-min(cl_MB_W_tmp))+1]
# For the label of the colour bar
colbar_str = sprintf("%f", range(cl_MB_W_tmp))

plot(MB)
V(G_MB)$size = rep(75,length(V(G_MB)))
plot(G_MB, add = TRUE, rescale = FALSE, 
     edge.width = E(G_MB)$vol*0.001,
     edge.arrow.size = 0.5, 
     edge.arrow.width = 0.75)
DescTools::ColorLegend(x = "right", col = colbar, 
                       width = 0.5, inset = 0.1,
                       labels = colbar_str)

par(mfrow=c(1,2))

# Unweighted MB only
Delta_cl = ceiling(max(cl_MB_U_tmp)-min(cl_MB_U_tmp))
colbar <- viridis::viridis(Delta_cl+1)
V(G_MB)$color <- colbar[round(cl_MB_U_tmp-min(cl_MB_U_tmp))+1]
# For the label of the colour bar
colbar_str = sprintf("%f", range(cl_MB_U_tmp))
plot(MB)
V(G_MB)$size = rep(75,length(V(G_MB)))
plot(G_MB, add = TRUE, rescale = FALSE, 
     edge.width = E(G_MB)$vol*0.001,
     edge.arrow.size = 0.5, 
     edge.arrow.width = 0.75)

# Weighted MB only
Delta_cl = ceiling(max(cl_MB_W_tmp)-min(cl_MB_W_tmp))
colbar <- viridis::viridis(Delta_cl+1)
V(G_MB)$color <- colbar[round(cl_MB_W_tmp-min(cl_MB_W_tmp))+1]
# For the label of the colour bar
colbar_str = sprintf("%f", range(cl_MB_W_tmp))
plot(MB)
V(G_MB)$size = rep(75,length(V(G_MB)))
plot(G_MB, add = TRUE, rescale = FALSE, 
     edge.width = E(G_MB)$vol*0.001,
     edge.arrow.size = 0.5, 
     edge.arrow.width = 0.75)

# Unweighted case
cl_MB_RoW_U = closeness(G, mode = "out")
range(cl_MB_RoW_U)
# Weighted case
cl_MB_RoW_W = closeness(G, mode = "out", weights = E(G)$vol)
range(cl_MB_RoW_W)

par(mfrow=c(2,2))

cl_MB_RoW_U_tmp = cl_MB_RoW_U * 1e4
cl_MB_RoW_W_tmp = cl_MB_RoW_W * 1e7

# Unweighted MB only
Delta_cl = ceiling(max(cl_MB_U_tmp)-min(cl_MB_U_tmp))
colbar <- viridis::viridis(Delta_cl+1)
V(G_MB)$color <- colbar[round(cl_MB_U_tmp-min(cl_MB_U_tmp))+1]
# For the label of the colour bar
colbar_str = sprintf("%f", range(cl_MB_U_tmp))
plot(MB)
V(G_MB)$size = rep(75,length(V(G_MB)))
plot(G_MB, add = TRUE, rescale = FALSE, 
     edge.width = E(G_MB)$vol*0.001,
     edge.arrow.size = 0.5, 
     edge.arrow.width = 0.75)

# Weighted MB only
Delta_cl = ceiling(max(cl_MB_W_tmp)-min(cl_MB_W_tmp))
colbar <- viridis::viridis(Delta_cl+1)
V(G_MB)$color <- colbar[round(cl_MB_W_tmp-min(cl_MB_W_tmp))+1]
# For the label of the colour bar
colbar_str = sprintf("%f", range(cl_MB_W_tmp))
plot(MB)
V(G_MB)$size = rep(75,length(V(G_MB)))
plot(G_MB, add = TRUE, rescale = FALSE, 
     edge.width = E(G_MB)$vol*0.001,
     edge.arrow.size = 0.5, 
     edge.arrow.width = 0.75)

# Unweighted MB with RoW
Delta_cl = ceiling(max(cl_MB_RoW_U_tmp)-min(cl_MB_RoW_U_tmp))
colbar <- viridis::viridis(Delta_cl+1)
V(G)$color <- colbar[round(cl_MB_RoW_U_tmp-min(cl_MB_RoW_U_tmp))+1]
# For the label of the colour bar
colbar_str = sprintf("%f", range(cl_MB_RoW_U_tmp))
plot(MB)
V(G)$size = rep(75,length(V(G)))
plot(G, add = TRUE, rescale = FALSE, 
     edge.width = E(G)$vol*0.0001,
     edge.arrow.size = 0.5, 
     edge.arrow.width = 0.75)

# Weighted MB with RoW
Delta_cl = ceiling(max(cl_MB_RoW_W_tmp)-min(cl_MB_RoW_W_tmp))
colbar <- viridis::viridis(Delta_cl+1)
V(G)$color <- colbar[round(cl_MB_RoW_W_tmp-min(cl_MB_RoW_W_tmp))+1]
# For the label of the colour bar
colbar_str = sprintf("%f", range(cl_MB_RoW_W_tmp))
plot(MB)
V(G)$size = rep(75,length(V(G)))
plot(G, add = TRUE, rescale = FALSE, 
     edge.width = E(G)$vol*0.0001,
     edge.arrow.size = 0.5, 
     edge.arrow.width = 0.75)
