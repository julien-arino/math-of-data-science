library(dplyr)
library(readr)
library(sqldf)
library(igraph)
require(Cairo)
library(ggraph)

IATA_PHAC2015_07 <- read_delim("/mnt/DATA/GEOGRAPHY/IATA_PHAC2015_07.csv", 
                               delim = ";", escape_double = FALSE, col_names = FALSE, 
                               trim_ws = TRUE)
airport_codes_MB <- read_csv("/mnt/DATA/GEOGRAPHY/airport_codes_CAN.csv") %>%
  filter(ISO_Region == "CA-MB")

IATA_codes_MB = unique(airport_codes_MB$IATA_Code)
IATA_codes_MB = IATA_codes_MB[which(!is.na(IATA_codes_MB))]

in_MB = list()
in_MB_rows = c()
for (a in IATA_codes_MB) {
  writeLines(paste0("airport=", a))
  tmp = which(IATA_PHAC2015_07[,3:9] == a, arr.ind = TRUE)
  if (length(tmp)>0) {
    in_MB[[a]] = tmp
    in_MB_rows = c(in_MB_rows, tmp[,1])
  } 
}

IATA_PHAC2015_07 = IATA_PHAC2015_07[in_MB_rows,]

for (r in 1:dim(IATA_PHAC2015_07)[1]) {
  for (c in 3:9) {
    if (!(IATA_PHAC2015_07[r,c] %in% IATA_codes_MB)) {
      if (!is.na(IATA_PHAC2015_07[r,c])) {
        IATA_PHAC2015_07[r,c] = "RoW"
      }
    }
  }
}

IATA_PHAC2015_07 = IATA_PHAC2015_07[,c(2:9,18)]
colnames(IATA_PHAC2015_07) = c("yymm", 
                               "orig", 
                               "stop1", "stop2", "stop3", "stop4", "stop5",
                               "dest",
                               "vol")

# Find trips that start/end in MB and finish in RoW with no intermediate stops
arcs = data.frame(orig = NA, dest = NA, vol = NA)
for (r in 1:dim(IATA_PHAC2015_07)[1]){
  idx_in_MB_row = which(IATA_PHAC2015_07[r,2:8] %in% IATA_codes_MB)+1
  if (length(idx_in_MB_row) == 1) {
    if (idx_in_MB_row == 2) {
      # The trip started in MB
      arcs = rbind(arcs, 
                   c(IATA_PHAC2015_07$orig[r], "RoW", IATA_PHAC2015_07$vol[r]))
    } else if (idx_in_MB_row == 8) {
      # The trip terminated in MB
      arcs = rbind(arcs, 
                   c("RoW", IATA_PHAC2015_07$dest[r], IATA_PHAC2015_07$vol[r]))
    }
  } else {
    if (idx_in_MB_row[1] == 2) {
      # The trip started in MB
      for (d in 2:length(idx_in_MB_row)) {
        idx1 = idx_in_MB_row[(d-1)]
        idx2 = idx_in_MB_row[d]
        arcs = rbind(arcs, 
                     c(orig = as.character(IATA_PHAC2015_07[r,idx1]), 
                       dest = as.character(IATA_PHAC2015_07[r,idx2]), 
                       vol = IATA_PHAC2015_07$vol[r]))
      }
      arcs = rbind(arcs, 
                   c(orig = as.character(IATA_PHAC2015_07[r,idx2]), 
                     dest = "RoW", 
                     vol = IATA_PHAC2015_07$vol[r]))
    } else if (idx_in_MB_row[length(idx_in_MB_row)] == 8) {
      # The trip terminated in MB
      idx = idx_in_MB_row[1]
      arcs = rbind(arcs, 
                   c(orig = "RoW", 
                     dest = as.character(IATA_PHAC2015_07[r,idx]), 
                     vol = IATA_PHAC2015_07$vol[r]))
      for (d in 2:length(idx_in_MB_row)) {
        idx1 = idx_in_MB_row[(d-1)]
        idx2 = idx_in_MB_row[d]
        arcs = rbind(arcs, 
                     c(orig = as.character(IATA_PHAC2015_07[r,idx1]), 
                       dest = as.character(IATA_PHAC2015_07[r,idx2]), 
                       vol = IATA_PHAC2015_07$vol[r]))
      }
    }
  }
}

arcs = arcs[complete.cases(arcs),]
arcs$vol = as.numeric(arcs$vol)

query = 
"SELECT orig,dest,SUM(vol) AS vol
FROM arcs
GROUP BY orig,dest
ORDER BY orig,dest"

arcs = sqldf(query)

IATA_codes_MB_in_data = data.frame(IATA = sort(unique(union(arcs$orig,arcs$dest))))
lon = c()
lat = c()
for (i in 1:dim(IATA_codes_MB_in_data)[1]) {
  idx = which(airport_codes_MB$IATA_Code == IATA_codes_MB_in_data$IATA[i])
  if (length(idx) == 0) {
    lon = c(lon, -90)
    lat = c(lat, 48)
  } else {
    lon = c(lon, airport_codes_MB$Longitude[idx])
    lat = c(lat, airport_codes_MB$Latitude[idx])
  }
}
IATA_codes_MB_in_data$lon = lon
IATA_codes_MB_in_data$lat = lat


G = graph_from_data_frame(as.matrix(arcs[,1:2]),
                          vertices = IATA_codes_MB_in_data)
V(G)$x = lon
V(G)$y = lat

plot(G)
# 
# df <- data.frame("from" = c("Bob", "Klaus", "Edith", "Liu"), 
#                  "to" = c("Edith", "Edith", "Bob", "Klaus"))
# 
# meta <- data.frame("name" = c("Bob", "Klaus", "Edith", "Liu"), 
#                    "lon" = c(-74.00714, 13.37699, 2.34120, 116.40708), 
#                    "lat" = c(40.71455, 52.51607, 48.85693, 39.90469))
# 
# g <- graph.data.frame(df, directed = TRUE, vertices = meta)
# 

#lo <- layout.norm(as.matrix(meta[,2:3]))

dpi = 1.0
# Cairo(file = 'map-graph.svg', type = "svg",
#       units = "in",
#       width = 4 / dpi,
#       height = 2 / dpi,
#       dpi = dpi)

#png("map.png")
plot.igraph(G,
            #layout = lo,
            xlim = range(IATA_codes_MB_in_data$lon),
            ylim = range(IATA_codes_MB_in_data$lat),
            rescale = FALSE,
            edge.curved = TRUE,
            edge.arrow.size = 10 / dpi,
            edge.arrow.width = 0.5 / dpi,
            vertex.label.dist = 50 / dpi,
            vertex.label.degree = 90 / dpi,
            vertex.size = 200 / dpi,
            vertex.label.cex = 21 / dpi,
            vertex.frame.color = NA,
            vertex.label.color = '#FFFF00',
            edge.color = '#FFFFFF',
            vertex.label.family = 'sans-serif',
            edge.width = 16 / dpi)

#dev.off()


library(raster)
Manitoba <- getData('GADM', country='CAN', level=1)
MB <- Manitoba[Manitoba$NAME_1 %in% c("Manitoba")]
plot(Manitoba)
plot(G, add = TRUE, rescale = FALSE)
MB.bbox <- bbox(MB)
xlim <- range(MB.bbox)
ylim <- range(MB.bbox)
plot(MB, xlim=xlim, ylim=ylim)
