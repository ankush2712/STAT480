options(scipen=999)

# Analysis for Diverted Flights
# The code to generate diverted_flights.csv and totalflights_dest.csv are provided in a separate shell script
library(ggmap)
library(dplyr)
library(maps)
diverted <- read.csv("diverted_flights.csv", header = TRUE)
airports <- read.csv("airports.csv", header = TRUE)

# Number of Diverted Flights Across the years
table(diverted$year)

# Bar chart for number of diverted flights across different months
diverted %>% group_by(month, year) %>% summarise(count = n()) %>% select(month, year, count) -> diverted_monthly
diverted_monthly$year <- as.factor(diverted_monthly$year)
monthly_diversion <- ggplot(diverted_monthly, aes(month, count)) +
  geom_bar(stat = "identity", aes(fill = year), position = "dodge") +
  scale_x_discrete(limits=c(1:12)) +
  xlab("Month") +
  ylab("No. Of Diverted Flights") +
  ggtitle("#Diverted Flights by Months")

# Trend in number of diverted flights by carrier for each year
diverted %>% group_by(uniquecarrier, year) %>% summarise(count = n()) %>% select(uniquecarrier, year, count) %>% arrange(year, desc(count)) -> diverted_carrier
diverted_carrier$year <- as.factor(diverted_carrier$year)
carrier_diversion <- ggplot(diverted_carrier, aes(uniquecarrier, count)) +
  geom_bar(stat = "identity", aes(fill = year), position = "dodge") +
  xlab("Unique Carrier Code") +
  ylab("No. Of Diverted Flights") +
  ggtitle("#Diverted Flights by Carrier")

top5 <- diverted_carrier %>%
  group_by(year) %>%
  top_n(n = 5, wt = count)

top5 <- cbind(top5[1:5,], top5[6:10,])
top5

# Trends in the diverted flights by location and year
totalflights_dest <- read.csv("totalflights_dest.csv", header = TRUE)
diverted %>% group_by(year, dest) %>% summarise(diverted_flights= n()) %>% select(year, dest, diverted_flights) -> diverted_dest
diverted_dest <- merge(diverted_dest, totalflights_dest, by=c("year","dest"))
map <- get_map(location = 'USA', zoom = 4)

diverted_flights <- merge(airports, diverted_dest, by.x = "iata", by.y = "dest")

diverted_flights_2000 <- diverted_flights[diverted_flights$year==2000,]

diverted_flights_2003 <- diverted_flights[diverted_flights$year==2003,]

mapPoints <- ggmap(map) + geom_point(aes(x = long, y = lat, size = tot_flights, alpha = diverted_flights), data = diverted_flights_2000) + ggtitle("#Diverted Flights for 2000")

mapPoints_2003 <- ggmap(map) + geom_point(aes(x = long, y = lat, size = tot_flights, alpha = diverted_flights), data = diverted_flights_2003) + ggtitle("#Diverted Flights for 2003")

diverted_flights_2000 <-  diverted_flights_2000[with(diverted_flights_2000, order(-diverted_flights)), ]
diverted_flights_2003 <-  diverted_flights_2003[with(diverted_flights_2003, order(-diverted_flights)), ]

diverted %>% group_by(origin, dest) %>% summarise(no_diverted = n()) %>% select(origin, dest, no_diverted) %>% arrange(desc(no_diverted)) -> toppaths
toppaths <- toppaths[1:10,]
diverted %>% group_by(year, origin, dest) %>% summarise(no_diverted = n()) %>% select(year, origin, dest, no_diverted) %>% arrange(desc(no_diverted)) %>% filter(year==2003) -> toppaths_2003