airports<-read.csv("C:/Users/Mayank/Desktop/data_scien/Map Plotting/airports.dat")
colnames(airports)<-c("ID", "name", "city", "country", "IATA_FAA", "ICAO", "lat", "lon", "altitude", "timezone", "DST")
head(airports)

library(rworldmap)

newmap <- getMap(resolution = "low")
plot(newmap,xlim = c(-20, 59), ylim = c(35, 71),asp = 1)
points(airports$lon,airports$lat,col ="red",cex=.6)

routes <- read.csv(C:/Users/Mayank/Desktop/data_scien/Map Plotting/routes.dat",header=F)
colnames(routes) <- c("airline", "airlineID", "sourceAirport", "sourceAirportID", "destinationAirport", "destinationAirportID", "codeshare", "stops", "equipment")
head(routes)

library(plyr)
departures <- ddply(routes, .(sourceAirportID), "nrow")
names(departures)[2] <- "flights"
arrivals <- ddply(routes, .(destinationAirportID), "nrow")
names(arrivals)[2] <- "flights"

airportD <- merge(airports, departures, by.x = "ID", by.y = "sourceAirportID")
airportA <- merge(airports, arrivals, by.x = "ID", by.y = "destinationAirportID")

library(ggmap)
map <- get_map(location = 'Europe', zoom = 4)

mapPoints <- ggmap(map) +
  geom_point(aes(x = lon, y = lat, size = sqrt(flights)), data = airportD, alpha = .5)

mapPointsLegend <- mapPoints +
  scale_area(breaks = sqrt(c(1, 5, 10, 50, 100, 500)), labels = c(1, 5, 10, 50, 100, 500), name = "departing routes")
mapPointsLegend

airportD$type <- "departures"
airportA$type <- "arrivals"
airportDA <- rbind(airportD, airportA)


mapPointsDA <- ggmap(map) +
  geom_point(aes(x = lon, y = lat, size = sqrt(flights)), data = airportDA, alpha = .5)

mapPointsLegendDA <- mapPointsDA +
  scale_area(breaks = sqrt(c(1, 5, 10, 50, 100, 500)), labels = c(1, 5, 10, 50, 100, 500), name = "routes")

mapPointsFacetsDA <- mapPointsLegendDA +
  facet_grid(. ~ type)

mapPointsFacetsDA