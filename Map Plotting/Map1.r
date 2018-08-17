library(ggmap)
library(mapproj)

map <- get_map(location= 'Asia',zoom = 5)
ggmap(map)