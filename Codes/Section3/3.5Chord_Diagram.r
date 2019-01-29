# Creating chord diagram for network connectivity between regions
library(tidyr)
chord_diagram <- read.csv("chord_diagram.csv", header = TRUE)
x <- spread(chord_diagram, key = dest_region, value = tot_flights) 
x[is.na(x)] <- 0
y <- as.matrix(x[,-1])
rownames(y) = unique(x$origin_region)

chordDiagram(y, directional = TRUE)
